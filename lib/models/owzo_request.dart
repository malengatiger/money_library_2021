class OwzoPaymentRequest {
  /*
  String SiteCode, CountryCode, CurrencyCode, TransactionReference, BankReference;
     String Optional1, Optional2, Optional3, Optional4, Optional5, Customer;
     String CancelUrl, ErrorUrl, SuccessUrl, NotifyUrl, TokenNotificationUrl, TokenDeletedNotificationUrl;
     boolean isTest, RegisterTokenProfile;
     double Amount;
     String BankId, BankAccountNumber, BranchCode, BankAccountName, PayeeDisplayName, HashCheck;
     String TokenProfileId, Token;

   */
  String? siteCode, countryCode, currencyCode, customer;
  double? amount;
  bool? registerTokenProfile, isTest;
  String? successUrl,
      cancelUrl,
      notifyUrl,
      transactionReference,
      bankReference,
      errorUrl,
      token,
      tokenProfileId,
      hashCheck;

  OwzoPaymentRequest(
      {this.siteCode,
      this.countryCode,
      this.currencyCode,
      this.customer,
      this.amount,
      this.successUrl,
      this.cancelUrl,
      this.notifyUrl,
      this.transactionReference,
      this.bankReference,
      this.errorUrl,
      this.registerTokenProfile,
      this.isTest,
      this.token,
      this.tokenProfileId,
      this.hashCheck}); //
  //

  OwzoPaymentRequest.fromJson(Map data) {
    this.siteCode = data['SiteCode'];
    this.countryCode = data['CountryCode'];
    this.currencyCode = data['CurrencyCode'];
    this.customer = data['Customer'];
    this.amount = data['Amount'];
    this.successUrl = data['SuccessUrl'];
    this.cancelUrl = data['CancelUrl'];
    this.notifyUrl = data['NotifyUrl'];
    this.transactionReference = data['TransactionReference'];
    this.bankReference = data['BankReference'];
    this.isTest = data['isTest'];
    this.errorUrl = data['ErrorUrl'];
    this.hashCheck = data['HashCheck'];
    this.token = data['Token'];
    this.tokenProfileId = data['TokenProfileId'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['SiteCode'] = siteCode;
    map['CountryCode'] = countryCode;
    map['CurrencyCode'] = currencyCode;
    map['Customer'] = customer;
    map['Amount'] = amount;
    map['SuccessUrl'] = successUrl;
    map['CancelUrl'] = cancelUrl;
    map['NotifyUrl'] = notifyUrl;
    map['TransactionReference'] = transactionReference;
    map['BankReference'] = bankReference;
    map['isTest'] = isTest;
    map['ErrorUrl'] = errorUrl;
    map['Token'] = token;
    map['TokenProfileId'] = tokenProfileId;
    map['HashCheck'] = hashCheck;

    return map;
  }
}
