import 'package:flutter/material.dart';

import '../constants/farm_constants.dart';

class FarmScreen extends StatelessWidget {
  const FarmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farms in Jharkhand'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: farmList.length,
          itemBuilder: (context, index) {
            final farmName = farmList[index];
            return FarmCard(
              farmName: farmName,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class FarmCard extends StatelessWidget {
  final String farmName;
  final int index;

  const FarmCard({Key? key, required this.farmName, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: _getGradientColors(index),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: Icon(
            Icons.agriculture,
            color: Colors.white,
            size: 40,
          ),
          title: Text(
            farmName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Farm #${index + 1}',
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(farmName),
                content: Text('More details about this farm.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    List<List<Color>> gradients = [
      [Colors.orange, Colors.red],
      [Colors.blue, Colors.indigo],
      [Colors.green, Colors.lime],
      [Colors.purple, Colors.pink],
      [Colors.yellow, Colors.orange],
    ];
    return gradients[index % gradients.length];
  }
}
