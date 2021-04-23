import 'package:money_library_2021/util/util.dart';

class StellarAccountBag {
  String? accountId;
  List<Balance>? balances;
  String? name, date, userId, userType;

  StellarAccountBag(
      {this.accountId,
      this.balances,
      this.name,
      this.date,
      this.userId,
      this.userType});

  StellarAccountBag.fromJson(Map<dynamic, dynamic> json) {
    p(' 🌽🌽🌽🌽🌽🌽🌽 StellarAccountBag.fromJson: $json ');
    accountId = json['accountId'];
    name = json['name'];
    date = json['date'];
    userId = json['userId'];
    userType = json['userType'];

    if (json['balances'] != null) {
      balances = [];
      List m = json['balances'];
      m.forEach((v) {
        balances!.add(new Balance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['userId'] = this.userId;
    data['date'] = this.date;
    data['name'] = this.name;
    data['accountId'] = this.accountId;

    List mList = [];
    if (this.balances != null) {
      this.balances!.forEach((b) {
        mList.add(b.toJson());
      });
    }
    data['balances'] = mList;
    return data;
  }
}

class Balance {
  String? assetType;
  String? assetCode;
  String? assetIssuer;
  String? limit;
  String? balance;
  String? buyingLiabilities;
  String? sellingLiabilities;
  int? lastModifiedLedger;
  Sponsor? sponsor;
  Asset? asset;
  bool? authorized;
  bool? authorizedToMaintainLiabilities;

  Balance(
      {this.assetType,
      this.assetCode,
      this.assetIssuer,
      this.limit,
      this.balance,
      this.buyingLiabilities,
      this.sellingLiabilities,
      this.lastModifiedLedger,
      this.sponsor,
      this.asset,
      this.authorized,
      this.authorizedToMaintainLiabilities});

  Balance.fromJson(Map<dynamic, dynamic> json) {
    assetType = json['assetType'];
    assetCode = json['assetCode'];
    assetIssuer = json['assetIssuer'];
    limit = json['limit'];
    balance = json['balance'];
    buyingLiabilities = json['buyingLiabilities'];
    sellingLiabilities = json['sellingLiabilities'];
    lastModifiedLedger = json['lastModifiedLedger'];
    sponsor =
        json['sponsor'] != null ? new Sponsor.fromJson(json['sponsor']) : null;
    asset = json['asset'] != null ? new Asset.fromJson(json['asset']) : null;
    authorized = json['authorized'];
    authorizedToMaintainLiabilities = json['authorizedToMaintainLiabilities'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetType'] = this.assetType;
    data['assetCode'] = this.assetCode;
    data['assetIssuer'] = this.assetIssuer;
    data['limit'] = this.limit;
    data['balance'] = this.balance;
    data['buyingLiabilities'] = this.buyingLiabilities;
    data['sellingLiabilities'] = this.sellingLiabilities;
    data['lastModifiedLedger'] = this.lastModifiedLedger;
    if (this.sponsor != null) {
      data['sponsor'] = this.sponsor!.toJson();
    }
    if (this.asset != null) {
      data['asset'] = this.asset!.toJson();
    }
    data['authorized'] = this.authorized;
    data['authorizedToMaintainLiabilities'] =
        this.authorizedToMaintainLiabilities;
    return data;
  }
}

class Sponsor {
  bool? present;

  Sponsor({this.present});

  Sponsor.fromJson(Map<String, dynamic> json) {
    present = json['present'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['present'] = this.present;
    return data;
  }
}

class Asset {
  String? type;
  String? issuer;
  String? code;

  Asset({this.type, this.issuer, this.code});

  Asset.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    issuer = json['issuer'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['issuer'] = this.issuer;
    data['code'] = this.code;
    return data;
  }
}
