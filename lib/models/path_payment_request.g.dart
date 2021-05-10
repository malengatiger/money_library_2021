// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_payment_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PathPaymentRequestAdapter extends TypeAdapter<PathPaymentRequest> {
  @override
  final int typeId = 0;

  @override
  PathPaymentRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PathPaymentRequest(
      anchorId: fields[0] as String?,
      sourceAccount: fields[1] as String?,
      date: fields[3] as String?,
      dateUpdated: fields[4] as String?,
      destinationAccount: fields[5] as String?,
      sourceAssetCode: fields[6] as String?,
      destinationAssetCode: fields[7] as String?,
      sendAmount: fields[8] as String?,
      destinationMin: fields[9] as String?,
      token: fields[10] as String?,
      pathPaymentRequestId: fields[2] as String?,
      success: fields[11] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PathPaymentRequest obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.anchorId)
      ..writeByte(1)
      ..write(obj.sourceAccount)
      ..writeByte(2)
      ..write(obj.pathPaymentRequestId)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.dateUpdated)
      ..writeByte(5)
      ..write(obj.destinationAccount)
      ..writeByte(6)
      ..write(obj.sourceAssetCode)
      ..writeByte(7)
      ..write(obj.destinationAssetCode)
      ..writeByte(8)
      ..write(obj.sendAmount)
      ..writeByte(9)
      ..write(obj.destinationMin)
      ..writeByte(10)
      ..write(obj.token)
      ..writeByte(11)
      ..write(obj.success);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathPaymentRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
