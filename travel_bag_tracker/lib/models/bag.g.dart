// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bag.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BagAdapter extends TypeAdapter<Bag> {
  @override
  final int typeId = 2;

  @override
  Bag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bag(
      id: fields[0] as String,
      tripId: fields[1] as String,
      name: fields[2] as String,
      type: fields[3] as BagType,
      size: fields[4] as BagSize,
      color: fields[5] as String?,
      notes: fields[6] as String?,
      photoPath: fields[7] as String?,
      isVerified: fields[8] as bool,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
      verifiedAt: fields[11] as DateTime?,
      weight: fields[12] as String?,
      tagNumber: fields[13] as String?,
      additionalPhotoPaths: (fields[14] as List?)?.cast<String>(),
      qrCodeData: fields[15] as String?,
      rfidTag: fields[16] as String?,
      aiRecognitionData: (fields[17] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Bag obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.photoPath)
      ..writeByte(8)
      ..write(obj.isVerified)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.verifiedAt)
      ..writeByte(12)
      ..write(obj.weight)
      ..writeByte(13)
      ..write(obj.tagNumber)
      ..writeByte(14)
      ..write(obj.additionalPhotoPaths)
      ..writeByte(15)
      ..write(obj.qrCodeData)
      ..writeByte(16)
      ..write(obj.rfidTag)
      ..writeByte(17)
      ..write(obj.aiRecognitionData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BagTypeAdapter extends TypeAdapter<BagType> {
  @override
  final int typeId = 3;

  @override
  BagType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BagType.suitcase;
      case 1:
        return BagType.backpack;
      case 2:
        return BagType.duffelBag;
      case 3:
        return BagType.carryon;
      case 4:
        return BagType.handbag;
      case 5:
        return BagType.other;
      default:
        return BagType.suitcase;
    }
  }

  @override
  void write(BinaryWriter writer, BagType obj) {
    switch (obj) {
      case BagType.suitcase:
        writer.writeByte(0);
        break;
      case BagType.backpack:
        writer.writeByte(1);
        break;
      case BagType.duffelBag:
        writer.writeByte(2);
        break;
      case BagType.carryon:
        writer.writeByte(3);
        break;
      case BagType.handbag:
        writer.writeByte(4);
        break;
      case BagType.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BagSizeAdapter extends TypeAdapter<BagSize> {
  @override
  final int typeId = 4;

  @override
  BagSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BagSize.small;
      case 1:
        return BagSize.medium;
      case 2:
        return BagSize.large;
      case 3:
        return BagSize.extraLarge;
      default:
        return BagSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, BagSize obj) {
    switch (obj) {
      case BagSize.small:
        writer.writeByte(0);
        break;
      case BagSize.medium:
        writer.writeByte(1);
        break;
      case BagSize.large:
        writer.writeByte(2);
        break;
      case BagSize.extraLarge:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
