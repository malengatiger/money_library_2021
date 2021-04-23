import 'package:money_library_2021/util/util.dart';

import 'agent.dart';

class Client {
  String? anchorId;
  String? clientId, startingFiatBalance;
  double? latitude, longitude;
  String? dateRegistered,
      dateUpdated,
      externalAccountId,
      account,
      fiatLimit,
      password,
      secretSeed;
  List<String>? agentIds;
  PersonalKYCFields? personalKYCFields;
  bool? active;

  Client.create();

  Client(
      this.anchorId,
      this.clientId,
      this.startingFiatBalance,
      this.dateRegistered,
      this.dateUpdated,
      this.externalAccountId,
      this.account,
      this.latitude,
      this.longitude,
      this.fiatLimit,
      this.password,
      this.secretSeed,
      this.agentIds,
      this.active,
      this.personalKYCFields); //
  //

  Client.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.clientId = data['clientId'];
    this.startingFiatBalance = data['startingFiatBalance'];
    this.dateRegistered = data['dateRegistered'];
    this.dateUpdated = data['dateUpdated'];
    this.externalAccountId = data['externalAccountId'];
    this.account = data['account'];
    this.latitude = data['latitude'];
    this.longitude = data['longitude'];
    this.active = data['active'];

    this.password = data['password'];
    this.secretSeed = data['secretSeed'];
    if (data['personalKYCFields'] != null) {
      this.personalKYCFields =
          PersonalKYCFields.fromJson(data['personalKYCFields']);
    }
    this.agentIds = [];
    if (data['agentIds'] != null) {
      List mList = data['agentIds'];
      mList.forEach((m) {
        this.agentIds!.add(m as String);
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['clientId'] = clientId;
    map['active'] = active;
    map['startingFiatBalance'] = startingFiatBalance;
    map['dateRegistered'] = dateRegistered;
    map['dateUpdated'] = dateUpdated;
    map['externalAccountId'] = externalAccountId;
    map['account'] = account;
    map['latitude'] = latitude;
    map['longitude'] = longitude;

    map['password'] = password;
    map['agentIds'] = agentIds;
    map['secretSeed'] = secretSeed;
    map['personalKYCFields'] =
        personalKYCFields == null ? null : personalKYCFields!.toJson();

    return map;
  }
}

class ClientCache {
  String? idFrontPath, date, idBackPath, selfiePath;
  String? proofOfResidencePath;
  Client? client;

  ClientCache(
      {this.idFrontPath,
      this.idBackPath,
      this.date,
      this.client,
      this.proofOfResidencePath});

  ClientCache.fromJson(Map map) {
    try {
      idFrontPath = map['idFrontPath'];
      selfiePath = map['selfiePath'];
      idBackPath = map['idBackPath'];
      date = map['date'];
      proofOfResidencePath = map['proofOfResidencePath'];
      if (map['client'] != null) {
        p(map['client']);
        client = Client.fromJson(map['client']);
      }
    } catch (e) {
      print('ClientCache:fromJson: the fuckUp is here somewhere ....');
      throw Exception('ClientCache: fromJSON 🔴 FuckUp 🔴 $e 🔴');
    }
  }

  Map<String, dynamic> toJson() {
    try {
      Map<String, dynamic> map = {
        'idFrontPath': idFrontPath,
        'selfiePath': selfiePath,
        'idBackPath': idBackPath,
        'date': date,
        'proofOfResidencePath': proofOfResidencePath,
        'client': client == null ? null : client!.toJson(),
      };
      return map;
    } catch (e) {
      throw Exception('ClientCache: toJSON 🔴 FuckUp 🔴 $e 🔴');
    }
  }
}
