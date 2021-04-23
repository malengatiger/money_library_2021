import 'package:meta/meta.dart';

class RequestToPayBody {
  String? amount, currency, externalId, payerMessage, payeeNote;
  Payer? payer;

  RequestToPayBody(
      {required this.currency,
      required this.amount,
      required this.externalId,
      required this.payerMessage,
      required this.payeeNote,
      required this.payer});

  RequestToPayBody.fromJson(Map data) {
    this.currency = data['currency'];
    this.amount = data['amount'];
    this.externalId = data['externalId'];
    this.payerMessage = data['payerMessage'];
    this.payeeNote = data['payeeNote'];

    if (data['payer'] != null) {
      this.payer = Payer.fromJson(data['payer']);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'amount': amount,
      'currency': currency,
      'externalId': externalId,
      'payerMessage': payerMessage,
      'payeeNote': payeeNote,
      'payer': this.payer == null ? null : this.payer!.toJson(),
    };
    return map;
  }
}

class Payer {
  String? partyIdType, partyId;
  Payer({
    required this.partyId,
    required this.partyIdType,
  });

  Payer.fromJson(Map data) {
    this.partyId = data['partyId'];
    this.partyIdType = data['partyIdType'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'partyIdType': partyIdType,
      'partyId': partyId,
    };
    return map;
  }
}

/*
public static class RequestToPayBag {
        RequestToPayBody requestToPayBody;
        String referenceId;

 */
class RequestToPayBag {
  String? referenceId;
  RequestToPayBody? requestToPayBody;
  RequestToPayBag({
    required this.requestToPayBody,
    required this.referenceId,
  });

  RequestToPayBag.fromJson(Map data) {
    if (data['requestToPayBody'])
      this.requestToPayBody = data['requestToPayBody'];
    this.referenceId = data['referenceId'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'referenceId': referenceId,
      'requestToPayBody':
          requestToPayBody == null ? null : requestToPayBody!.toJson(),
    };
    return map;
  }
}
