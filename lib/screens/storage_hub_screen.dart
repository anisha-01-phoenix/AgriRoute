import 'package:flutter/material.dart';

import '../constants/storage_constants.dart';

class StorageHubScreen extends StatelessWidget {
  const StorageHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storage Hubs in Jharkhand'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: storageHubList.length,
          itemBuilder: (context, index) {
            final hubName = storageHubList[index];
            return StorageHubCard(
              hubName: hubName,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

class StorageHubCard extends StatelessWidget {
  final String hubName;
  final int index;

  const StorageHubCard({Key? key, required this.hubName, required this.index}) : super(key: key);

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
            Icons.store,
            color: Colors.white,
            size: 40,
          ),
          title: Text(
            hubName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Storage Hub #${index + 1}',
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
                title: Text(hubName),
                content: Text('More details about this storage hub.'),
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
      [Colors.cyan, Colors.teal],
      [Colors.purple, Colors.deepPurple],
      [Colors.orange, Colors.deepOrange],
      [Colors.green, Colors.lightGreen],
      [Colors.red, Colors.pink],
    ];
    return gradients[index % gradients.length];
  }
}
