import 'dart:math'; // For random number generation
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:hive/hive.dart';

import '../constants/distribution_constants.dart';
import '../constants/farm_constants.dart';
import '../constants/storage_constants.dart';
import '../constants/vehicle_constants.dart';
import '../models/data_model.dart';

// Random Data Generation Function
Map<String, dynamic> generateRandomData() {
  var random = Random();

  // Pick random values from the lists
  String farm = farmList[random.nextInt(farmList.length)];
  String storageHub = storageHubList[random.nextInt(storageHubList.length)];
  String distributionCentre = distributionCenterList[random.nextInt(distributionCenterList.length)];
  String vehicleType = vehicleTypes[random.nextInt(vehicleTypes.length)];
  double smallVehicleCapacity = random.nextDouble() * vehicleCapacities['Small Vehicle']!;
  double largeVehicleCapacity = random.nextDouble() * vehicleCapacities['Big Vehicle']!;
  double perishabilityRate = random.nextDouble() * 30;
  double demandLevel = random.nextDouble() * 100;
  double trafficDisruption = random.nextDouble() * 100;

  double totalCostGreedy = random.nextDouble() * 1000;
  double totalCostLP = random.nextDouble() * 1200;
  double totalCostOurAlgo = random.nextDouble() * 1100;

  double spoilageRateGreedy = random.nextDouble() * 50;
  double spoilageRateLP = random.nextDouble() * 45;
  double spoilageRateOurAlgo = random.nextDouble() * 40;

  double timeGreedy = random.nextDouble() * 100;
  double timeLP = random.nextDouble() * 150;
  double timeOurAlgo = random.nextDouble() * 120;

  return {
    'farm': farm,
    'storageHub': storageHub,
    'distributionCentre': distributionCentre,
    'vehicleType': vehicleType,
    'smallVehicleCapacity': smallVehicleCapacity,
    'largeVehicleCapacity': largeVehicleCapacity,
    'perishabilityRate': perishabilityRate,
    'demandLevel': demandLevel,
    'trafficDisruption': trafficDisruption,
    'totalCostGreedy': totalCostGreedy,
    'totalCostLP': totalCostLP,
    'totalCostOurAlgo': totalCostOurAlgo,
    'spoilageRateGreedy': spoilageRateGreedy,
    'spoilageRateLP': spoilageRateLP,
    'spoilageRateOurAlgo': spoilageRateOurAlgo,
    'timeGreedy': timeGreedy,
    'timeLP': timeLP,
    'timeOurAlgo': timeOurAlgo,
  };
}

Future<void> storeDataInHive(List<Map<String, dynamic>> dataset) async {
  var box = await Hive.openBox<Dataset>('datasetBox');

  for (var data in dataset) {
    final datasetObject = Dataset(
      farm: data['farm'],
      storageHub: data['storageHub'],
      distributionCentre: data['distributionCentre'],
      vehicleType: data['vehicleType'],
      smallVehicleCapacity: data['smallVehicleCapacity'],
      largeVehicleCapacity: data['largeVehicleCapacity'],
      perishabilityRate: data['perishabilityRate'],
      demandLevel: data['demandLevel'],
      trafficDisruption: data['trafficDisruption'],
      totalCostGreedy: data['totalCostGreedy'],
      totalCostLP: data['totalCostLP'],
      totalCostOurAlgo: data['totalCostOurAlgo'],
      spoilageRateGreedy: data['spoilageRateGreedy'],
      spoilageRateLP: data['spoilageRateLP'],
      spoilageRateOurAlgo: data['spoilageRateOurAlgo'],
      timeGreedy: data['timeGreedy'],
      timeLP: data['timeLP'],
      timeOurAlgo: data['timeOurAlgo'],
    );

    await box.add(datasetObject);
  }
}


