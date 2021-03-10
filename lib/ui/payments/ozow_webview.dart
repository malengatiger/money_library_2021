import 'dart:async';

import 'package:flutter/material.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/owzo_request.dart';
import 'package:money_library_2021/ui/payments/success.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OzowWebView extends StatefulWidget {
  final OwzoPaymentRequest paymentRequest;

  const OzowWebView({Key key, this.paymentRequest}) : super(key: key);
  @override
  _OzowWebViewState createState() => _OzowWebViewState();
}

/*
localhost:8080/sendPaymentRequest?isTest=true&registerTokenProfile=true&transactionReference=TransactionRef 123&amount=379.84&bankReference=BankRef Tiger&customer=OriginalCustomer&token=none

 2020-05-13 00:02:29.983  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🔵 🔵 URL for request: https://pay.ozow.com/
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 🐱 🐱 Parameters sent with request
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: SiteCode : TSTSTE0001
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: CountryCode : ZA
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: CurrencyCode : ZAR
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: Amount : 373.85
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: TransactionReference : TranxRef001
2020-05-13 00:02:29.987  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: BankReference : BankRefX
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: Customer : TheOGCustomer
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: CancelUrl : https://npservices-c4kwri5qva-ew.a.run.app/ozow_cancel
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: ErrorUrl : https://npservices-c4kwri5qva-ew.a.run.app/ozow_error
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: SuccessUrl : https://npservices-c4kwri5qva-ew.a.run.app/ozow_success
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: NotifyUrl : https://npservices-c4kwri5qva-ew.a.run.app/ozow_notify
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: isTest : true
2020-05-13 00:02:29.988  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱 Parameter: HashCheck : e4ccf3fca05ea50f8bac0d04b7008a590db37be5167c28ba67360cfbf243edf180572fc981911b115ab0b0ce9c9d7056dc36b8f260657419c6b62a1ffc6f2f66
2020-05-13 00:02:29.995  INFO 14879 --- [nio-8080-exec-1] NetService                               : 🐱 🐱  request uri: https://pay.ozow.com/
2020-05-13 00:02:30.735  INFO 14879 --- [nio-8080-exec-1] NetService                               : 💙 💙 💜 Response StatusLine: HTTP/1.1 302 Found
2020-05-13 00:02:30.735  INFO 14879 --- [nio-8080-exec-1] NetService                               : 👌🏾 👌🏾 Ozow responded with a RE_DIRECTION status code = 302 🍎 Found🔵


 */

class _OzowWebViewState extends State<OzowWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

