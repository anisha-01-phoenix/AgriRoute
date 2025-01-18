import 'package:agro_route/widgets/styled_text.dart';
import 'package:flutter/material.dart';
import '../constants/crop_constants.dart';
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
              // Farm Location Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Farm Location',
                  labelStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16
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

              // Crops Selection
              Styled_Text(text :'Crops in the Farm:', color: Colors.orange, size: 16, fontWeight: FontWeight.w700,),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: (_showAllCrops ? cropList : cropList.take(6)).map((crop) {
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(crop),
                      ],
                    ),
                    selected: _selectedCrops.contains(crop),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCrops.add(crop);
                        } else {
                          _selectedCrops.remove(crop);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Show More / Show Less Button
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllCrops = !_showAllCrops;
                  });
                },
                child: Text(
                  _showAllCrops ? 'Show Less' : 'Show More',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Crop Quantity and Perishability Inputs
              ..._selectedCrops.map((crop) {
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
                          labelText: 'Perishability of $crop (days and hours)',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                );
              }).toList(),

              // Vehicle Capacity Inputs (Placed side by side in a row)

              Styled_Text(text :'Vehicle Capacity:', color: Colors.orange, size: 16, fontWeight: FontWeight.w700,),
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
