import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/stitch/models.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/snack.dart';
import 'package:money_library_2021/util/util.dart';
//We are going to use the google client for this example...
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class StitchPaymentPage extends StatefulWidget {
  @override
  _StitchPaymentPageState createState() => _StitchPaymentPageState();
}

class _StitchPaymentPageState extends State<StitchPaymentPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  GoogleOAuth2Client? client;
  OAuth2Helper? oauth2Helper;
  var url = 'https://secure.stitch.money/connect/authorize';
  var clientId = 'test-3e463858-6832-49f3-a598-b2e4a9e14113';
  String? paymentRequestResponse;
  // var _type = UniLinksType.string;
  late StreamSubscription _sub;
// Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     if (_type == UniLinksType.string) {
//       await initPlatformStateForStringUniLinks();
//     } else {
//       await initPlatformStateForUriUniLinks();
//     }
//   }

  Future<Null> initUniLinks() async {
    p('$mm .............. listening to uniLinks stream');
    // _sub = getLinksStream().listen((String link) {
    //   p('$mm listen fired: $link');
    // }, onError: (err) {
    //   p(err);
    // });
    _sub.onData((data) {
      p('$mm LinksStream subscription onData fired: $data');
      // https://blackox-anchor-cgquhgy5vq-ew.a.run.app/anchor/api/v1/receiveStitchPaymentRequestResponse?id=cGF5cmVxLzRjMmU3NmRkLTg2ZWUtNGM5NC1iZmNhLWIwMWQ1ZDlhMzRhZg%3d%3d&status=complete
      String mData = data as String;
      int i = mData.indexOf("=");
      int j = mData.indexOf("&");
      paymentId = mData.substring(i + 1, j);
      p('$mm paymentId: $paymentId $mm');
      //
      var index = mData.lastIndexOf('=');
      if (index > 0) {
        paymentStatus = mData.substring(index + 1);
        p('$mm paymentStatus: $paymentStatus $mm');
      }
      _sendPaymentStatus();
      if (mounted) {
        p('$mm .............. setting state .........');
        setState(() {});
      }
      //todo - send this id and status to backend - write ZARK to user account
    });
    _sub.onDone(() {
      p('$mm sub onDone ....');
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  void _sendPaymentStatus() async {
    p('$mm  sending PaymentStatus ... ');
    var rec = StitchPaymentStatusRecord(
        paymentId: paymentId,
        stellarAccountId: "stellarAccountId",
        amount: amtController.text,
        status: paymentStatus,
        date: DateTime.now().toIso8601String());

    p('$mm sending StitchPaymentStatusRecord .... ${rec.toJson()}');
    String? stitchResponseJSON = await (NetUtil.post(
        apiRoute: 'addStablecoinToAccount', bag: rec.toJson()) as FutureOr<String?>);
    p('$mm addStablecoinToAccount response: $stitchResponseJSON');
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    initUniLinks();
  }

  static const mm = 'StitchPage: 🌺 🌺 🌺 ';
  bool busy = false;
  var _key = GlobalKey<ScaffoldState>();
  String? authCode;
  String? paymentRequestURL;

  @override
  void dispose() {
    _controller.dispose();
    _sub.cancel();
    super.dispose();
  }

  void _getPaymentRequestURL() async {
    p('$mm ........ _getPaymentRequestURL from Stitch ...');
    setState(() {
      busy = true;
    });
    try {
      Map<String, dynamic> stitchResponseJSON = await (NetUtil.getWithNoAuth(
          apiRoute:
              'createPaymentRequest?amount=${amtController.text}&currency=ZAR&reference=${referenceController.text}',
          mTimeOut: 90000) as FutureOr<Map<String, dynamic>>);
      StitchResponse stitchResponse =
          StitchResponse.fromJson(stitchResponseJSON);

      if (stitchResponse.errors == null) {
        paymentRequestURL = stitchResponse.paymentRequest!.url;
        paymentRequestURL!.trimLeft();
        paymentRequestURL!.trimRight();
        p('🔑 🔑 🔑 🔑 payment request generated : 🔑 🔑 🔑 🔑  url: $paymentRequestURL');
        startBrowser();
      } else {
        StringBuffer buffer = StringBuffer();
        stitchResponse.errors!.forEach((element) {
          buffer.writeln(element.toJson());
        });
        AppSnackBar.showErrorSnackBar(
            scaffoldKey: _key, message: buffer.toString());
      }
    } catch (e) {
      p(e);
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: 'Failed to get Payment Request');
    }

    setState(() {
      busy = false;
    });
  }

  String? paymentStatus, paymentId;

  var amtController = TextEditingController(text: "115.00");
  var referenceController = TextEditingController(
      text:
          '${(DateTime.now().millisecondsSinceEpoch / (1000 * 60 * 60)).toStringAsFixed(3)}');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Stitch API Tester',
            style: Styles.whiteSmall,
          ),
          bottom: PreferredSize(
              child: Column(
                children: [
                  Text(
                    'Stitch Payment Request Test',
                    style: Styles.whiteBoldMedium,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(120)),
        ),
        backgroundColor: Colors.brown[100],
        body: busy
            ? Center(
                child: Container(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    backgroundColor: Colors.amber,
                  ),
                ),
              )
            : paymentStatus == null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: SingleChildScrollView(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                TextFormField(
                                  controller: amtController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  style: Styles.blackBoldLarge,
                                  decoration: InputDecoration(
                                      labelText: 'Amount',
                                      labelStyle: Styles.greyLabelMedium,
                                      hintText: 'Enter Amount',
                                      icon: Icon(Icons.monetization_on)),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                TextFormField(
                                  controller: referenceController,
                                  keyboardType: TextInputType.text,
                                  style: Styles.blackBoldSmall,
                                  decoration: InputDecoration(
                                      labelText: 'Reference',
                                      labelStyle: Styles.greyLabelMedium,
                                      hintText: 'Enter Reference',
                                      icon: Icon(Icons.edit)),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                ElevatedButton(
                                  onPressed: _getPaymentRequestURL,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      'Start Payment',
                                      style: Styles.whiteSmall,
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
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 400,
                          height: 200,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Payment Status',
                                style: Styles.blackBoldMedium,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 64.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.add_shopping_cart),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    Text(
                                      paymentStatus!,
                                      style: Styles.pinkBoldMedium,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                '$paymentId',
                                style: Styles.blueBoldSmall,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  void startBrowser() async {
    p('🔆 🔆 🔆 🔆 🔆 🔆 🔆 🔆  starting browser with $paymentRequestURL 🔆 🔆 🔆 🔆');

    if (await canLaunch(paymentRequestURL!)) {
      await launch(paymentRequestURL!);
      p('🔆 🔆 🔆 🔆 🔵 🔵 🔵 🔵 🔵 🔵  browser launched with $paymentRequestURL 🔵 🔵');
    } else {
      throw '🔆 🔆  Could not launch $paymentRequestURL';
    }
  }

  void _onPageStarted(String url) {
    p('💙 💙 page started: $url');
  }

  void _onPageFinished(String url) {
    p('💙 💙 page finished: $url');
  }
}

/*
adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://anchor-cgquhgy5vq-ew.a.run.app:"'

 */
