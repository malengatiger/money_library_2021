/*
String sourceAccount,  destinationAccount;
    String sourceAssetCode,  destinationAssetCode;
    String sendAmount,  destinationMin, token, date;
    boolean success;

 */
import 'package:hive/hive.dart';

part 'path_payment_request.g.dart';

@HiveType(typeId: 0)
class PathPaymentRequest extends HiveObject {
  @HiveField(0)
  late String? anchorId;
  @HiveField(1)
  late String? sourceAccount;
  @HiveField(2)
  late String? pathPaymentRequestId;
  @HiveField(3)
  late String? date;
  @HiveField(4)
  late String? dateUpdated;
  @HiveField(5)
  late String? destinationAccount;
  @HiveField(6)
  late String? sourceAssetCode;
  @HiveField(7)
  late String? destinationAssetCode;
  @HiveField(8)
  late String? sendAmount;
  @HiveField(9)
  late String? destinationMin;
  @HiveField(10)
  late String? token;
  @HiveField(11)
  late bool? success;

  PathPaymentRequest(
      {required this.anchorId,
      required this.sourceAccount,
      required this.date,
      required this.dateUpdated,
      required this.destinationAccount,
      required this.sourceAssetCode,
      required this.destinationAssetCode,
      required this.sendAmount,
      required this.destinationMin,
      required this.token,
      required this.pathPaymentRequestId,
      required this.success});

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
    this.pathPaymentRequestId = data['pathPaymentRequestId'];

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
    map['pathPaymentRequestId'] = pathPaymentRequestId;
    return map;
  }
}
