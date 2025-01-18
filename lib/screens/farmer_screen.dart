import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../constants/crop_constants.dart';
import '../constants/farm_constants.dart';
// import '../widgets/line_chart.dart';

class FarmerScreen extends StatefulWidget {
  @override
  _FarmerScreenState createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  String? _selectedFarm;
  List<String> _selectedCrops = [];
  final Map<String, dynamic> _cropDetails = {};
  final Map<String, dynamic> _vehicleDetails = {
    'small': {'capacity': 0},
    'big': {'capacity': 0},
  };

  // Controllers for crop quantities and perishability
  Map<String, TextEditingController> _quantityControllers = {};
  Map<String, TextEditingController> _perishabilityControllers = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveDetails() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save farm, crops, vehicle details to shared preferences
    // await prefs.setString('farm', _selectedFarm!);
    // await prefs.setStringList('crops', _selectedCrops);
    // await prefs.setString('vehicle_small_capacity', _vehicleDetails['small']['capacity'].toString());
    // await prefs.setString('vehicle_big_capacity', _vehicleDetails['big']['capacity'].toString());

    // Additional logic for storing perishability and other details...

    // Call optimization API here...

    // Display optimal route, cost, and time
    // For demonstration, we use placeholder values for route, time, and cost
    _showOptimizedResults(context, route: "Route A", cost: 500, time: "2h");
  }

  void _showOptimizedResults(BuildContext context, {required String route, required int cost, required String time}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Optimal Route'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Route: $route"),
            Text("Cost: ₹$cost"),
            Text("Time: $time"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriRoute'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Farm Location'),
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
              Text('Crops in the Farm:'),
              ...cropList.map((crop) {
                return CheckboxListTile(
                  title: Text(crop),
                  value: _selectedCrops.contains(crop),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedCrops.add(crop);
                      } else {
                        _selectedCrops.remove(crop);
                      }
                    });
                  },
                );
              }).toList(),
              SizedBox(height: 16),
              ..._selectedCrops.map((crop) {
                return Column(
                  children: [
                    TextFormField(
                      controller: _quantityControllers.putIfAbsent(crop, () => TextEditingController()),
                      decoration: InputDecoration(labelText: 'Quantity of $crop (kg)'),
                    ),
                    TextFormField(
                      controller: _perishabilityControllers.putIfAbsent(crop, () => TextEditingController()),
                      decoration: InputDecoration(labelText: 'Perishability of $crop (days and hours)'),
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 16),
              Text('Vehicle Details:'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Small Vehicle Capacity (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _vehicleDetails['small']['capacity'] = int.tryParse(value) ?? 0;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Big Vehicle Capacity (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _vehicleDetails['big']['capacity'] = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDetails,
                child: Text('Save and Calculate'),
              ),
              SizedBox(height: 16),
              // LineChartWidget(), // Placeholder for graphs (you can implement separately)
            ],
          ),
        ),
      ),
    );
  }
}

