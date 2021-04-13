import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:money_library_2021/api/anchor_db.dart';
import 'package:money_library_2021/api/net.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/anchor.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/payment_request.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
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
  StreamController<List<StellarAccountBag>> _balancesController =
      StreamController.broadcast();

  List<String> _errors = [];
  List<bool> _busies = [];
  List<Client> _clients = [];
  List<StellarAccountBag> _balances = [];

  StreamController<List<String>> _errorController =
      StreamController.broadcast();

  StreamController<List<bool>> _busyController = StreamController.broadcast();

  Stream<List<Agent>> get agentStream => _agentController.stream;

  Stream<List<bool>> get busyStream => _busyController.stream;

  Stream<List<String>> get errorStream => _errorController.stream;

  Stream<List<Client>> get clientStream => _clientController.stream;

  Stream<List<StellarAccountBag>> get balancesStream =>
      _balancesController.stream;

  List<Agent> get agents => _agents;

  List<Client> get clients => _clients;

  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Agent> _agents = [];
  Anchor _anchor;
  AnchorUser _anchorUser;
  static const cc = 'AgentBloc: 🎁 🎁 🎁 ';

  Future<Anchor> getAnchor() async {
    _anchor = await Prefs.getAnchor();
    if (_anchor != null) {
      getAgents(anchorId: _anchor.anchorId, refresh: false);
    }
    return _anchor;
  }

  Future<StellarAccountBag> sendMoneyToAgent(
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

    var result =
        await NetUtil.post(apiRoute: 'fundAgent', bag: fundRequest.toJson());
    p(result);
    p("💧 💧 💧 💧 💧 refreshing agent account balances after payment. check balance of 🌼 $assetCode ....");
    return await getBalances(accountId: agent.stellarAccountId, refresh: true);
  }

  Future<AnchorUser> getAnchorUser() async {
    _anchorUser = await Prefs.getAnchorUser();
    return _anchorUser;
  }

  Future<List<Agent>> getAgents({String anchorId, bool refresh = false}) async {
    try {
      p("$cc refreshing ... getAgents .... 💧💧 refresh: $refresh");
      _agents.clear();
      if (refresh) {
        _agents = await _readAgentsFromDatabase(anchorId);
      } else {
        _agents = await AnchorLocalDB.getAgents();
        p('$cc 🌿 🌿 🌿 Agents found locally : 🎁  ${_agents.length} 🎁 ');
        if (_agents.isEmpty) {
          _agents = await _readAgentsFromDatabase(anchorId);
          p('$cc 🌿 🌿 🌿 Agents found remotely: 🎁  ${_agents.length} 🎁 ');
          _agents.forEach((element) async {
            await AnchorLocalDB.addAgent(element);
          });
        }
        _agentController.sink.add(_agents);
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
    p('$cc 🌿 🌿 🌿 _readAgentsFromDatabase : 🎁 ');
    _agents = await NetUtil.getAgents(anchorId);
    _agentController.sink.add(_agents);
    return _agents;
  }

  Future<List<Client>> getClients(
      {String agentId, bool refresh = false}) async {
    try {
      p("🔵 🔵 🔵 🔵 Getting agents clients from local or remote db ... agentId: $agentId");
      if (refresh) {
        await _getRemoteClients(agentId);
        p('🌿 🌿 🌿 Agent\'s clients found on REMOTE database : 🎁  ${_clients.length} 🎁 agentId: $agentId');
      } else {
        _clients = await AnchorLocalDB.getClientsByAgent(agentId);
        p('🌿 🌿 🌿 Agent\'s clients found on LOCAL database : 🎁  ${_clients.length} 🎁 agentId: $agentId');
        if (_clients.isEmpty) {
          await _getRemoteClients(agentId);
          p('🌿 🌿 🌿 Agent\'s clients found on REMOTE database : 🎁  ${_clients.length} 🎁 agentId: $agentId');
        }
      }
    } catch (e) {
      p(e);
      _errors.clear();
      _errors.add('Firestore agent query failed');
      _errorController.sink.add(_errors);
    }
    _clientController.sink.add(_clients);
    return _clients;
  }

  Future<List<Client>> _getRemoteClients(String agentId) async {
    p('🔵 🔵 🔵 🔵 Getting agents clients from REMOTE database ...');
    _clients = await NetUtil.getAgentClients(agentId);
    _clientController.sink.add(_clients);
    return _clients;
  }

  Future<StellarAccountBag> getBalances(
      {String accountId, bool refresh}) async {
    StellarAccountBag bag;
    try {
      if (refresh) {
        p('🍎 AgentBloc: NetUtil.getAccountBalances .... $accountId ..... ');
        bag = await NetUtil.getAccountBalances(accountId);
      } else {
        p('🍎 AgentBloc: getLocalBalances .... $accountId ..... ');
        bag = await AnchorLocalDB.getLastBalances(accountId);
        if (bag == null) {
          bag = await NetUtil.getAccountBalances(accountId);
        }
      }
      p('🌿 🌿 🌿 Balances found on database : 🎁 in stream: '
          '${bag.balances.length} 🎁 ');
      if (bag != null) {
        AnchorLocalDB.addBalance(bag: bag, accountId: accountId);
      }
      _balances.clear();
      _balances.add(bag);
      _balancesController.sink.add(_balances);
    } catch (e) {
      p(e);
      _balanceError();
      return null;
    }

    return bag;
  }

  void _balanceError() {
    var msg = 'Balances not found on Stellar';
    _errors.clear();
    _errors.add(msg);
    _errorController.sink.add(_errors);
    p(' 🍎 $msg');
    throw Exception(msg);
  }

  closeStreams() {
    _agentController.close();
    _errorController.close();
    _busyController.close();
    _clientController.close();
    _balancesController.close();
  }

  final FirebaseMessaging fcm = FirebaseMessaging.instance;
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
