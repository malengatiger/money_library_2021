class Balance {
  String balance, assetCode;

  Balance(
    this.balance,
    this.assetCode,
  ); //
  //

  Balance.fromJson(Map data) {
    this.assetCode = data['assetCode'];
    this.balance = data['balance'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['assetCode'] = assetCode;
    map['balance'] = balance;

    return map;
  }
}
