/*
 private String paymentRequestId, seed,
            assetCode,
            amount,
             loanId,, clientId;
    private Long ledger;

 */
class StellarFiatPaymentResponse {
  String anchorId, sourceAccount;
  String date,
      assetCode,
      destinationAccount,
      paymentRequestId,
      agentId,
      amount,
      loanId,
      clientId;
  bool success;
  int ledger;

  StellarFiatPaymentResponse(
      {this.anchorId,
      this.sourceAccount,
      this.date,
      this.assetCode,
      this.destinationAccount,
      this.paymentRequestId,
      this.agentId,
      this.amount,
      this.loanId,
      this.clientId,
      this.ledger,
      this.success});

  StellarFiatPaymentResponse.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.sourceAccount = data['sourceAccount'];
    this.ledger = data['ledger'];
    this.date = data['date'];
    this.assetCode = data['assetCode'];
    this.destinationAccount = data['destinationAccount'];
    this.paymentRequestId = data['paymentRequestId'];
    this.agentId = data['agentId'];
    this.amount = data['amount'];
    this.success = data['success'];
    this.loanId = data['loanId'];
    this.clientId = data['clientId'];

    this.ledger = data['ledger'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['sourceAccount'] = sourceAccount;
    map['date'] = date;
    map['assetCode'] = assetCode;
    map['destinationAccount'] = destinationAccount;
    map['paymentRequestId'] = paymentRequestId;
    map['agentId'] = agentId;
    map['amount'] = amount;
    map['success'] = success;
    map['ledger'] = ledger;

    map['loanId'] = loanId;
    map['clientId'] = clientId;

    return map;
  }
}
