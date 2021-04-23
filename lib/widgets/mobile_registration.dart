import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/bloc/agent_bloc.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/snack.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/id_upload.dart';
import 'package:money_library_2021/widgets/proof_residence_upload.dart';
import 'package:money_library_2021/widgets/selfie_upload.dart';
import 'package:uuid/uuid.dart';

class RegistrationMobile extends StatefulWidget {
  @override
  _RegistrationMobileState createState() => _RegistrationMobileState();
}

class _RegistrationMobileState extends State<RegistrationMobile>
    implements SnackBarListener, PageListener {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isBusy = false;
  final _controller = PageController();
  Client? _client = Client.create();
  ClientCache? _clientCache;
  Anchor? _anchor;
  Uuid _uuid = Uuid();
  double? currentPageValue = 0.0;
  bool formComplete = false,
      idUploaded = false,
      selfieUploaded = false,
      proofOfResidenceUploaded = false;
  double _dotPosition = 0;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          currentPageValue = _controller.page;
          _dotPosition = _controller.page!.floor() * 1.0;
        });
      }
    });
    _getAnchor();
  }

  _getCache() async {
    p('⭐️⭐️⭐️ Getting cache for old data input ...');
    _clientCache = await Prefs.getClientCache();
    if (_clientCache != null) {
      _client = _clientCache!.client;
      //todo - update form with stuff from client ....
    } else {
      _client!.clientId = _uuid.v4();
      _client!.anchorId = _anchor == null ? null : _anchor!.anchorId;
      _clientCache = ClientCache(client: _client);
      Prefs.saveClientCache(_clientCache!);
    }
  }

  _getAnchor() async {
    p('Getting anchor from cache or Database');
    _anchor = await agentBloc.getAnchor();
    if (_anchor != null) {
      _getCache();
    }
  }

  _goToNextPage() {
    p('🍎 🍎 🍎 🍎 _goToNextPage using PageController  🍎 🍎 🍎 🍎  ........ ');
    int currentPage = currentPageValue!.floor();
    switch (currentPage) {
      case 0:
        _controller.animateToPage(1,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
        break;
      case 1:
        _controller.animateToPage(2,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
        break;
      case 2:
        _controller.animateToPage(0,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
        break;
    }
  }

  _goToPreviousPage() {
    p('_goToPreviousPage using PageController  ');
    int? currentPage = currentPageValue as int?;
    switch (currentPage) {
      case 0:
//        _controller.animateToPage(1,
//            duration: Duration(seconds: 1), curve: Curves.easeInOut);
        break;
      case 1:
        _controller.animateToPage(0,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
        break;
      case 2:
        _controller.animateToPage(1,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
        break;
    }
  }

  _submit() async {
    p('🚺 🚺 🚺 🚺 🚺 🚺 Submit client only after validating the input');
    _clientCache = await Prefs.getClientCache();
    if (_clientCache!.idFrontPath == null || _clientCache!.idBackPath == null) {
      if (currentPageValue != 1.0) {
        _controller.animateToPage(1,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
      }
      _errorSnack('ID document not complete');
      return;
    } else {
      p('🥣 🥣 ID Documentation found for submission');
    }
    if (_clientCache!.selfiePath == null) {
      if (currentPageValue != 2.0) {
        _controller.animateToPage(2,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
      }
      _errorSnack('Selfie is missing');
      return;
    } else {
      p('🥣 🥣 Selfie found for submission');
    }
    if (_clientCache!.client!.password == null) {
      if (currentPageValue != 0.0) {
        _controller.animateToPage(0,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
      }
      _errorSnack('Password is missing');
      return;
    } else {
      p('🥣 🥣 Password found for submission');
    }
    if (_clientCache!.client!.personalKYCFields == null) {
      if (currentPageValue != 0.0) {
        _controller.animateToPage(0,
            duration: Duration(seconds: 1), curve: Curves.easeInOut);
      }
      _errorSnack('KYC fields are missing');
      return;
    } else {
      if (_clientCache!.client!.personalKYCFields!.firstName == null ||
          _clientCache!.client!.personalKYCFields!.lastName == null ||
          _clientCache!.client!.personalKYCFields!.mobileNumber == null ||
          _clientCache!.client!.personalKYCFields!.emailAddress == null) {
        if (currentPageValue != 0.0) {
          _controller.animateToPage(0,
              duration: Duration(seconds: 1), curve: Curves.easeInOut);
        }
        _errorSnack('Personal fields are missing');
        return;
      } else {
        p('🥣 🥣 Personal KYC fields found for submission');
      }
    }
    _clientCache!.client!.active = false;
    p('☘️ everything checks out .... 🥣 🥣 🥣 🥣  CLIENT data is ready for submission ...');
    p(' 🔆 Check all fields from ClientCache: 🧩🧩🧩 ${_clientCache!.toJson()}');
    try {
      p(' 🔆 RegistrationMobile: starting ID upload ..');
      var idResult = await NetUtil.uploadIDDocuments(
          id: _clientCache!.client!.clientId!,
          idFront: File(_clientCache!.idFrontPath!),
          idBack: File(_clientCache!.idBackPath!));

      p(' 🔆 RegistrationMobile: starting selfie upload ..');
      var selfieResult = await NetUtil.uploadSelfie(
          id: _clientCache!.client!.clientId!,
          selfie: File(_clientCache!.selfiePath!));

      p(' 🔆 RegistrationMobile: starting actual registration ..');
      var mResult = await NetUtil.post(
          apiRoute: 'registerClient', bag: _clientCache!.client!.toJson());

      p(idResult);
      p(selfieResult);
      p(mResult);
      AppSnackBar.showSnackBar(
          scaffoldKey: _key,
          message: 'Client registered successfully',
          textColor: Colors.lightBlue,
          backgroundColor: Colors.black);
    } catch (e) {
      p(e);
      _errorSnack('Registration Failed: $e');
    }
  }

  _errorSnack(String? message) {
    AppSnackBar.showErrorSnackBar(scaffoldKey: _key, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _key,
        backgroundColor: baseColor,
        appBar: AppBar(
          elevation: 0,
          leading: Container(),
          backgroundColor: baseColor,
          bottom: PreferredSize(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Submit Registration',
                            style: Styles.whiteSmall,
                          ),
                        ),
                        onPressed: () {
                          p('🚺 🚺 🚺 🚺 🚺 🚺 Submit Registration ... check and validate client cache  😡  😡');
                          _submit();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DotsIndicator(
                    dotsCount: 4,
                    position: _dotPosition,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(60)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: PageView(
            controller: _controller,
            children: <Widget>[
              RegistrationForm(
                client: _client,
                pageListener: this,
              ),
              IDUpload(
                client: _client,
                pageListener: this,
              ),
              SelfieUpload(client: _client, pageListener: this),
              ProofOfResidenceUpload(client: _client, pageListener: this),
            ],
          ),
        ),
      ),
      onWillPop: () => doNothing(),
    );
  }

  Future<bool> doNothing() async {
    return false;
  }

  @override
  onActionPressed(int? action) {
    return null;
  }

  @override
  onIDUploaded() {
    p('💙 onIDUploaded ...');
    return null;
  }

  @override
  onProofOfResidenceUploaded() {
    p('🍐 onProofOfResidenceUploaded ...');
    return null;
  }

  @override
  onRegistrationFormComplete() {
    p('🍎 onRegistrationFormComplete ...');
    return null;
  }

  @override
  onSelfieUploaded() {
    p('onSelfieUploaded ...');
    return null;
  }

  @override
  onCancel() {
    p('onCancel ...');
    return null;
  }

  @override
  onNext(String currentPage) {
    p('🍐  🍐  🍐 onNext ... CurrentPageDesc: $currentPage ....');
    _goToNextPage();
  }

  @override
  onPrevious(String currentPage) {
    p('🍎 🍎 🍎 onPrevious ... CurrentPageDesc: $currentPage');
    _goToPreviousPage();
  }
}

class RegistrationForm extends StatefulWidget {
  final Client? client;
  final PageListener pageListener;

  const RegistrationForm(
      {Key? key, required this.client, required this.pageListener})
      : super(key: key);
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with SingleTickerProviderStateMixin {
  TextEditingController emailCntr = TextEditingController();
  TextEditingController pswdCntr = TextEditingController();
  TextEditingController fNameCntr = TextEditingController();
  TextEditingController lNameCntr = TextEditingController();
  TextEditingController cellphoneCntr = TextEditingController();

  late AnimationController titleController;
  late Animation titleAnimation, btnAnimation;
  ClientCache? _clientCache;
  Client? _client;

  bool isBusy = false;
  Animation<double>? boxAnimation;
  Animation<double>? classificationAnimation;
  Animation<Offset>? pulseAnimation;
  Animation<Offset>? meanAnimation;
  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _client = widget.client;
    }

    _setUpAnimation();
    _getCache();
  }

  _setUpAnimation() {
    titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    titleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: titleController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut)));
    btnAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: titleController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut)));

    titleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        p(".......... 💦 💦 💦 Title Animation completed");
      }
    });

    titleController.forward();
  }

  _getCache() async {
    p('_RegistrationFormState: ⭐️⭐️⭐️ Getting cache for old data input ...');
    _clientCache = await Prefs.getClientCache();
    if (_clientCache != null) {
      _client = _clientCache!.client;
      _fillForm();
    }
    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  var _key = GlobalKey<ScaffoldState>();

  void _onTextChanged(String value) {
    p(' 🍎  🍎 some text entered on keyboard ... : $value');
    if (_client!.personalKYCFields == null) {
      _client!.personalKYCFields = PersonalKYCFields.create();
    }
    _client!.personalKYCFields!.firstName = fNameCntr.text;
    _client!.personalKYCFields!.lastName = lNameCntr.text;
    _client!.personalKYCFields!.emailAddress = emailCntr.text;
    _client!.personalKYCFields!.mobileNumber = cellphoneCntr.text;
    _client!.password = pswdCntr.text;
    _clientCache!.client = _client;
    Prefs.saveClientCache(_clientCache!);
  }

  void _fillForm() {
    p(' 🍎  🍎 filling the form from cache ...');
    if (_client!.personalKYCFields != null) {
      if (_client!.personalKYCFields!.emailAddress != null) {
        emailCntr.text = _client!.personalKYCFields!.emailAddress!;
      }
      if (_client!.personalKYCFields!.firstName != null) {
        fNameCntr.text = _client!.personalKYCFields!.firstName!;
      }
      if (_client!.personalKYCFields!.lastName != null) {
        lNameCntr.text = _client!.personalKYCFields!.lastName!;
      }
    }
    if (_client!.password != null) {
      pswdCntr.text = _client!.password!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                color: baseColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 2,
                      ),
                      ScaleTransition(
                        scale: titleAnimation as Animation<double>,
                        alignment: Alignment(0.0, 0.0),
                        child: GestureDetector(
                          onTap: () {
                            titleController.reset();
                            titleController.forward();
                          },
                          child: Row(
                            children: <Widget>[
                              Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  'assets/logo/logo.png',
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Client Registration',
                                style: Styles.blackBoldMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        onChanged: _onTextChanged,
                        keyboardType: TextInputType.text,
                        controller: fNameCntr,
                        style: Styles.blueBoldSmall,
                        decoration: InputDecoration(
                            hintText: 'Enter First Name',
                            labelText: 'First Name'),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        onChanged: _onTextChanged,
                        keyboardType: TextInputType.text,
                        controller: lNameCntr,
                        style: Styles.blueBoldSmall,
                        decoration: InputDecoration(
                            hintText: 'Enter Last Name',
                            labelText: 'Last Name'),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        onChanged: _onTextChanged,
                        keyboardType: TextInputType.phone,
                        controller: cellphoneCntr,
                        style: Styles.blackBoldSmall,
                        decoration: InputDecoration(
                            hintText: 'Enter Cellphone Number',
                            labelText: 'Cellphone Number'),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        onChanged: _onTextChanged,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailCntr,
                        style: Styles.blueBoldSmall,
                        decoration: InputDecoration(
                            hintText: 'Enter  email address',
                            labelText: 'Email'),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextField(
                        onChanged: _onTextChanged,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: pswdCntr,
                        decoration: InputDecoration(
                            hintText: 'Enter password', labelText: 'Password'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ScaleTransition(
                        scale: btnAnimation as Animation<double>,
                        child: Container(
                          height: 60,
                          width: 300,
                          decoration: BoxDecoration(
                              boxShadow: customShadow,
                              color: Colors.brown[100]),
                          child: isBusy
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : FlatButton(
                                  onPressed: () {
                                    p('💙 tapped to go logging in ... 🥨 🥨 widget.pageListener.onNext to be called ... ');
                                    widget.pageListener.onNext('clientForm');
                                  },
                                  child: Text(
                                    "Next, or swipe to go",
                                    style: Styles.blackBoldSmall,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

abstract class PageListener {
  onRegistrationFormComplete();
  onIDUploaded();
  onProofOfResidenceUploaded();
  onSelfieUploaded();
  onNext(String currentPage);
  onPrevious(String currentPage);
  onCancel();
}
