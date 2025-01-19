import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/crop_constants.dart';
import 'dataset_screen.dart'; // Import the new screen
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
  List<String> _selectedCrops = [];

  // New rate and deadline input fields
  TextEditingController _rateController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController(); // Deadline field controller

  // Slider values
  double _smallVehicleCapacity = 0;
  double _largeVehicleCapacity = 0;
  double _perishabilityRate = 0;
  double _demandLevel = 0;
  double _trafficDisruption = 0;

  // To track the loading state
  bool _isLoading = false;

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
    prefs.setString('rate', _rateController.text);  // Save rate value
    prefs.setString('deadline', _deadlineController.text);  // Save deadline value
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _proceed() async {
    setState(() {
      _isLoading = true; // Show the progress indicator
    });

    // Save the data locally
    await _saveData();

    setState(() {
      _isLoading = false; // Hide the progress indicator
    });

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
    print("Rate: ${_rateController.text}");  // Print the rate value
    print("Deadline: ${_deadlineController.text}");  // Print the deadline value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Open the Dataset Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DatasetScreen()),
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
                  labelStyle: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
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
              // Crops Selection Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Crop',
                  labelStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.nature_people_rounded),
                  border: OutlineInputBorder(),
                ),
                value: _selectedCrops.isNotEmpty ? _selectedCrops.first : null, // Default value if crops are selected
                items: cropList.map((crop) {
                  return DropdownMenuItem<String>(
                    value: crop,
                    child: Text(crop),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (!_selectedCrops.contains(value)) {
                      _selectedCrops.add(value!);  // Add crop to selected crops
                    }
                  });
                },
              ),
              SizedBox(height: 16),

              // Rate Text Input Box with Rupee Icon
              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rate (₹)',
                  labelStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // You can implement any logic on rate change if needed
                },
              ),
              SizedBox(height: 16),

              // Deadline Text Input Box (in hours)
              TextFormField(
                controller: _deadlineController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Deadline (Hours)',
                  labelStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // You can implement any logic on deadline change if needed
                },
              ),
              SizedBox(height: 16),

              // Storage Hub Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Storage Hub',
                  labelStyle: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
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
                  labelStyle: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
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
                  labelStyle: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
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
              Text(
                  "Small Vehicle Capacity: ${_smallVehicleCapacity.toStringAsFixed(0)} kg",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700)),
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
              Text(
                  "Large Vehicle Capacity: ${_largeVehicleCapacity.toStringAsFixed(0)} kg",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700)),
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
              Text(
                  "Perishability Rate: ${_perishabilityRate.toStringAsFixed(1)} days",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700)),
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
              Text("Demand Level: ${_demandLevel.toStringAsFixed(0)}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700)),
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
              Text(
                  "Traffic Disruption: ${_trafficDisruption.toStringAsFixed(1)}%",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700)),
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
                      color: Colors.orange,
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

              // Show progress indicator if loading
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
