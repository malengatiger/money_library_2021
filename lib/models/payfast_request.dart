class PayFastRequest {
  String merchantId, merchantKey;
  String returnUrl, cancelUrl, notifyUrl;
  PayFastBuyerDetails buyerDetails;
  PayFastTransactionDetails transactionDetails;

  PayFastRequest(
      {this.merchantId,
      this.merchantKey,
      this.returnUrl,
      this.cancelUrl,
      this.notifyUrl,
      this.buyerDetails,
      this.transactionDetails}); //
  //

  PayFastRequest.fromJson(Map data) {
    this.merchantId = data['merchant_id'];
    this.merchantKey = data['merchant_key'];
    this.returnUrl = data['return_url'];
    this.cancelUrl = data['cancel_url'];
    this.notifyUrl = data['notify_url'];
    if (data['buyerDetails'] != null) {
      this.buyerDetails = PayFastBuyerDetails.fromJson(data['buyerDetails']);
    }
    if (data['transactionDetails'] != null) {
      this.transactionDetails =
          PayFastTransactionDetails.fromJson(data['transactionDetails']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['merchant_id'] = merchantId;
    map['merchant_key'] = merchantKey;
    map['return_url'] = returnUrl;
    map['cancel_url'] = cancelUrl;
    map['notify_url'] = notifyUrl;
    map['transactionDetails'] =
        transactionDetails == null ? null : transactionDetails.toJson();
    map['buyerDetails'] = buyerDetails == null ? null : buyerDetails.toJson();

    return map;
  }
}

class PayFastBuyerDetails {
  String nameFirst;
  String nameLast;
  String emailAddress;
  String cellNumber;

  PayFastBuyerDetails(
      {this.nameFirst, this.nameLast, this.emailAddress, this.cellNumber});

  PayFastBuyerDetails.fromJson(Map data) {
    this.nameFirst = data['name_first'];
    this.nameLast = data['name_last'];
    this.emailAddress = data['email_address'];
    this.cellNumber = data['cell_number'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['name_first'] = nameFirst;
    map['name_last'] = nameLast;
    map['email_address'] = emailAddress;
    map['cell_number'] = cellNumber;

    return map;
  }
}

class PayFastTransactionDetails {
  String paymentId;
  String itemName;
  String itemDescription;
  String customString1;
  String customString2;
  String customString3;
  String customString4;
  String customString5;
  double amount;

  PayFastTransactionDetails(
      {this.paymentId,
      this.itemName,
      this.itemDescription,
      this.customString1,
      this.customString2,
      this.customString3,
      this.customString4,
      this.customString5,
      this.amount});
  PayFastTransactionDetails.fromJson(Map data) {
    this.paymentId = data['m_payment_id'];
    this.itemName = data['item_name'];
    this.amount = data['amount'];
    this.itemDescription = data['item_description'];
    this.customString1 = data['custom_str1'];
    this.customString2 = data['custom_str2'];
    this.customString3 = data['custom_str3'];
    this.customString4 = data['custom_str4'];
    this.customString5 = data['custom_str5'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['m_payment_id'] = paymentId;
    map['item_name'] = itemName;
    map['amount'] = amount;
    map['item_description'] = itemDescription;
    map['custom_str1'] = customString1;
    map['custom_str2'] = customString2;
    map['custom_str3'] = customString3;
    map['custom_str4'] = customString4;
    map['custom_str5'] = customString5;

    return map;
  }
}
