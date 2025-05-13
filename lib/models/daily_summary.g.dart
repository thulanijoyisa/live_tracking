// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySummaryAdapter extends TypeAdapter<DailySummary> {
  @override
  final int typeId = 0;

  @override
  DailySummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySummary(
      homeMillis: fields[0] as int,
      officeMillis: fields[1] as int,
      travelingMillis: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailySummary obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.homeMillis)
      ..writeByte(1)
      ..write(obj.officeMillis)
      ..writeByte(2)
      ..write(obj.travelingMillis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
