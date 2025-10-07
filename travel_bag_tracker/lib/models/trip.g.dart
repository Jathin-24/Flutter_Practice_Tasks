// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as TripType,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime?,
      destination: fields[5] as String?,
      notes: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      isActive: fields[9] as bool,
      departureLocation: fields[10] as String?,
      transportNumber: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.destination)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.departureLocation)
      ..writeByte(11)
      ..write(obj.transportNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripTypeAdapter extends TypeAdapter<TripType> {
  @override
  final int typeId = 1;

  @override
  TripType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TripType.flight;
      case 1:
        return TripType.train;
      case 2:
        return TripType.bus;
      case 3:
        return TripType.car;
      case 4:
        return TripType.other;
      default:
        return TripType.flight;
    }
  }

  @override
  void write(BinaryWriter writer, TripType obj) {
    switch (obj) {
      case TripType.flight:
        writer.writeByte(0);
        break;
      case TripType.train:
        writer.writeByte(1);
        break;
      case TripType.bus:
        writer.writeByte(2);
        break;
      case TripType.car:
        writer.writeByte(3);
        break;
      case TripType.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
