import 'dart:ui';

import 'package:flutter/material.dart';

class OwzoCallbackPage extends StatefulWidget {
  final String message;
  final Color color;

  const OwzoCallbackPage({Key key, this.message, this.color}) : super(key: key);

  @override
  _OwzoCallbackPageState createState() => _OwzoCallbackPageState();
}

class _OwzoCallbackPageState extends State<OwzoCallbackPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "owzo Callback Result",
          style: TextStyle(fontWeight: FontWeight.w200),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Card(
              elevation: 16,
              color:
                  widget.message == 'success' ? Colors.teal[200] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.message == null ? 'Fucked!' : widget.message,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color:
                          widget.color == null ? Colors.black : widget.color),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
