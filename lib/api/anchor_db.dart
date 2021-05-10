import 'package:hive/hive.dart';
import 'package:money_library_2021/models/agent.dart';
import 'package:money_library_2021/models/client.dart';
import 'package:money_library_2021/models/fiat_payment_request.dart';
import 'package:money_library_2021/models/loan.dart';
import 'package:money_library_2021/models/path_payment_request.dart';
import 'package:money_library_2021/models/payment_dto.dart';
import 'package:money_library_2021/models/stellar_account_bag.dart';
import 'package:money_library_2021/util/util.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AnchorLocalDB {
  static const APP_ID = 'anchorAppID';
  static bool dbConnected = false;
  static int cnt = 0;

  static String databaseName = 'anchor001a';
  static Box? agentBox;
  static late Box clientBox;
  static late Box balanceBox;
  static late Box loanApplicationBox;
  static late Box fiatPaymentBox;
  static late Box pathPaymentBox;

  static const aa = '🔵 🔵 🔵 🔵 🔵 AnchorLocalDB(Hive): ';

  static Future initializeHive() async {
    if (agentBox == null) {
      p('$aa Connecting to Hive, getting document directory on device ... ');

      final appDocumentDirectory =
          await path_provider.getApplicationDocumentsDirectory();

      Hive.init(appDocumentDirectory.path);
      p('$aa Hive local data will be stored here ... '
          ' 🍎 🍎 ${appDocumentDirectory.path}');

      agentBox = await Hive.openBox("agentBox");
      p('$aa Hive agentBox:  🔵  ....agentBox.isOpen: ${agentBox!.isOpen}');

      clientBox = await Hive.openBox("clientBox");
      p('$aa Hive clientBox:  🔵  ....clientBox.isOpen: ${clientBox.isOpen}');

      balanceBox = await Hive.openBox("balanceBox");
      p('$aa Hive balanceBox:  🔵  ....balanceBox.isOpen: ${balanceBox.isOpen}');

      loanApplicationBox = await Hive.openBox("loanApplicationBox");
      p('$aa Hive loanApplicationBox:  🔵  ....loanApplicationBox.isOpen: ${loanApplicationBox.isOpen}');

      fiatPaymentBox = await Hive.openBox("fiatPaymentBox");
      p('$aa Hive fiatPaymentBox:  🔵  ....fiatPaymentBox.isOpen: ${fiatPaymentBox.isOpen}');

      pathPaymentBox = await Hive.openBox("pathpaymentBox");
      p('$aa Hive pathpaymentBox:  🔵  ....pathpaymentBox.isOpen: ${pathPaymentBox.isOpen}');

      p('$aa Hive local data ready to rumble ....$aa');
      return '$aa Hive Initaialized OK';
    }
  }

