/*
 private String paymentRequestId, seed,
            assetCode,
            amount,
            date, anchorId,
            destinationAccount, sourceAccount, loanId, agentId, clientId;
    private Long ledger;
 */
import 'package:flutter/material.dart';

class PaymentRequest {
  String? anchorId, agentId;
  String? clientId, loanId, destinationAccount;
  String? sourceAccount;
  String? amount;
  String? date, seed, assetCode;

  PaymentRequest(
      {required this.anchorId,
      this.agentId,
      this.clientId,
      this.loanId,
      required this.date,
      required this.seed,
      required this.assetCode,
      required this.amount,
      required this.destinationAccount,
      required this.sourceAccount}); //
  //

  PaymentRequest.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.agentId = data['agentId'];
    this.clientId = data['clientId'];
    this.loanId = data['loanId'];
    this.date = data['date'];
    this.seed = data['seed'];
    this.assetCode = data['assetCode'];
    this.amount = data['amount'];
    this.destinationAccount = data['destinationAccount'];

    this.sourceAccount = data['sourceAccount'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['agentId'] = agentId;
    map['clientId'] = clientId;
    map['loanId'] = loanId;
    map['date'] = date;
    map['seed'] = seed;
    map['assetCode'] = assetCode;
    map['amount'] = amount;
    map['destinationAccount'] = destinationAccount;

    map['sourceAccount'] = sourceAccount;

    return map;
  }
}

class AgentFundingRequest {
  /*
   private String agentFundingRequestId,
            assetCode,
            amount,
            date, anchorId,
            agentId;
   */
  String? anchorId, agentId, userId;
  String? amount;
  String? date, assetCode;

  AgentFundingRequest(
      {required this.anchorId,
      required this.agentId,
      required this.date,
      required this.assetCode,
      required this.amount,
      required this.userId}); //
  //

  AgentFundingRequest.fromJson(Map data) {
    this.anchorId = data['anchorId'];
    this.agentId = data['agentId'];
    this.userId = data['userId'];
    this.date = data['date'];
    this.assetCode = data['assetCode'];
    this.amount = data['amount'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['anchorId'] = anchorId;
    map['agentId'] = agentId;
    map['userId'] = userId;
    map['date'] = date;
    map['assetCode'] = assetCode;
    map['amount'] = amount;

    return map;
  }
}
