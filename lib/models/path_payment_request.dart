/*
String sourceAccount,  destinationAccount;
    String sourceAssetCode,  destinationAssetCode;
    String sendAmount,  destinationMin, token, date;
    boolean success;

 */
class PathPaymentRequest {
  String anchorId, sourceAccount;
  String date,
      dateUpdated,
      destinationAccount,
      sourceAssetCode,
      destinationAssetCode,
      sendAmount,
      destinationMin,
      token;
  bool success;

  PathPaymentRequest(
      {this.anchorId,
      this.sourceAccount,
      this.date,
      this.dateUpdated,
      this.destinationAccount,
      this.sourceAssetCode,
      this.destinationAssetCode,
      this.sendAmount,
      this.destinationMin,
      this.token,
      this.success});

  PathPaymentRequest.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.sourceAccount = data['sourceAccount'];
    this.token = data['token'];
    this.date = data['date'];
    this.dateUpdated = data['dateUpdated'];
    this.destinationAccount = data['destinationAccount'];
    this.sourceAssetCode = data['sourceAssetCode'];
    this.destinationAssetCode = data['destinationAssetCode'];
    this.sendAmount = data['sendAmount'];
    this.success = data['success'];

    this.token = data['token'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['sourceAccount'] = sourceAccount;
    map['date'] = date;
    map['dateUpdated'] = dateUpdated;
    map['destinationAccount'] = destinationAccount;
    map['sourceAssetCode'] = sourceAssetCode;
    map['destinationAssetCode'] = destinationAssetCode;
    map['sendAmount'] = sendAmount;
    map['success'] = success;
    map['token'] = token;

    return map;
  }
}