/*
2021-04-17 04:09:38.524 30015-30088/com.boha.money_admin_2021 I/flutter: AnchorLocalDB: 🦠🦠🦠🦠🦠  🥬 Payments retrieved from local Hive: 🍎 60
2021-04-17 04:09:38.524 30015-30088/com.boha.money_admin_2021 I/flutter: AgentBloc: 🎁 🎁 🎁  payments found: 60
2021-04-17 04:09:38.524 30015-30088/com.boha.money_admin_2021 I/flutter: AgentBloc: 🎁 🎁 🎁  transactions found: 60
2021-04-17 04:09:38.527 30015-30088/com.boha.money_admin_2021 I/flutter: AnchorLocalDB: 🦠🦠🦠🦠🦠  🥬 Transactions retrieved from local Hive: 🍎 102
2021-04-17 04:09:38.527 30015-30088/com.boha.money_admin_2021 I/flutter: AgentBloc: 🎁 🎁 🎁  transactions found: 102
 */
  static Future addPathPaymentRequests(
      List<PathPaymentRequest> requests) async {
    requests.forEach((element) async {
      await addPathPaymentRequest(element);
    });
  }

  static Future addPathPaymentRequest(PathPaymentRequest request) async {
    await initializeHive();
    pathPaymentBox.put(request.pathPaymentRequestId, request.toJson());

    p('$aa PathPaymentRequest added or changed: 🍎 '
        '${pathPaymentBox.keys.length} records ${request.toJson()}');
  }

  static Future addStellarFiatPaymentResponses(
      List<StellarFiatPaymentResponse> responses) async {
    responses.forEach((element) async {
      await addStellarFiatPaymentResponse(element);
    });
  }

  static Future addStellarFiatPaymentResponse(
      StellarFiatPaymentResponse response) async {
    await initializeHive();
    fiatPaymentBox.put(response.paymentRequestId, response.toJson());

    p('$aa StellarFiatPaymentResponse added or changed: 🍎 '
        '${fiatPaymentBox.keys.length} records ${response.toJson()}');
  }

  static Future addPayment(PaymentDTO payment) async {
    await initializeHive();
    fiatPaymentBox.put(payment.created_at, payment.toJson());
    p('$aa Payment added or changed: 🍎 '
        '${fiatPaymentBox.keys.length} records ${payment.toJson()}');
  }

  static Future addAgent(Agent agent) async {
    await initializeHive();
    agentBox!.put(agent.agentId, agent.toJson());
    // p('$aa Agent added or changed: '
    //     '${agentBox.keys.length} records ${agent.toJson()}');
  }

  static Future addClient(Client client) async {
    await initializeHive();
    clientBox.put(client.clientId, client.toJson());
    // p('$aa Client added: ${client.toJson()}');
  }

  static Future<List<PaymentDTO>> getPayments() async {
    await initializeHive();
    List<PaymentDTO> mList = [];
    var values = fiatPaymentBox.values;

    values.forEach((element) {
      mList.add(PaymentDTO.fromJson(element));
    });

    p('$aa 🥬 Payments retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<PathPaymentRequest>> getPathPaymentRequestsBySourceAccount(
      String? accountId) async {
    await initializeHive();
    List<PathPaymentRequest> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = PathPaymentRequest.fromJson(element);
      if (m.sourceAccount == accountId) {
        mList.add(m);
      }
    });

    p('$aa 🥬 PathPaymentRequests retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesByAnchor(
          {String? anchorId, String? fromDate, String? toDate}) async {
    await initializeHive();
    List<StellarFiatPaymentResponse> mList = [];
    var values = fiatPaymentBox.values;

    values.forEach((element) {
      var m = StellarFiatPaymentResponse.fromJson(element);
      if (m.anchorId == anchorId) {
        //todo - filter by date .....
        DateTime from = DateTime.parse(fromDate!);
        DateTime to = DateTime.parse(toDate!);
        DateTime mDate = DateTime.parse(m.date!);
        if (mDate.isBefore(to) && mDate.isAfter(from)) {
          mList.add(m);
        }
      }
    });

    p('$aa 🥬 StellarFiatPaymentResponses retrieved from local Hive: 🍎 '
        '${mList.length}');
    return mList;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesByAsset(String assetCode) async {
    await initializeHive();
    List<StellarFiatPaymentResponse> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = StellarFiatPaymentResponse.fromJson(element);
      if (m.assetCode == assetCode) {
        mList.add(m);
      }
    });

    p('$aa 🥬 StellarFiatPaymentResponses retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesBySourceAccount(String? accountId) async {
    await initializeHive();
    List<StellarFiatPaymentResponse> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = StellarFiatPaymentResponse.fromJson(element);
      if (m.sourceAccount == accountId) {
        mList.add(m);
      }
    });

    p('$aa 🥬 StellarFiatPaymentResponses retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentResponsesByDestinationAccount(String? accountId) async {
    await initializeHive();
    List<StellarFiatPaymentResponse> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = StellarFiatPaymentResponse.fromJson(element);
      if (m.destinationAccount == accountId) {
        mList.add(m);
      }
    });

    p('$aa 🥬 StellarFiatPaymentResponses retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<PathPaymentRequest>> getPathPaymentRequestsByAnchor(
      {String? anchorId, String? fromDate, String? toDate}) async {
    await initializeHive();
    List<PathPaymentRequest> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = PathPaymentRequest.fromJson(element);
      if (m.anchorId == anchorId) {
        //todo - filter by date .....
        DateTime from = DateTime.parse(fromDate!);
        DateTime to = DateTime.parse(toDate!);
        DateTime mDate = DateTime.parse(m.date!);
        if (mDate.isBefore(to) && mDate.isAfter(from)) {
          mList.add(m);
        }
      }
    });

    p('$aa 🥬 getPathPaymentRequestsByAnchor retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<PathPaymentRequest>>
      getPathPaymentRequestsByDestinationAccount(String? accountId) async {
    await initializeHive();
    List<PathPaymentRequest> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = PathPaymentRequest.fromJson(element);
      if (m.destinationAccount == accountId) {
        mList.add(m);
      }
    });

    p('$aa 🥬 getPathPaymentRequestsByDestinationAccount retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<StellarFiatPaymentResponse>>
      getFiatPaymentRequestsByDestinationAccount(String accountId) async {
    await initializeHive();
    List<StellarFiatPaymentResponse> mList = [];
    var values = pathPaymentBox.values;

    values.forEach((element) {
      var m = StellarFiatPaymentResponse.fromJson(element);
      if (m.destinationAccount == accountId) {
        mList.add(m);
      }
    });

    p('$aa 🥬 PathPaymentRequests retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  static Future<List<Agent>> getAgents() async {
    await initializeHive();
    List<Agent> mList = [];
    var values = agentBox!.values;

    values.forEach((element) {
      mList.add(Agent.fromJson(element));
    });

    p('$aa 🥬 Agents retrieved from local Hive: 🍎 ${mList.length}');
    return mList;
  }

  //
  static Future<List<Client>> getClientsByAgent(String? agentId) async {
    await initializeHive();
    List<Client> clientList = await getAllClients();

    clientList.forEach((client) {
      client.agentIds!.forEach((mId) {
        if (agentId == mId) {
          clientList.add(client);
        }
      });
    });

    p('$aa getClientsByAgent found 🔵 ${clientList.length}');
    return clientList;
  }

  static Future<List<Client>> getAllClients() async {
    await initializeHive();
    List<Client> clientList = [];
    List values = clientBox.values.toList();
    values.forEach((element) {
      clientList.add(Client.fromJson(element));
    });

    p('$aa getAllClients found 🔵 ${clientList.length}');
    return clientList;
  }

  static Future<Client> getClient(String clientId) async {
    await initializeHive();
    var map = clientBox.get(clientId);
    return Client.fromJson(map);
  }

  static Future addBalance(
      {required String? accountId, required StellarAccountBag bag}) async {
    await initializeHive();
    balanceBox.put(accountId, bag.toJson());
    p('$aa 🍎 addBalance: 🌼 ${bag.balances!.length} added... 🔵 🔵 ');
    return 0;
  }

  static Future<StellarAccountBag?> getLastBalances(String? accountId) async {
    await initializeHive();
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
    await initializeHive();
    List<StellarAccountBag> mList = [];
    balanceBox.values.forEach((element) {
      var bal = StellarAccountBag.fromJson(element);
      mList.add(bal);
    });

    return mList;
  }

  static Future addLoanApplication(
      {required LoanApplication loanApplication}) async {
    await initializeHive();
    loanApplicationBox.put(loanApplication.loanId, loanApplication.toJson());
    return 0;
  }

  static Future<Agent> getAgentById(String agentId) async {
    await initializeHive();
    var data = agentBox!.get(agentId);
    return Agent.fromJson(data);
  }
}
