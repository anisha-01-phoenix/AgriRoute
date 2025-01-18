import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../constants/distribution_constants.dart';
import '../constants/farm_constants.dart';
import '../constants/storage_constants.dart';
import '../constants/vehicle_constants.dart';

class LogisticsScreen extends StatefulWidget {
  @override
  _LogisticsScreenState createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen> {
  String? _selectedFarm;
  String? _selectedStorageHub;
  String? _selectedDistributionCentre;
  String? _selectedVehicleType;

  // Slider values
  double _smallVehicleCapacity = 0;
  double _largeVehicleCapacity = 0;
  double _perishabilityRate = 0;
  double _demandLevel = 0;
  double _trafficDisruption = 0;

  // Store data locally
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('farm', _selectedFarm ?? '');
    prefs.setString('storageHub', _selectedStorageHub ?? '');
    prefs.setString('distributionCentre', _selectedDistributionCentre ?? '');
    prefs.setString('vehicleType', _selectedVehicleType ?? '');
    prefs.setDouble('smallVehicleCapacity', _smallVehicleCapacity);
    prefs.setDouble('largeVehicleCapacity', _largeVehicleCapacity);
    prefs.setDouble('perishabilityRate', _perishabilityRate);
    prefs.setDouble('demandLevel', _demandLevel);
    prefs.setDouble('trafficDisruption', _trafficDisruption);
  }

  // Retrieve data from local storage
  Future<Map<String, dynamic>> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'farm': prefs.getString('farm') ?? '',
      'storageHub': prefs.getString('storageHub') ?? '',
      'distributionCentre': prefs.getString('distributionCentre') ?? '',
      'vehicleType': prefs.getString('vehicleType') ?? '',
      'smallVehicleCapacity': prefs.getDouble('smallVehicleCapacity') ?? 0,
      'largeVehicleCapacity': prefs.getDouble('largeVehicleCapacity') ?? 0,
      'perishabilityRate': prefs.getDouble('perishabilityRate') ?? 0,
      'demandLevel': prefs.getDouble('demandLevel') ?? 0,
      'trafficDisruption': prefs.getDouble('trafficDisruption') ?? 0,
    };
  }

  // Generate CSV
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

  // Export to Excel
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
    // You can implement saving the file to disk here
    print('Excel generated');
  }

  // Export to CSV
  Future<void> _exportToCSV(Map<String, dynamic> data) async {
    String csv = _generateCSV(data);
    // Here you can implement code to save or share the CSV file (e.g., using path_provider, share_plus)
    print(csv);  // For testing
  }

  // To track button color state
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _proceed() async {
    // Logic to handle the proceed action
    print("Proceeding with the following details:");
    print("Farm: $_selectedFarm");
    print("Storage Hub: $_selectedStorageHub");
    print("Distribution Centre: $_selectedDistributionCentre");
    print("Vehicle Type: $_selectedVehicleType");
    print("Small Vehicle Capacity: $_smallVehicleCapacity");
    print("Large Vehicle Capacity: $_largeVehicleCapacity");
    print("Perishability Rate: $_perishabilityRate");
    print("Demand Level: $_demandLevel");
    print("Traffic Disruption: $_trafficDisruption");

    // Show a confirmation dialog or navigate to the next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> data = await _getData();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Dataset'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var entry in data.entries)
                        Text('${entry.key}: ${entry.value}'),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _exportToCSV(data);
                    },
                    child: Text('Export to CSV'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _exportToExcel(data);
                    },
                    child: Text('Export to Excel'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.storage),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Farm Location Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Farm Location',
                  labelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 16),
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                value: _selectedFarm,
                items: farmList.map((farm) {
                  return DropdownMenuItem<String>(
                    value: farm,
                    child: Text(farm),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFarm = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Storage Hub Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Storage Hub',
                  labelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 16),
                  prefixIcon: Icon(Icons.store),
                  border: OutlineInputBorder(),
                ),
                value: _selectedStorageHub,
                items: storageHubList.map((hub) {
                  return DropdownMenuItem<String>(
                    value: hub,
                    child: Text(hub),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStorageHub = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Distribution Centre Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Distribution Centre',
                  labelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 16),
                  prefixIcon: Icon(Icons.local_shipping),
                  border: OutlineInputBorder(),
                ),
                value: _selectedDistributionCentre,
                items: distributionCenterList.map((center) {
                  return DropdownMenuItem<String>(
                    value: center,
                    child: Text(center),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDistributionCentre = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Vehicle Type Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                  labelStyle: TextStyle(color: Colors.orange, fontWeight: FontWeight.w700, fontSize: 16),
                  prefixIcon: Icon(Icons.directions_car),
                  border: OutlineInputBorder(),
                ),
                value: _selectedVehicleType,
                items: vehicleTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Small Vehicle Capacity Slider
              Text("Small Vehicle Capacity: ${_smallVehicleCapacity.toStringAsFixed(0)} kg", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              Slider(
                value: _smallVehicleCapacity,
                min: 0,
                max: 1000,
                divisions: 20,
                label: _smallVehicleCapacity.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _smallVehicleCapacity = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Large Vehicle Capacity Slider
              Text("Large Vehicle Capacity: ${_largeVehicleCapacity.toStringAsFixed(0)} kg", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              Slider(
                value: _largeVehicleCapacity,
                min: 0,
                max: 10000,
                divisions: 100,
                label: _largeVehicleCapacity.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _largeVehicleCapacity = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Perishability Rate Slider
              Text("Perishability Rate: ${_perishabilityRate.toStringAsFixed(1)} days", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              Slider(
                value: _perishabilityRate,
                min: 0,
                max: 30,
                divisions: 30,
                label: _perishabilityRate.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _perishabilityRate = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Demand Level Slider
              Text("Demand Level: ${_demandLevel.toStringAsFixed(0)}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              Slider(
                value: _demandLevel,
                min: 0,
                max: 100,
                divisions: 20,
                label: _demandLevel.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _demandLevel = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Traffic Disruption Slider
              Text("Traffic Disruption: ${_trafficDisruption.toStringAsFixed(1)}%", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              Slider(
                value: _trafficDisruption,
                min: 0,
                max: 100,
                divisions: 20,
                label: _trafficDisruption.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _trafficDisruption = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Proceed Button (Centered, Expanded, Orange Background)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: _proceed,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isButtonPressed ? Colors.orangeAccent : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
