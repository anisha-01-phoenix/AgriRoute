import 'package:hive/hive.dart';

part 'data_model.g.dart'; // To generate Hive adapters

@HiveType(typeId: 0)
class Dataset {
  @HiveField(0)
  final String farm;

  @HiveField(1)
  final String storageHub;

  @HiveField(2)
  final String distributionCentre;

  @HiveField(3)
  final String vehicleType;

  @HiveField(4)
  final double smallVehicleCapacity;

  @HiveField(5)
  final double largeVehicleCapacity;

  @HiveField(6)
  final double perishabilityRate;

  @HiveField(7)
  final double demandLevel;

  @HiveField(8)
  final double trafficDisruption;

  @HiveField(9)
  final double totalCostGreedy;

  @HiveField(10)
  final double totalCostLP;

  @HiveField(11)
  final double totalCostOurAlgo;

  @HiveField(12)
  final double spoilageRateGreedy;

  @HiveField(13)
  final double spoilageRateLP;

  @HiveField(14)
  final double spoilageRateOurAlgo;

  @HiveField(15)
  final double timeGreedy;

  @HiveField(16)
  final double timeLP;

  @HiveField(17)
  final double timeOurAlgo;

  Dataset({
    required this.farm,
    required this.storageHub,
    required this.distributionCentre,
    required this.vehicleType,
    required this.smallVehicleCapacity,
    required this.largeVehicleCapacity,
    required this.perishabilityRate,
    required this.demandLevel,
    required this.trafficDisruption,
    required this.totalCostGreedy,
    required this.totalCostLP,
    required this.totalCostOurAlgo,
    required this.spoilageRateGreedy,
    required this.spoilageRateLP,
    required this.spoilageRateOurAlgo,
    required this.timeGreedy,
    required this.timeLP,
    required this.timeOurAlgo,
  });
}
