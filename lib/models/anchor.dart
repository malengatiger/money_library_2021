class Anchor {
  String anchorId, name, cellphone, email;
  Account baseAccount, issuingAccount, distributionAccount;
  AnchorUser anchorUser;
  String date;

  Anchor(
      this.anchorId,
      this.name,
      this.cellphone,
      this.email,
      this.baseAccount,
      this.issuingAccount,
      this.distributionAccount,
      this.anchorUser,
      this.date);

  Anchor.fromJson(Map data) {
    this.email = data['email'];
    this.cellphone = data['cellphone'];
    this.anchorId = data['anchorId'];
    this.date = data['date'];
    this.name = data['name'];

    if (data['baseAccount'] != null) {
      this.baseAccount = Account.fromJson(data['baseAccount']);
    }
    if (data['issuingAccount'] != null) {
      this.issuingAccount = Account.fromJson(data['issuingAccount']);
    }
    if (data['distributionAccount'] != null) {
      this.distributionAccount = Account.fromJson(data['distributionAccount']);
    }
    if (data['anchorUser'] != null) {
      this.anchorUser = AnchorUser.fromJson(data['anchorUser']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['baseAccount'] = baseAccount == null ? null : baseAccount.toJson();
    map['issuingAccount'] =
        issuingAccount == null ? null : issuingAccount.toJson();
    map['distributionAccount'] =
        distributionAccount == null ? null : distributionAccount.toJson();
    map['email'] = email;
    map['cellphone'] = cellphone;
    map['name'] = name;
    map['anchorId'] = anchorId;
    map['date'] = date;
    map['anchorUser'] = anchorUser == null ? null : anchorUser.toJson();

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
