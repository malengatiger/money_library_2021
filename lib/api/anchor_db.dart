import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/loan.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AnchorLocalDB {
  static const APP_ID = 'anchorAppID';
  static bool dbConnected = false;
  static int cnt = 0;

  static String databaseName = 'anchor001a';
  static Box agentBox;
  static Box clientBox;
  static Box balanceBox;
  static Box loanApplicationBox;

  static const aa = 'AnchorLocalDB: 🦠🦠🦠🦠🦠 ';

  static Future _connectLocalDB() async {
    if (agentBox == null) {
      p('$aa Connecting to Hive, getting document directory on device ... ');
      final appDocumentDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
      p('$aa Hive local data will be stored here ... '
          ' 🍎 🍎 ${appDocumentDirectory.path}');
      agentBox = await Hive.openBox("agentBox");
      p('$aa Hive agentBox:  🔵  ....agentBox.isOpen: ${agentBox.isOpen}');
      clientBox = await Hive.openBox("clientBox");
      p('$aa Hive clientBox:  🔵  ....clientBox.isOpen: ${clientBox.isOpen}');
      balanceBox = await Hive.openBox("balanceBox");
      p('$aa Hive balanceBox:  🔵  ....balanceBox.isOpen: ${balanceBox.isOpen}');
      loanApplicationBox = await Hive.openBox("loanApplicationBox");
      p('$aa Hive loanApplicationBox:  🔵  ....loanApplicationBox.isOpen: ${loanApplicationBox.isOpen}');
      p('$aa Hive local data ready to rumble ....$aa');
    }
  }

  static Future addAgent(Agent agent) async {
    await _connectLocalDB();
    agentBox.put(agent.agentId, agent.toJson());
    p('$aa Agent added: ${agent.toJson()}');
  }

  static Future addClient(Client client) async {
    await _connectLocalDB();
    clientBox.put(client.clientId, client.toJson());
    p('$aa Client added: ${client.toJson()}');
  }

  static Future<List<Agent>> getAgents() async {
    await _connectLocalDB();
    List<Agent> mList = [];
    var values = agentBox.values;

    values.forEach((element) {
      mList.add(Agent.fromJson(element));
    });

    p('$aa 🥬 Agents retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  //
  static Future<List<Client>> getClientsByAgent(String agentId) async {
    await _connectLocalDB();
    List<Client> clientList = await getAllClients();

    clientList.forEach((client) {
      client.agentIds.forEach((mId) {
        if (agentId == mId) {
          clientList.add(client);
        }
      });
    });

    p('$aa getClientsByAgent found 🔵 ${clientList.length}');
    return clientList;
  }

  static Future<List<Client>> getAllClients() async {
    await _connectLocalDB();
    List<Client> clientList = [];
    clientBox.values.forEach((element) {
      clientList.add(Client.fromJson(element));
    });

    p('$aa getAllClients found 🔵 ${clientList.length}');
    return clientList;
  }

  static Future<Client> getClient(String clientId) async {
    await _connectLocalDB();
    var map = clientBox.get(clientId);
    return Client.fromJson(map);
  }

  static Future addBalance(
      {@required String accountId, @required StellarAccountBag bag}) async {
    await _connectLocalDB();
    balanceBox.put(accountId, bag.toJson());
    p('$aa 🍎 addBalance: 🌼 ${bag.balances.length} added... 🔵 🔵 ');
    return 0;
  }

  static Future<StellarAccountBag> getLastBalances(String accountId) async {
    await _connectLocalDB();
    var bal = balanceBox.get(accountId);
    if (bal == null) {
      return null;
    }
    return StellarAccountBag.fromJson(bal);
  }

  static Future<List<StellarAccountBag>> getAllBalances() async {
    await _connectLocalDB();
    List<StellarAccountBag> mList = [];
    balanceBox.values.forEach((element) {
      var bal = StellarAccountBag.fromJson(element);
      mList.add(bal);
    });

    return mList;
  }

  static Future addLoanApplication(
      {@required LoanApplication loanApplication}) async {
    await _connectLocalDB();
    loanApplicationBox.put(loanApplication.loanId, loanApplication.toJson());
    return 0;
  }

  static Future<Agent> getAgentById(String agentId) async {
    await _connectLocalDB();
    var data = agentBox.get(agentId);
    return Agent.fromJson(data);
  }
}
