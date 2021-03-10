import 'package:flutter/material.dart';
import 'package:money_library_2021/models/payfast_request.dart';
import 'package:money_library_2021/ui/payments/payfast_webview.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:page_transition/page_transition.dart';

class PayfastTester extends StatefulWidget {
  @override
  _PayfastTesterState createState() => _PayfastTesterState();
}

class _PayfastTesterState extends State<PayfastTester> {
  @override
  void initState() {
    super.initState();
  }

  _startTest() async {
    p('🔆 🔆 🔆 ... Starting the PayFast Payment Request Test ... 🔆');
    var mRequest = PayFastRequest(
        buyerDetails: null,
        transactionDetails: PayFastTransactionDetails(
            amount: 13.50, paymentId: '12345678', itemName: "TaxiYam"));

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.scale,
            curve: Curves.easeInOut,
            duration: Duration(seconds: 1),
            child: PayFastWebView(
              payFastRequest: mRequest,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'PayFast Payment Request Tester',
          style: Styles.whiteSmall,
        ),
        backgroundColor: Colors.indigo[400],
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
                          'PayFast Payment Request',
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
