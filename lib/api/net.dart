import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:money_library_2021/api/anchor_db.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/fiat_payment_request.dart';
import 'package:money_library_2021/models/owzo_request.dart';
import 'package:money_library_2021/models/path_payment_request.dart';
import 'package:money_library_2021/models/payment_dto.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';

import 'auth.dart';

class NetUtil {
  static var client = http.Client();
  static const Map<String, String> xHeaders = {
    'Content-type': 'application/json',
    'Accept': '*/*',
  };

  static const timeOutInSeconds = 30;

  static Future<Anchor> getAnchor(String anchorId) async {
    p('$bb ........... getAnchor starting ....');
    var resp = await get(apiRoute: "getAnchor?anchorId=$anchorId");
    var anchor = Anchor.fromJson(resp);
    await Prefs.saveAnchor(anchor);
    return anchor;
  }

  static Future<AnchorUser> getAnchorUser(String uid) async {
    p('$bb ....... getAnchorUser starting .... uid: ' + uid);
    var resp = await get(apiRoute: "getAnchorUser?uid=$uid");
    var anchorUser = AnchorUser.fromJson(resp);
    await Prefs.saveAnchorUser(anchorUser);
    return anchorUser;
  }

  static Future<Agent> getAgent(String agentId) async {
    p('$bb getAgent starting ....');
    var resp = await get(apiRoute: "getAgent");
    var agent = Agent.fromJson(resp);
    await Prefs.saveAgent(agent);
    return agent;
  }

  static Future<List<Agent>> getAgents(String anchorId) async {
    p('$bb getAgents starting ....');
    List<Agent> agents = [];
    List resp = await get(apiRoute: "getAgents?anchorId=$anchorId");
    resp.forEach((element) {
      var agent = Agent.fromJson(element);
      agents.add(agent);
    });
    return agents;
  }

  static Future<Client> getClient(String clientId) async {
    p('$bb getClient starting ....');
    var resp = await get(apiRoute: "getClient?clientId=$clientId");
    var client = Client.fromJson(resp);
    await Prefs.saveClient(client);
    return client;
  }

  static Future<List<Client>> getAgentClients(String agentId) async {
    p('$bb getClient starting ....');
    List resp = await get(apiRoute: "getAgentClients?agentId=$agentId");
    List<Client> list = [];
    resp.forEach((element) async {
      var client = Client.fromJson(element);
      list.add(client);
      await AnchorLocalDB.addClient(client);
    });

    return list;
  }

  static Future<List<Client>> getAnchorClients(String anchorId) async {
    p('$bb getClient starting ....');
    List resp = await get(apiRoute: "getAnchorClients?anchorId=$anchorId");
    List<Client> list = [];
    resp.forEach((element) async {
      var client = Client.fromJson(element);
      list.add(client);
      await AnchorLocalDB.addClient(client);
    });

    return list;
  }

  static Future<StellarAccountBag> getAccountBalances(String accountId) async {
    p('$bb $bb  getAccountBalances starting ....');
    var resp = await get(apiRoute: "getAccountBalances?accountId=$accountId");
    var client = StellarAccountBag.fromJson(resp);
    await AnchorLocalDB.addBalance(accountId: accountId, bag: client);
    return client;
  }

