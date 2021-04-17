import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/loan.dart';
import 'package:money_library_2021/models/payment_dto.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/models/transaction_dto.dart';
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
  static Box paymentBox;
  static Box transactionBox;

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

      paymentBox = await Hive.openBox("paymentBox");
      p('$aa Hive paymentBox:  🔵  ....paymentBox.isOpen: ${paymentBox.isOpen}');

      transactionBox = await Hive.openBox("transactionBox");
      p('$aa Hive transactionBox:  🔵  ....transactionBox.isOpen: ${transactionBox.isOpen}');

      p('$aa Hive local data ready to rumble ....$aa');
    }
  }

  static Future addTransaction(TransactionDTO transaction) async {
    await _connectLocalDB();
    transactionBox.put(transaction.created_at, transaction.toJson());
    p('$aa TransactionDTO added or changed: ${transaction.toJson()}');
  }

  static Future addPayment(PaymentDTO payment) async {
    await _connectLocalDB();
    paymentBox.put(payment.created_at, payment.toJson());
    p('$aa Payment added or changed: ${payment.toJson()}');
  }

  static Future addAgent(Agent agent) async {
    await _connectLocalDB();
    agentBox.put(agent.agentId, agent.toJson());
    p('$aa Agent added or changed: ${agent.toJson()}');
  }

  static Future addClient(Client client) async {
    await _connectLocalDB();
    clientBox.put(client.clientId, client.toJson());
    p('$aa Client added: ${client.toJson()}');
  }

  static Future<List<PaymentDTO>> getPayments() async {
    await _connectLocalDB();
    List<PaymentDTO> mList = [];
    var values = paymentBox.values;

    values.forEach((element) {
      mList.add(PaymentDTO.fromJson(element));
    });

    p('$aa 🥬 Payments retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<TransactionDTO>> getTransactions() async {
    await _connectLocalDB();
    List<TransactionDTO> mList = [];
    var values = transactionBox.values;

    values.forEach((element) {
      mList.add(TransactionDTO.fromJson(element));
    });

    p('$aa 🥬 Transactions retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
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
    List values = clientBox.values.toList();
    values.forEach((element) {
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
    p('💙 💙 💙 💙 💙 💙 💙 AnchorLocalDB: StellarAccountBag 💙');
    p(bal);
    try {
      var bag = StellarAccountBag.fromJson(bal);
      p('.............. do we get here ???');
      return bag;
    } catch (e) {
      p(e);
    }
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
