// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatasetAdapter extends TypeAdapter<Dataset> {
  @override
  final int typeId = 0;

  @override
  Dataset read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dataset(
      farm: fields[0] as String,
      storageHub: fields[1] as String,
      distributionCentre: fields[2] as String,
      vehicleType: fields[3] as String,
      smallVehicleCapacity: fields[4] as double,
      largeVehicleCapacity: fields[5] as double,
      perishabilityRate: fields[6] as double,
      demandLevel: fields[7] as double,
      trafficDisruption: fields[8] as double,
      totalCostGreedy: fields[9] as double,
      totalCostLP: fields[10] as double,
      totalCostOurAlgo: fields[11] as double,
      spoilageRateGreedy: fields[12] as double,
      spoilageRateLP: fields[13] as double,
      spoilageRateOurAlgo: fields[14] as double,
      timeGreedy: fields[15] as double,
      timeLP: fields[16] as double,
      timeOurAlgo: fields[17] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Dataset obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.farm)
      ..writeByte(1)
      ..write(obj.storageHub)
      ..writeByte(2)
      ..write(obj.distributionCentre)
      ..writeByte(3)
      ..write(obj.vehicleType)
      ..writeByte(4)
      ..write(obj.smallVehicleCapacity)
      ..writeByte(5)
      ..write(obj.largeVehicleCapacity)
      ..writeByte(6)
      ..write(obj.perishabilityRate)
      ..writeByte(7)
      ..write(obj.demandLevel)
      ..writeByte(8)
      ..write(obj.trafficDisruption)
      ..writeByte(9)
      ..write(obj.totalCostGreedy)
      ..writeByte(10)
      ..write(obj.totalCostLP)
      ..writeByte(11)
      ..write(obj.totalCostOurAlgo)
      ..writeByte(12)
      ..write(obj.spoilageRateGreedy)
      ..writeByte(13)
      ..write(obj.spoilageRateLP)
      ..writeByte(14)
      ..write(obj.spoilageRateOurAlgo)
      ..writeByte(15)
      ..write(obj.timeGreedy)
      ..writeByte(16)
      ..write(obj.timeLP)
      ..writeByte(17)
      ..write(obj.timeOurAlgo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatasetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
