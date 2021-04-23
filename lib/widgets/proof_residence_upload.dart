import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';

import 'mobile_registration.dart';

class ProofOfResidenceUpload extends StatefulWidget {
  final Client client;
  final Agent agent;
  final PageListener pageListener;

  const ProofOfResidenceUpload(
      {Key key, this.client, this.agent, this.pageListener})
      : super(key: key);
  @override
  _ProofOfResidenceUploadState createState() => _ProofOfResidenceUploadState();
}

class _ProofOfResidenceUploadState extends State<ProofOfResidenceUpload> {
  File _proofOfResidenceFile;
  String _id, _name;
  bool isBusy = false;
  List<BottomNavigationBarItem> _items = [];
  var _key = GlobalKey<ScaffoldState>();
  ClientCache _clientCache;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _id = widget.client.clientId;
      _name = widget.client.personalKYCFields == null
          ? null
          : widget.client.personalKYCFields.getFullName();
    }
    if (widget.agent != null) {
      _id = widget.agent.agentId;
      _name = widget.agent.personalKYCFields == null
          ? null
          : widget.agent.personalKYCFields.getFullName();
    }
    _getCache();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getCache() async {
    _clientCache = await Prefs.getClientCache();
    if (_clientCache != null) {
      if (_clientCache.proofOfResidencePath != null) {
        _proofOfResidenceFile = File(_clientCache.proofOfResidencePath);
      }
      _id = _clientCache.client.clientId;
    } else {
      p('😡 😡 😡 ClientCache not found, this may be a problem. Or not.');
    }
    setState(() {});
  }

  // Future _getPDFFile() async {
  //   _proofOfResidenceFile = await FilePicker.platform();
  //   if (_proofOfResidenceFile != null) {
  //     _clientCache.proofOfResidencePath = _proofOfResidenceFile.path;
  //     Prefs.saveClientCache(_clientCache);
  //   }
  //   setState(() {});
  // }

  Future _takeImageUsingCamera() async {
    // _proofOfResidenceFile =
    //     await ImagePicker.pickImage(source: ImageSource.camera);
    //
    // if (_proofOfResidenceFile != null) {
    //   _clientCache.proofOfResidencePath = _proofOfResidenceFile.path;
    //   Prefs.saveClientCache(_clientCache);
    // }
    setState(() {});
  }

  Future _uploadFile() async {
    p('.... 💧💧💧 Preparing to upload Selfie ... $_id');
    if (_proofOfResidenceFile == null) {
//      AppSnackBar.showErrorSnackBar(
//          scaffoldKey: _key, message: 'Please get Proof of Residence File');
      return;
    }
    p('💧💧💧 Calling NetUtil ... $_id ........');
    setState(() {
      isBusy = true;
    });
    try {
      var resp = await NetUtil.uploadProofOfResidence(
          id: _id, proofOfResidence: _proofOfResidenceFile);
      p(resp);
//      AppSnackBar.showSnackBar(
//          scaffoldKey: _key,
//          message: 'Proof of Residence uploaded OK',
//          textColor: Colors.greenAccent,
//          backgroundColor: Colors.black);
    } catch (e) {
      p('😈😈😈😈 Boss, we done fucked, 😈😈 shit don\'t work!');
//      AppSnackBar.showErrorSnackBar(
//          scaffoldKey: _key, message: 'Boss, we no can upload');
    }
    setState(() {
      isBusy = false;
    });
  }

  _buildNav() {
    _items.add(BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt), title: Text('Get Selfie')));
    _items.add(BottomNavigationBarItem(
        icon: Icon(Icons.cloud_upload), title: Text('Upload elfie')));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              height: 500,
              decoration:
                  BoxDecoration(boxShadow: customShadow, color: secondaryColor),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Proof Of Residence',
                        style: Styles.blackBoldMedium,
                      ),
                    ),
                    _proofOfResidenceFile == null
                        ? Opacity(
                            child: Image.asset('assets/images/doc2.png'),
                            opacity: 0.2,
                          )
                        : Image.file(_proofOfResidenceFile),
                    Spacer(),
                    ElevatedButton(
                      child: Text(
                        'Upload Proof Of Residence',
                        style: Styles.whiteSmall,
                      ),
                      onPressed: () {
                        p('💙 💙  💙 Upload Proof Of Residence ...');
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ],
    );
  }

  void _onNavTapped(int value) {
    p('navigation button tapped: $value');
    switch (value) {
      case 0:
        _takeImageUsingCamera();
        break;
      case 1:
        _uploadFile();
        break;
    }
  }
}