//  var url =
//      'https://pay.ozow.com?SiteCode=TSTSTE0001&CountryCode=ZA&CurrencyCode=ZAR&Amount=373.85&TransactionReference=TranxRef001&BankReference=BankRefX&'
//      'Customer=TheOGCustomer&CancelUrl=https://npservices-c4kwri5qva-ew.a.run.app/ozow_cancel&ErrorUrl=https://npservices-c4kwri5qva-ew.a.run.app/ozow_error&SuccessUrl=https://npservices-c4kwri5qva-ew.a.run.app/ozow_success&'
//      'NotifyUrl=https://npservices-c4kwri5qva-ew.a.run.app/ozow_notify&isTest=true&HashCheck=e4ccf3fca05ea50f8bac0d04b7008a590db37be5167c28ba67360cfbf243edf180572fc981911b115ab0b0ce9c9d7056dc36b8f260657419c6b62a1ffc6f2f66';
  @override
  void initState() {
    super.initState();
    _checkInput();
    _buildUrl();
  }

  _checkInput() {
    assert(widget.paymentRequest != null);
    assert(widget.paymentRequest.amount != null);
    assert(widget.paymentRequest.transactionReference != null);
    assert(widget.paymentRequest.bankReference != null);
    assert(widget.paymentRequest.customer != null);
    assert(widget.paymentRequest.isTest != null);
    p('🌀🌀 Payment Request has been validated: 🌀🌀${widget.paymentRequest.toJson()}🌀🌀');
  }

  String mURL;
  _buildUrl() async {
    p('🌀 🔆 🔆 Building the concatenated ozow url for a payment request ...');
    var hashed = await NetUtil.getOwzoHash(
        request: widget.paymentRequest, context: context);
    var ozowUrl = await getOwzoUrl();
    var successUrl = await getOwzoSuccessUrl();
    var errorUrl = await getOwzoErrorUrl();
    var notifyUrl = await getOwzoNotifyUrl();
    var cancelUrl = await getOwzoCancelUrl();
    var siteCode = await getOwzoSiteCode();
    var countryCode = await getCountryCode();
    var currencyCode = await getCurrencyCode();

    var sb = StringBuffer();
    sb.write('$ozowUrl?');
    sb.write('SiteCode=$siteCode&');
    sb.write('CountryCode=$countryCode&');
    sb.write('CurrencyCode=$currencyCode&');
    sb.write(
        'Amount=${getFormattedAmount('${widget.paymentRequest.amount}', context)}&');
    sb.write(
        'TransactionReference=${widget.paymentRequest.transactionReference}&');
    sb.write('BankReference=${widget.paymentRequest.bankReference}&');
    sb.write('Customer=${widget.paymentRequest.customer}&');
    sb.write('CancelUrl=$cancelUrl&');
    sb.write('ErrorUrl=$errorUrl&');
    sb.write('SuccessUrl=$successUrl&');
    sb.write('NotifyUrl=$notifyUrl&');
    sb.write('isTest=${widget.paymentRequest.isTest ? 'true' : 'false'}&');
    sb.write('HashCheck=$hashed');

    setState(() {
      mURL = sb.toString();
    });
    p('😡 😡 😡 ... Setting the mURL to the concatenation:  💚 $mURL 💚  😡');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Ozow Payment Request",
                style: Styles.whiteSmall,
              ),
            ),
            body: Stack(
              children: <Widget>[
                mURL == null
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Builder(builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: WebView(
                            initialUrl: mURL,
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controller.complete(webViewController);
                            },
                            debuggingEnabled: true,
                            javascriptChannels: <JavascriptChannel>[
                              _toasterJavascriptChannel(context),
                            ].toSet(),
                            navigationDelegate: (NavigationRequest request) {
//                              if (request.url
//                                  .startsWith('https://www.youtube.com/')) {
//                                print('blocking navigation to $request}');
//                                return NavigationDecision.prevent;
//                              }
                              p('NetUtil: 🔆 allowing navigation to $request');
                              return NavigationDecision.navigate;
                            },
                            onPageStarted: (String url) {
                              p(' 🌼  🌼  🌼 Page started loading: $url');
                            },
                            onPageFinished: (String url) {
                              _processReceivedUrl(url, context);
                            },
                            gestureNavigationEnabled: true,
                          ),
                        );
                      }),
              ],
            )));
  }

  void _processReceivedUrl(String url, BuildContext context) {
    p(' 🍎 🍎 🍎 onPageFinished: 🍎 🍎 🍎  Page finished loading; callback from 🌼 owzo : $url 🌼');
    if (url.contains('ozow_success')) {
      p('WE HAVE A 🥬 SUCCESSFUL 🥬 PAYMENT');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OwzoCallbackPage(
                  message: 'Succeeded!',
                  color: Colors.teal[700],
                )),
      );
    }
    if (url.contains('ozow_notify')) {
      p('WE HAVE A 💙💙 NOTIFY 💙💙 CALLBACK');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OwzoCallbackPage(
                  message: 'Notified',
                  color: Colors.blue[600],
                )),
      );
    }
    if (url.contains('ozow_error')) {
      p('WE HAVE AN 🍊🍊🍊 ERROR 🍊 CALLBACK');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OwzoCallbackPage(
                  message: 'Error Happened',
                  color: Colors.pink[700],
                )),
      );
    }
    if (url.contains('ozow_cancel')) {
      p('WE HAVE A 🍐🍐 CANCELLED 🍐🍐 PAYMENT');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OwzoCallbackPage(
                  message: 'Cancelled',
                  color: Colors.grey[400],
                )),
      );
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