// Generate a dataset with at least 1000 entries
Future<List<Map<String, dynamic>>> generateDataset() async {
  int numEntries = 1000 + Random().nextInt(100); // Ensure at least 1000 entries
  List<Map<String, dynamic>> dataset = [];

  for (int i = 0; i < numEntries; i++) {
    dataset.add(generateRandomData());
  }
  storeDataInHive(dataset);
  return dataset;
}

class DatasetScreen extends StatefulWidget {
  @override
  _DatasetScreenState createState() => _DatasetScreenState();
}

class _DatasetScreenState extends State<DatasetScreen> {
  String _generateCSV(Map<String, dynamic> data) {
    List<List<dynamic>> rows = [];
    rows.add(['Farm', 'Storage Hub', 'Distribution Centre', 'Vehicle Type', 'Small Vehicle Capacity', 'Large Vehicle Capacity', 'Perishability Rate', 'Demand Level', 'Traffic Disruption']);
    rows.add([
      data['farm'],
      data['storageHub'],
      data['distributionCentre'],
      data['vehicleType'],
      data['smallVehicleCapacity'],
      data['largeVehicleCapacity'],
      data['perishabilityRate'],
      data['demandLevel'],
      data['trafficDisruption'],
    ]);
    return const ListToCsvConverter().convert(rows);
  }

  Future<void> _exportToExcel(Map<String, dynamic> data) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];
    sheet.appendRow([
      data['farm'],
      data['storageHub'],
      data['distributionCentre'],
      data['vehicleType'],
      data['smallVehicleCapacity'],
      data['largeVehicleCapacity'],
      data['perishabilityRate'],
      data['demandLevel'],
      data['trafficDisruption'],
    ]);
    // Implement saving the file to disk if needed
    print('Excel generated');
  }

  Future<void> _exportToCSV(Map<String, dynamic> data) async {
    String csv = _generateCSV(data);
    print(csv);  // For testing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Dataset', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // Using FutureBuilder to fetch and display data
        future: generateDataset(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            var data = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Scroll vertically
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Scroll horizontally
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowColor: MaterialStateProperty.all(Colors.orange),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Farm')),
                      DataColumn(label: Text('Storage Hub')),
                      DataColumn(label: Text('Distribution Centre')),
                      DataColumn(label: Text('Vehicle Type')),
                      DataColumn(label: Text('Small Vehicle Capacity')),
                      DataColumn(label: Text('Large Vehicle Capacity')),
                      DataColumn(label: Text('Perishability Rate')),
                      DataColumn(label: Text('Demand Level')),
                      DataColumn(label: Text('Traffic Disruption')),
                    ],
                    rows: data.map((entry) {
                      return DataRow(cells: [
                        DataCell(Text(entry['farm'])),
                        DataCell(Text(entry['storageHub'])),
                        DataCell(Text(entry['distributionCentre'])),
                        DataCell(Text(entry['vehicleType'])),
                        DataCell(Text(entry['smallVehicleCapacity'].toStringAsFixed(0) + ' kg')),
                        DataCell(Text(entry['largeVehicleCapacity'].toStringAsFixed(0) + ' kg')),
                        DataCell(Text(entry['perishabilityRate'].toStringAsFixed(1) + ' days')),
                        DataCell(Text(entry['demandLevel'].toStringAsFixed(0))),
                        DataCell(Text(entry['trafficDisruption'].toStringAsFixed(1) + '%')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     // Ensure snapshot has data before exporting to CSV
            //     // if (snapshot.hasData) {
            //     //   _exportToCSV(snapshot.data![0]); // Export only the first entry for testing
            //     // }
            //   },
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            //   child: Text('Export to CSV'),
            // ),
            // SizedBox(width: 10),
            // ElevatedButton(
            //   onPressed: () {
            //     // Ensure snapshot has data before exporting to Excel
            //     // if (snapshot.hasData) {
            //     //   _exportToExcel(snapshot.data![0]); // Export only the first entry for testing
            //     // }
            //   },
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            //   child: Text('Export to Excel'),
            // ),
          ],
        ),
      ),
    );
  }
}
