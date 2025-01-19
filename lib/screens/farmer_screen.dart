import 'package:agro_route/widgets/styled_text.dart';
import 'package:flutter/material.dart';
import '../constants/crop_constants.dart'; // Ensure cropList is initialized here
import '../constants/farm_constants.dart';

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

  Map<String, TextEditingController> _quantityControllers = {};
  Map<String, TextEditingController> _perishabilityControllers = {};

  // To track button color state
  bool _isButtonPressed = false;

  // To toggle the "Show More" and "Show Less" feature
  bool _showAllCrops = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveDetails() async {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // Farm Location Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Farm Location',
                  labelStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
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

              // Quantity and Perishability Inputs for Crops
              Column(
                children: _selectedCrops.map((crop) {
                  return Column(
                    children: [
                      // Quantity Input
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: _quantityControllers.putIfAbsent(crop, () => TextEditingController()),
                          decoration: InputDecoration(
                            icon: Icon(Icons.production_quantity_limits),
                            labelText: 'Quantity of $crop (kg)',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 3),

                      // Perishability Input
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: _perishabilityControllers.putIfAbsent(crop, () => TextEditingController()),
                          decoration: InputDecoration(
                            icon: Icon(Icons.timelapse),
                            labelText: 'Perishability of $crop (in days)',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Vehicle Speed Inputs (Placed side by side in a row)
              Styled_Text(
                text: 'Vehicle Speed (km/hr):',
                color: Colors.orange,
                size: 16,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  // Small Vehicle Capacity Input
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.directions_car),
                          labelText: 'Small Vehicle Capacity (kg)',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _vehicleDetails['small']['capacity'] = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Space between the two input fields

                  // Big Vehicle Capacity Input
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.directions_car_outlined),
                          labelText: 'Big Vehicle Capacity (kg)',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _vehicleDetails['big']['capacity'] = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Styled_Text(
                text: 'Vehicle Capacity (kg):',
                color: Colors.orange,
                size: 16,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  // Small Vehicle Capacity Input
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.directions_car),
                          labelText: 'Small Vehicle Capacity (kg)',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _vehicleDetails['small']['capacity'] = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Space between the two input fields

                  // Big Vehicle Capacity Input
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.directions_car_outlined),
                          labelText: 'Big Vehicle Capacity (kg)',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _vehicleDetails['big']['capacity'] = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Save and Calculate Button (Centered, Expanded, Orange Background, Click Feedback)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isButtonPressed = !_isButtonPressed;
                    });
                    _saveDetails();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isButtonPressed ? Colors.orangeAccent : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Save and Calculate',
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
              // LineChartWidget(), // Placeholder for graphs (you can implement separately)
            ],
          ),
        ),
      ),
    );
  }
}
