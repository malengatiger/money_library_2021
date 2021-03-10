import 'package:flutter/material.dart';
import 'package:money_library_2021/models/owzo_request.dart';
import 'package:money_library_2021/ui/payments/ozow_webview.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';

class OzowTester extends StatefulWidget {
  @override
  _OzowTesterState createState() => _OzowTesterState();
}

class _OzowTesterState extends State<OzowTester> {
  @override
  void initState() {
    super.initState();
  }

  _startTest() async {
    p('🔆 🔆 🔆 ... Starting the Owzo Payment Request Test ... 🔆');
    var req = OwzoPaymentRequest(
        amount: 18.00,
        transactionReference: 'Ref003',
        bankReference: 'BankRef003',
        isTest: false,
        customer: 'KingTiger23');
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            curve: Curves.easeInOut,
            duration: Duration(seconds: 1),
            child: OzowWebView(
              paymentRequest: req,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Owzo Payment Request Tester',
          style: Styles.whiteSmall,
        ),
        bottom: PreferredSize(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                )
              ],
            ),
            preferredSize: Size.fromHeight(200)),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: 400,
            child: Card(
                elevation: 2,
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 160,
                        ),
                        Text(
                          'Ozow Payment Request',
                          style: Styles.blackBoldMedium,
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        RaisedButton(
                          onPressed: _startTest,
                          elevation: 8,
                          color: Colors.indigo[400],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Start the Test',
                              style: Styles.whiteSmall,
                            ),
                          ),
                        ),
                      ],
                    ))),
          ),
        ],
      ),
    ));
  }
}
