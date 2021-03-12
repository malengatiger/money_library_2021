import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/snack.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:money_library_2021/widgets/avatar.dart';

import 'mobile_registration.dart';

class SelfieUpload extends StatefulWidget {
  final Client client;
  final Agent agent;
  final PageListener pageListener;

  const SelfieUpload(
      {Key key, this.client, this.agent, @required this.pageListener})
      : super(key: key);
  @override
  _SelfieUploadState createState() => _SelfieUploadState();
}

class _SelfieUploadState extends State<SelfieUpload> {
  File _selfieFile;
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

  _getCache() async {
    _clientCache = await Prefs.getClientCache();
    if (_clientCache != null) {
      if (_clientCache.selfiePath != null) {
        _selfieFile = File(_clientCache.selfiePath);
        if (_selfieFile != null) {
          _clientCache.idBackPath = _selfieFile.path;
          Prefs.saveClientCache(_clientCache);
        }
      }
      _id = _clientCache.client.clientId;
    } else {
      p('😡 😡 😡 ClientCache not found, this may be a problem. Or not.');
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getSelfie() async {
    // _selfieFile = await ImagePicker.pickImage(
    //     source: ImageSource.camera,
    //     maxHeight: 400,
    //     maxWidth: 400,
    //     imageQuality: 100);
    // if (_selfieFile != null) {
    //   var len = await _selfieFile.length();
    //   p('🍎 idBack file size: $len bytes; 🧩 Must not exceed maximum permitted size of 1,048,576 bytes (1 MB).');
    //   _clientCache.selfiePath = _selfieFile.path;
    //   Prefs.saveClientCache(_clientCache);
    //   setState(() {});
    //   p('🚺 🚺 🚺 SelfieUpload - 💚 looks like the job is done. selfiePath saved');
    // }
  }

  Future _uploadSelfie() async {
    p('.... 💧💧💧 Preparing to upload Selfie ... $_id');
    if (_selfieFile == null) {
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: 'Please get Selfie');
      return;
    }
    p('💧💧💧 Calling NetUtil ... $_id ........');
    setState(() {
      isBusy = true;
    });
    try {
      var resp = await NetUtil.uploadSelfie(id: _id, selfie: _selfieFile);
      p(resp);
      AppSnackBar.showSnackBar(
          scaffoldKey: _key,
          message: 'Selfie uploaded OK',
          textColor: Colors.greenAccent,
          backgroundColor: Colors.black);
    } catch (e) {
      p('😈😈😈😈 Boss, we done fucked, 😈😈 shit don\'t work!');
      AppSnackBar.showErrorSnackBar(
          scaffoldKey: _key, message: 'Boss, we no can upload');
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
                        'Selfie',
                        style: Styles.blackBoldMedium,
                      ),
                    ),
                    _selfieFile == null
                        ? RoundAvatar(
                            path: 'assets/images/person1.png',
                            radius: 300,
                            margin: 20,
                            marginColor: baseColor,
                            fromNetwork: false)
                        : RoundAvatar(
                            path: _selfieFile.path,
                            radius: 300,
                            fromNetwork: false),
                    Spacer(),
                    RaisedButton(
                      color: Colors.pink[300],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Open Camera for Selfie',
                          style: Styles.whiteSmall,
                        ),
                      ),
                      onPressed: () {
                        p('🍎  🍎 🍎  Get Selfie from camera ... ');
                        _getSelfie();
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
        _getSelfie();
        break;
      case 1:
        _uploadSelfie();
        break;
    }
  }
}
