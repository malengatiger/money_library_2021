import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:money_library_2021/api/anchor_db.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/balance.dart';
import 'package:money_library_2021/models/balances.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/payment_request.dart';
import 'package:money_library_2021/util/prefs.dart';
import 'package:money_library_2021/util/util.dart';

final AgentBloc agentBloc = AgentBloc();

class AgentBloc {
  AgentBloc() {
    p('🥬 🥬 🥬 🥬 🥬 AgentBloc starting engines ... 🥬 ...');
    getAnchor();
    getAnchorUser();
  }

  StreamController<List<Agent>> _agentController = StreamController.broadcast();
  StreamController<List<Client>> _clientController =
      StreamController.broadcast();
  StreamController<List<Balances>> _balancesController =
      StreamController.broadcast();

  List<String> _errors = [];
  List<bool> _busies = [];
  List<Client> _clients = [];
  List<Balances> _balances = [];

  StreamController<List<String>> _errorController =
      StreamController.broadcast();

  StreamController<List<bool>> _busyController = StreamController.broadcast();

  Stream<List<Agent>> get agentStream => _agentController.stream;

  Stream<List<bool>> get busyStream => _busyController.stream;

  Stream<List<String>> get errorStream => _errorController.stream;

  Stream<List<Client>> get clientStream => _clientController.stream;

  Stream<List<Balances>> get balancesStream => _balancesController.stream;

  List<Agent> get agents => _agents;

  List<Client> get clients => _clients;

  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Agent> _agents = [];
  Anchor _anchor;
  AnchorUser _anchorUser;

  Future<Anchor> getAnchor() async {
    _anchor = await Prefs.getAnchor();
    if (_anchor != null) {
      getAgents(anchorId: _anchor.anchorId, refresh: false);
    }
    return _anchor;
  }

// public PaymentRequest sendPayment(PaymentRequest paymentRequest) throws Exception {
  Future<Balances> sendMoneyToAgent(
      {@required Agent agent,
      @required String amount,
      @required String assetCode}) async {
    assert(amount != null);
    assert(assetCode != null);
    var fundRequest = AgentFundingRequest(
        anchorId: agent.anchorId,
        amount: amount,
        date: DateTime.now().toIso8601String(),
        agentId: agent.agentId,
        assetCode: assetCode,
        userId: _anchorUser.userId);
    p('agentBloc:  🏈  🏈  🏈 sendMoneyToAgent ... check asset code is not null: ${fundRequest.toJson()}');

    var result = await NetUtil.post(
        apiRoute: 'fundAgent', bag: fundRequest.toJson(), mTimeOut: 9000);
    p(result);
    p("💧 💧 💧 💧 💧 refreshing agent account balances after payment. check balance of 🌼 $assetCode ....");
    return await _readRemoteBalances(agent.stellarAccountId);
  }

  Future<AnchorUser> getAnchorUser() async {
    _anchorUser = await Prefs.getAnchorUser();
    return _anchorUser;
  }

  Future<List<Agent>> getAgents({String anchorId, bool refresh = false}) async {
    try {
      p("💧 💧 💧 💧 💧 refreshing ... getAgents .... 💧 💧 refresh: $refresh");

      _agents.clear();
      if (refresh) {
        _agents = await _readAgentsFromDatabase(anchorId);
      } else {
        _agents = await AnchorLocalDB.getAgents();
        p('🌿 🌿 🌿 Agents found locally : 🎁  ${_agents.length} 🎁 ');
        p('🌿 🌿 🌿 Agents to be put in stream : 🎁  ${_agents.length} 🎁 ... returning after that!');
        _agentController.sink.add(_agents);
        return _agents;
      }

      if (_agents.isEmpty) {
        _agents = await _readAgentsFromDatabase(anchorId);
        p('🌿 🌿 🌿 Agents found remotely : 🎁  ${_agents.length} 🎁 ');
        p('🌿 🌿 🌿 Agents to be put in stream : 🎁  ${_agents.length} 🎁 ');
        _agentController.sink.add(_agents);
      } else {
        p('🌿 🌿 🌿 Agents should be in the fucking stream!!!! : 🎁  ${_agents.length} 🎁 ');
      }
    } catch (e) {
      p(e);
      _errors.clear();
      _errors.add('Firestore agent query failed');
      _errorController.sink.add(_errors);
    }
    return _agents;
  }

  Future _readAgentsFromDatabase(String anchorId) async {
    p('🌿 🌿 🌿 _readAgentsFromDatabase : 🎁  $anchorId 🎁 ');
    var qs = await firestore
        .collection('agents')
        .where('anchorId', isEqualTo: anchorId)
        .get();

    _agents.clear();
    qs.docs.forEach((doc) {
      _agents.add(Agent.fromJson(doc.data()));
    });
    _agents.forEach((element) async {
      await AnchorLocalDB.addAgent(agent: element);
    });
    return _agents;
  }

  Future<List<Client>> getClients(
      {String agentId, bool refresh = false}) async {
    try {
      p("🔵 🔵 🔵 🔵 Getting agents clients from local or remote db ... agentId: $agentId");
      if (refresh) {
        await _getRemoteClients(agentId);
      } else {
        _clients = await AnchorLocalDB.getClientsByAgent(agentId);
        _clientController.sink.add(_clients);
        p('🔵 🔵 🔵 🔵  Agent\'s clients found on LOCAL cache : 🎁  ${_clients.length} 🎁 ');
        if (clients.isEmpty) {
          await _getRemoteClients(agentId);
        }
      }
    } catch (e) {
      p(e);
      _errors.clear();
      _errors.add('Firestore agent query failed');
      _errorController.sink.add(_errors);
    }
    return _clients;
  }

