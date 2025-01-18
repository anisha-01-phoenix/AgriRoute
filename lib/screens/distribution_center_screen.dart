import 'package:flutter/material.dart';

import '../constants/distribution_constants.dart';

class DistributionCenterScreen extends StatelessWidget {
  const DistributionCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distribution Centers in Jharkhand'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: distributionCenterList.length,
          itemBuilder: (context, index) {
            final centerName = distributionCenterList[index];
            return DistributionCenterCard(
              centerName: centerName,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class DistributionCenterCard extends StatelessWidget {
  final String centerName;
  final int index;

  const DistributionCenterCard({Key? key, required this.centerName, required this.index}) : super(key: key);

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
            Icons.store_mall_directory,
            color: Colors.white,
            size: 40,
          ),
          title: Text(
            centerName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Distribution Center #${index + 1}',
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 20,
          ),
          onTap: () {
            // You can implement further actions here, like navigating to a details page
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(centerName),
                content: Text('More details about this distribution center.'),
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
    // Choose a gradient based on the index to make the cards colorful
    List<List<Color>> gradients = [
      [Colors.pink, Colors.orange],
      [Colors.blue, Colors.cyan],
      [Colors.purple, Colors.deepPurple],
      [Colors.green, Colors.teal],
      [Colors.red, Colors.deepOrange],
    ];
    return gradients[index % gradients.length];
  }
}
