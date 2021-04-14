class Anchor {
  String anchorId,
      name,
      cellphone,
      email,
      countryCode,
      anchorCurrencyCode,
      assetCode;
  Account baseStellarAccount, issuingStellarAccount, distributionStellarAccount;
  AnchorUser anchorUser;
  String date;
  List<Asset> assets;

  Anchor(
      {this.anchorId,
      this.name,
      this.cellphone,
      this.email,
      this.baseStellarAccount,
      this.issuingStellarAccount,
      this.distributionStellarAccount,
      this.anchorUser,
      this.date,
      this.assets,
      this.anchorCurrencyCode,
      this.assetCode,
      this.countryCode});

  Anchor.fromJson(Map data) {
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.anchorId = data['anchorId'];
    this.date = data['date'];
    this.name = data['name'];
    this.anchorCurrencyCode = data['anchorCurrencyCode'];
    this.countryCode = data['countryCode'];
    this.assetCode = data['assetCode'];

    if (data['baseStellarAccount'] != null) {
      this.baseStellarAccount = Account.fromJson(data['baseStellarAccount']);
    }
    if (data['issuingStellarAccount'] != null) {
      this.issuingStellarAccount =
          Account.fromJson(data['issuingStellarAccount']);
    }
    if (data['distributionStellarAccount'] != null) {
      this.distributionStellarAccount =
          Account.fromJson(data['distributionStellarAccount']);
    }
    assets = [];
    if (data['assets'] != null) {
      List list = data['assets'];
      list.forEach((element) {
        var asset = Asset.fromJson(element);
        assets.add(asset);
      });
    }
    if (data['anchorUser'] != null) {
      this.anchorUser = AnchorUser.fromJson(data['anchorUser']);
    }
  }

  Map<String, dynamic> toJson() {
    List<dynamic> list = [];
    assets.forEach((element) {
      list.add(element.toJson());
    });

    Map<String, dynamic> map = Map();
    map['baseStellarAccount'] =
        baseStellarAccount == null ? null : baseStellarAccount.toJson();
    map['issuingStellarAccount'] =
        issuingStellarAccount == null ? null : issuingStellarAccount.toJson();
    map['distributionStellarAccount'] = distributionStellarAccount == null
        ? null
        : distributionStellarAccount.toJson();
    map['email'] = email;
    map['cellphone'] = cellphone;
    map['name'] = name;
    map['anchorId'] = anchorId;
    map['date'] = date;
    map['assetCode'] = assetCode;
    map['countryCode'] = countryCode;
    map['anchorCurrencyCode'] = anchorCurrencyCode;
    map['anchorUser'] = anchorUser == null ? null : anchorUser.toJson();
    map['assets'] = list;

    return map;
  }
}

class Account {
  String accountId;
  String date, name;

  Account(this.accountId, this.date, this.name);
  Account.fromJson(Map data) {
    this.accountId = data['accountId'];
    this.name = data['name'];
    this.date = data['date'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['accountId'] = accountId;
    map['name'] = name;
    map['date'] = date;

    return map;
  }
}

class AnchorUser {
  String firstName,
      middleName,
      lastName,
      email,
      cellphone,
      anchorId,
      userId,
      idNumber;
  bool active;
  String date;

  AnchorUser(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.email,
      this.cellphone,
      this.anchorId,
      this.userId,
      this.idNumber,
      this.active,
      this.date});

  AnchorUser.fromJson(Map data) {
    this.firstName = data['firstName'];
    this.middleName = data['middleName'];
    this.lastName = data['lastName'];
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.idNumber = data['idNumber'];
    this.userId = data['userId'];
    this.anchorId = data['anchorId'];
    this.date = data['date'];
    this.active = data['active'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['cellphone'] = cellphone;
    map['idNumber'] = idNumber;
    map['userId'] = userId;
    map['anchorId'] = anchorId;
    map['date'] = date;
    map['active'] = active;

    return map;
  }
}

class Asset {
  String assetCode;
  String date, issuer;

  Asset(this.assetCode, this.date, this.issuer);
  Asset.fromJson(Map data) {
    this.assetCode = data['assetCode'];
    this.issuer = data['issuer'];
    this.date = data['date'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['assetCode'] = assetCode;
    map['issuer'] = issuer;
    map['date'] = date;

    return map;
  }
}