  Future _getRemoteClients(String agentId) async {
    p('🔵 🔵 🔵 🔵 Getting agents clients from REMOTE database ...');
    var qs = await firestore
        .collection('clients')
        .where('agentIds', arrayContains: agentId)
        .get();
    _clients.clear();
    qs.docs.forEach((doc) {
      _clients.add(Client.fromJson(doc.data()));
    });

    _clientController.sink.add(_clients);
    p('🌿 🌿 🌿 Agent\'s clients found on REMOTE database : 🎁  ${_clients.length} 🎁 agentId: $agentId');
    _clients.forEach((element) async {
      await AnchorLocalDB.addClient(client: element);
    });
  }

  Future<Balances> _readRemoteBalances(String accountId) async {
    var result = await NetUtil.get(
        apiRoute: 'getAccountUsingAccountId?accountId=$accountId',
        mTimeOut: 9000);

    p('\n🔆 🔆 🔆 AgentBloc:_readRemoteBalances ️️❤️  printing the result from the get call ...');
    p(result);
    List list = result;
    var balls = Balances(balances: []);
    list.forEach((element) {
      balls.balances.add(Balance.fromJson(element));
    });

    await AnchorLocalDB.addBalance(balances: balls);

    Balances newBal = _processAssetCodes(balls);
    p('👌 New Balances after processing native to XLM: 👌 ${newBal.toJson()} 👌');
    return newBal;
  }

  Future<Balances> getLocalBalances(String accountId) async {
    Balances mBalances;
    try {
      _busies.add(true);
      _busyController.sink.add(_busies);
      p('🍎 AgentBloc: getLocalBalances .... $accountId ..... ');
      mBalances = await AnchorLocalDB.getLastBalances(accountId);
      if (mBalances == null) {
        return null;
      }
      _doBalancesStream(mBalances);
    } catch (e) {
      p(e);
      _balanceError();
    }
    Balances newBal = _processAssetCodes(mBalances);
    return newBal;
  }

  Balances _processAssetCodes(Balances mBalances) {
    var newBal = Balances();

    newBal.balances = [];
    mBalances.balances.forEach((element) {
      if (element.assetCode == null) {
        element.assetCode = 'XLM';
      }
      newBal.balances.add(element);
    });

    p('_processAssetCodes: 🔆 🔆 🔆 ${newBal.toJson()}');
    return newBal;
  }

  Future<Balances> getRemoteBalances(String accountId) async {
    Balances mBalances;
    try {
      //todo - get balances
      mBalances = await _readRemoteBalances(accountId);
      mBalances.balances.sort((a, b) => a.assetCode.compareTo(b.assetCode));
      if (mBalances != null) {
        await AnchorLocalDB.addBalance(balances: mBalances);
      } else {
        return null;
      }
      _doBalancesStream(mBalances);
    } catch (e) {
      p(e);
      _balanceError();
    }

    return mBalances;
  }

  void _balanceError() {
    var msg = 'Balances not found on Stellar';
    _errors.clear();
    _errors.add(msg);
    _errorController.sink.add(_errors);
    p(' 🍎 $msg');
    throw Exception(msg);
  }

  void _doBalancesStream(Balances mBalances) {
    _balances.clear();
    _balances.add(mBalances);
    _balancesController.sink.add(_balances);

    p('🌿 🌿 🌿 Balances found on database : 🎁 in stream: ${_balances.length} 🎁 ');
  }

  closeStreams() {
    _agentController.close();
    _errorController.close();
    _busyController.close();
    _clientController.close();
    _balancesController.close();
  }

  final FirebaseMessaging fcm = FirebaseMessaging();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _subscribeToArrivalsFCM() async {
//    List<String> topics = [];
//    topics
//        .add('${Constants.COMMUTER_ARRIVAL_LANDMARKS}_${landmark.landmarkID}');
//    topics.add('${Constants.VEHICLE_ARRIVALS}_${landmark.landmarkID}');
//    topics
//        .add('${Constants.ROUTE_DISTANCE_ESTIMATIONS}_${landmark.landmarkID}');
//    topics
//        .add('${Constants.COMMUTER_FENCE_DWELL_EVENTS}_${landmark.landmarkID}');
//    topics
//        .add('${Constants.COMMUTER_FENCE_EXIT_EVENTS}_${landmark.landmarkID}');
//    topics.add('${Constants.COMMUTER_REQUESTS}_${landmark.landmarkID}');
//
//    if (landmarksSubscribedMap.containsKey(landmark.landmarkID)) {
//      myDebugPrint(
//          '🍏 Landmark ${landmark.landmarkName} has already subscribed to FCM');
//    } else {
//      await _subscribe(topics, landmark);
//      myDebugPrint('MarshalBloc:: 🧩 Subscribed to ${topics.length} FCM topics'
//          ' for landmark: 🍎 ${landmark.landmarkName} 🍎 ');
//    }
//
//    myDebugPrint(
//        'MarshalBloc:... 💜 💜 Subscribed to FCM ${landmarksSubscribedMap.length} topics for '
//        'landmark ✳️ ${_landmark == null ? 'unknown' : _landmark.landmarkName}\n');
  }

//  _subscribe(List<String> topics, Landmark landmark) async {
//    for (var t in topics) {
//      await fcm.subscribeToTopic(t);
//      myDebugPrint(
//          'MarshalBloc: 💜 💜 Subscribed to FCM topic: 🍎  $t ✳️ at ${landmark.landmarkName}');
//    }
//    landmarksSubscribedMap[landmark.landmarkID] = landmark;
//    return;
//  }

}
