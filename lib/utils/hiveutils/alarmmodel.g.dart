// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarmmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmAdapter extends TypeAdapter<Alarm> {
  @override
  final int typeId = 0;

  @override
  Alarm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alarm(
      time: fields[1] as String,
      isEnabled: fields[2] as bool,
      repeatDays: (fields[3] as List).cast<int>(),
      alarmName: fields[0] as String,
      modeMap: (fields[5] as Map).cast<dynamic, dynamic>(),
      arrivalTime: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Alarm obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.alarmName)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.isEnabled)
      ..writeByte(3)
      ..write(obj.repeatDays)
      ..writeByte(4)
      ..write(obj.arrivalTime)
      ..writeByte(5)
      ..write(obj.modeMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