  static Future<List<PaymentDTO>> getAccountPayments(String accountId) async {
    p('$bb $bb  getAccountBalances starting ....');
    List resp = await get(apiRoute: "getAccountPayments?accountId=$accountId");
    List<PaymentDTO> list = [];
    for (var value in resp) {
      var pa = PaymentDTO.fromJson(value);
      await AnchorLocalDB.addPayment(pa);
      list.add(pa);
    }

    return list;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesByAnchor(
          {String anchorId, String fromDate, String toDate}) async {
    p('$bb $bb  getFiatPaymentResponsesByAnchor starting ....');
    List resp = await get(
        apiRoute:
            "getFiatPaymentResponsesByAnchor?anchorId=$anchorId&fromDate=$fromDate&toDate=$toDate");
    List<StellarFiatPaymentResponse> list = [];
    for (var value in resp) {
      var tx = StellarFiatPaymentResponse.fromJson(value);
      await AnchorLocalDB.addStellarFiatPaymentResponse(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesBySourceAccount(String accountId) async {
    p('$bb $bb  getFiatPaymentResponsesBySourceAccount starting ....');
    List resp = await get(
        apiRoute:
            "getFiatPaymentResponsesBySourceAccount?accountId=$accountId");
    List<StellarFiatPaymentResponse> list = [];
    for (var value in resp) {
      var tx = StellarFiatPaymentResponse.fromJson(value);
      await AnchorLocalDB.addStellarFiatPaymentResponse(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesByDestinationAccount(String accountId) async {
    p('$bb $bb  getFiatPaymentResponsesByDestinationAccount starting ....');
    List resp = await get(
        apiRoute:
            "getFiatPaymentResponsesByDestinationAccount?accountId=$accountId");
    List<StellarFiatPaymentResponse> list = [];
    for (var value in resp) {
      var tx = StellarFiatPaymentResponse.fromJson(value);
      await AnchorLocalDB.addStellarFiatPaymentResponse(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesByAsset(
          String assetCode, String fromDate, String toDate) async {
    p('$bb $bb  getFiatPaymentResponsesByAsset starting ....');
    List resp = await get(
        apiRoute: "getFiatPaymentResponsesByAsset?assetCode=$assetCode");
    List<StellarFiatPaymentResponse> list = [];
    for (var value in resp) {
      var tx = StellarFiatPaymentResponse.fromJson(value);
      await AnchorLocalDB.addStellarFiatPaymentResponse(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<PathPaymentRequest>> getPathPaymentRequestsBySourceAccount(
      String accountId) async {
    p('$bb $bb  getPathPaymentRequestsBySourceAccount starting ....');
    List resp = await get(
        apiRoute: "getPathPaymentRequestsBySourceAccount?accountId=$accountId");
    List<PathPaymentRequest> list = [];
    for (var value in resp) {
      var tx = PathPaymentRequest.fromJson(value);
      await AnchorLocalDB.addPathPaymentRequest(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<PathPaymentRequest>>
      getPathPaymentRequestsByDestinationAccount(String accountId) async {
    p('$bb $bb  getPathPaymentRequestsByDestinationAccount starting ....');
    List resp = await get(
        apiRoute:
            "getPathPaymentRequestsByDestinationAccount?accountId=$accountId");
    List<PathPaymentRequest> list = [];
    for (var value in resp) {
      var tx = PathPaymentRequest.fromJson(value);
      await AnchorLocalDB.addPathPaymentRequest(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<PathPaymentRequest>> getPathPaymentByAssetPair(
      String anchorId, String assetFrom, String assetTo) async {
    p('$bb $bb  getPathPaymentByAssetPair starting ....');
    List resp = await get(
        apiRoute:
            "getPathPaymentByAssetPair?anchorId=$anchorId&assetFrom=$assetFrom&assetTo=$assetTo");
    List<PathPaymentRequest> list = [];
    for (var value in resp) {
      var tx = PathPaymentRequest.fromJson(value);
      await AnchorLocalDB.addPathPaymentRequest(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<PathPaymentRequest>> getPathPaymentRequestsByAnchor(
      {String anchorId, String fromDate, String toDate}) async {
    p('$bb $bb  getPathPaymentRequestsByAnchor starting ....');
    List resp = await get(
        apiRoute:
            "getPathPaymentRequestsByAnchor?anchorId=$anchorId&fromDate=$fromDate&toDate=$toDate");
    List<PathPaymentRequest> list = [];
    for (var value in resp) {
      var tx = PathPaymentRequest.fromJson(value);
      await AnchorLocalDB.addPathPaymentRequest(tx);
      list.add(tx);
    }

    return list;
  }

  static Future<List<Balance>> getAnchorBalances() async {
    p('$bb $bb  getAccountBalances starting ....');
    List<Balance> balances = [];
    List<dynamic> resp = await get(apiRoute: "getAnchorBalances");
    p('$bb $bb  getAccountBalances result .... $resp');
    resp.forEach((element) async {
      var bal = Balance.fromJson(element);
      balances.add(bal);
    });

    return balances;
  }

  static Future<String> getOwzoHash(
      {OwzoPaymentRequest request, BuildContext context}) async {
    p('🐳 🐳 Building concatenated string from PaymentRequest ...');
    var privateKey = await getOwzoPrivateKey();
    var site = await getOwzoSiteCode();
    var country = await getCountryCode();
    var currency = await getCurrencyCode();
    var success = await getOwzoSuccessUrl();
    var cancel = await getOwzoCancelUrl();
    var error = await getOwzoErrorUrl();
    var notify = await getOwzoNotifyUrl();
    var sb = StringBuffer();
    sb.write(site.toLowerCase());
    sb.write(country.toLowerCase());
    sb.write(currency.toLowerCase());
    sb.write(
        '${getFormattedAmount('${request.amount}', context)}'.toLowerCase());
    sb.write(request.transactionReference.toLowerCase());
    sb.write(request.bankReference.toLowerCase());
    sb.write(request.customer.toLowerCase());
    sb.write(cancel.toLowerCase());
    sb.write(error.toLowerCase());
    sb.write(success.toLowerCase());
    sb.write(notify.toLowerCase());
    sb.write(request.isTest ? 'true' : 'false');
    sb.write(privateKey.toLowerCase());
    var string = sb.toString();
    p('NetUtil: ⏰ ⏰ ⏰ String to be Hashed on the backend: 🔆 $string ..... 🔆');
    var hashedObject =
        await get(apiRoute: 'getOzowHash?string=${sb.toString()}');
    p('NetUtil: 💚 💚 💚 Hashed result string from backend: 🧩 ${hashedObject['hashed']} 🧩');
    return hashedObject['hashed'];
  }

  static const bb = 'NetUtil: 🔵 🔵 🔵 🔵 🔵 🔵 ';
  static Future momoPost(
      {@required String apiRoute,
      @required Map<String, dynamic> body,
      @required Map<String, String> headers,
      @required int mTimeOut}) async {
    var url = DotEnv.env['devURL'];
    var status = DotEnv.env['status'];
    if (status == 'prod') {
      url = DotEnv.env['prodURL'];
    }

    var dur = Duration(seconds: mTimeOut == null ? timeOutInSeconds : mTimeOut);
    url += apiRoute;
    p('$bb momoPost: '
        '🔆 🔆 🔆 🔆 calling backend:  💙  '
        '$url  💙  ........... ');
    String requestBody;
    if (body != null) {
      requestBody = jsonEncode(body);
    }
    if (requestBody == null) {
      p('$bb momoPost: 👿 Bad moon rising? :( - 👿👿👿 👿 bag is null, may not be a problem ');
    }
    p('$bb  🍏 🍏 requestBody: $requestBody  🍏 🍏');
    var start = DateTime.now();
    // http.Response httpResponse = await http
    //     .post(
    //       url,
    //       headers: headers,
    //       body: requestBody,
    //     )
    //     .timeout(dur);
    //
    // var end = DateTime.now();
    // p('$bb RESPONSE: 💙💙  status: ${httpResponse.statusCode} 💙 body: ${httpResponse.body} 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆');
    // if (httpResponse.statusCode == 200) {
    //   p('$bb momoPost.... : 💙 statusCode: 👌👌👌 ${httpResponse.statusCode} 👌👌👌 💙 '
    //       'for $url 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆');
    //   var mJson = json.decode(httpResponse.body);
    //   return mJson;
    // } else {
    //   p('$bb 🚨🚨🚨🚨🚨🚨 mmoPost failed: ${httpResponse.body}');
    //   throw Exception(
    //       '🚨🚨 Status Code 🚨 ${httpResponse.statusCode} 🚨 ${httpResponse.body}');
    // }
  }

  static Future post({@required String apiRoute, @required Map bag}) async {
    var url = await getBaseUrl();
    String token = 'availableNot';
    try {
      token = await Auth.getAuthToken();
    } catch (e) {
      p('Firebase auth token not available ');
    }
    var mHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var dur = Duration(seconds: timeOutInSeconds);
    apiRoute = url + apiRoute;
    print('$bb: POST:  ................................... 🔵 '
        '🔆 calling backend: 💙 $apiRoute 💙');
    var mBag;
    if (bag != null) {
      mBag = jsonEncode(bag);
    }
    if (mBag == null) {
      p('$bb 👿 Bad moon rising? 👿 bag is null, may not be a problem ');
    }
    p(mBag);
    var start = DateTime.now();
    try {
      var uriResponse =
          await client.post(Uri.parse(apiRoute), body: mBag, headers: mHeaders);
      var end = DateTime.now();
      p('$bb RESPONSE: 💙 status: ${uriResponse.statusCode} 💙 body: ${uriResponse.body}');

      if (uriResponse.statusCode == 200) {
        p('$bb 💙 statusCode: 👌👌👌 ${uriResponse.statusCode} 👌👌👌 💙 '
            'for $apiRoute 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆');
        try {
          var mJson = json.decode(uriResponse.body);
          return mJson;
        } catch (e) {
          return uriResponse.body;
        }
      } else {
        p('$bb 👿👿👿👿👿👿👿👿👿 Bad moon rising ...POST failed! 👿👿  fucking status code: '
            '👿👿 ${uriResponse.statusCode} 👿👿');
        throw Exception(
            '🚨 🚨 Status Code 🚨 ${uriResponse.statusCode} 🚨 body: ${uriResponse.body}');
      }
    } finally {
      // client.close();
    }
  }

  static Future get({@required String apiRoute}) async {
    var url = await getBaseUrl();
    var token = await Auth.getAuthToken();
    var mHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    apiRoute = url + apiRoute;
    p('$bb GET:  🔵 '
        '🔆 .................. calling backend: 💙 $apiRoute  💙');
    var start = DateTime.now();
    // var dur = Duration(seconds: mTimeOut == null ? timeOutInSeconds : mTimeOut);
    try {
      var uriResponse =
          await client.get(Uri.parse(apiRoute), headers: mHeaders);
      var end = DateTime.now();
      p('$bb RESPONSE: 💙 status: ${uriResponse.statusCode} 💙 body: ${uriResponse.body}');

      if (uriResponse.statusCode == 200) {
        p('$bb 💙 statusCode: 👌👌👌 ${uriResponse.statusCode} 👌👌👌 💙 '
            'for $apiRoute 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆');
        try {
          var mJson = json.decode(uriResponse.body);
          return mJson;
        } catch (e) {
          return uriResponse.body;
        }
      } else {
        p('$bb 👿👿👿👿👿👿👿 Bad moon rising ....GET failed! 👿👿 fucking status code: '
            '👿👿 ${uriResponse.statusCode} 👿👿');
        throw Exception(
            '🚨 🚨 Status Code 🚨 ${uriResponse.statusCode} 🚨 body: ${uriResponse.body}');
      }
    } finally {
      // client.close();
    }
  }

  static Future getWithNoAuth(
      {@required String apiRoute, @required int mTimeOut}) async {
    var url = await getBaseUrl();
    var mHeaders = {'Content-Type': 'application/json'};
    apiRoute = url + apiRoute;
    p('$bb getWithNoAuth:  🔆 calling backend:  ............apiRoute: 💙 '
        '$apiRoute  💙');
    var start = DateTime.now();
    try {
      var uriResponse = await client.get(Uri.parse(url), headers: mHeaders);
      var end = DateTime.now();
      p('$bb RESPONSE: 💙 status: ${uriResponse.statusCode} 💙 body: ${uriResponse.body}');
      if (uriResponse.statusCode == 200) {
        p('$bb 💙 statusCode: 👌👌👌 ${uriResponse.statusCode} 👌👌👌 💙 '
            'for $apiRoute 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆');
        try {
          var mJson = json.decode(uriResponse.body);
          return mJson;
        } catch (e) {
          return uriResponse.body;
        }
      } else {
        p('$bb 👿👿👿👿👿👿👿👿👿 Bad moon rising ....  fucking status code: '
            '👿👿 ${uriResponse.statusCode} 👿👿');
        throw Exception(
            '🚨 🚨 Status Code 🚨 ${uriResponse.statusCode} 🚨 body: ${uriResponse.body}');
      }
    } finally {
      client.close();
    }
  }

  static Future uploadIDDocuments(
      {@required String id,
      @required File idFront,
      @required File idBack}) async {
    p('🐸  🐸  🐸 Uploading the front and back of ID document ...');
    var url = await getBaseUrl();
    var finalUrl = url + 'uploadID';
    var frontBytes = await idFront.length();
    var backBytes = await idBack.length();
    p('🐸  🐸  🐸 frontBytes size: $frontBytes bytes ...');
    p('🐸  🐸  🐸 backBytes size: $backBytes bytes ...');
    var frontFile = await http.MultipartFile.fromPath('idFront', idFront.path);
    var backFile = await http.MultipartFile.fromPath('idBack', idBack.path);
    var req = http.MultipartRequest('POST', Uri.parse(finalUrl))
      ..fields['id'] = id
      ..files.add(frontFile)
      ..files.add(backFile);

    var response = await req.send();

    p('🐸  🐸  🐸 ... ID Upload response: ${response.toString()}');
    if (response.statusCode == 200) {
      var msg = '🍐 🍐 🍐 ID document uploaded OK : $response';
      p(msg);
      return msg;
    } else {
      p('😈 👿 Reason Phrase: ${response.reasonPhrase}');
      print(response);
      throw Exception('ID Document Upload Failed');
    }
  }

  static Future uploadProofOfResidence(
      {@required String id, @required File proofOfResidence}) async {
    var url = await getBaseUrl();
    var finalUrl = url + 'uploadProofOfResidence';
    var frontBytes = await proofOfResidence.length();
    p('🐸  🐸  🐸 proofOfResidence size: $frontBytes bytes ...');
    var frontFile = await http.MultipartFile.fromPath(
        'proofOfResidence', proofOfResidence.path);
    var req = http.MultipartRequest('POST', Uri.parse(finalUrl))
      ..fields['id'] = id
      ..files.add(frontFile);
    var response = await req.send();
    p('🥏 🥏 🥏 ProofOfResidence uploaded, response: $response');
    if (response.statusCode == 200) {
      var msg = '🍐 🍐 🍐 ProofOfResidence document uploaded OK : $response';
      p(msg);
      return msg;
    } else {
      throw Exception('ProofOfResidence Document Upload Failed');
    }
  }

  static Future uploadSelfie(
      {@required String id, @required File selfie}) async {
    p('🐸  🐸  🐸 Uploading the selfie file ...');
    var url = await getBaseUrl();
    var finalUrl = url + 'uploadSelfie';
    var frontBytes = await selfie.length();
    p('🐸  🐸  🐸 Selfie size: $frontBytes bytes ...');
    var frontFile = await http.MultipartFile.fromPath('selfie', selfie.path);
    var req = http.MultipartRequest('POST', Uri.parse(finalUrl))
      ..fields['id'] = id
      ..files.add(frontFile);
    var response = await req.send();
    p('🚘  🚘  🚘 Selfie uploaded, response : $response');
    if (response.statusCode == 200) {
      var msg = '🍐 🍐 🍐 Selfie document uploaded OK : $response';
      p(msg);
      return msg;
    } else {
      throw Exception('Selfie Document Upload Failed');
    }
  }
}
