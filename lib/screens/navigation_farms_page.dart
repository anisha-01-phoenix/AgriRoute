import 'package:flutter/material.dart';
import 'farm_screen.dart';
import 'storage_hub_screen.dart';
import 'distribution_center_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[600]!, Colors.amber[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionCard(
              context,
              title: 'Farms',
              icon: Icons.agriculture,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmScreen()),
                );
              },
              gradientColors: [Colors.deepOrange, Colors.orangeAccent],
            ),
            SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: 'Storage Hubs',
              icon: Icons.store,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StorageHubScreen()),
                );
              },
              gradientColors: [Colors.purple, Colors.deepPurpleAccent],
            ),
            SizedBox(height: 20),
            _buildOptionCard(
              context,
              title: 'Distribution Centers',
              icon: Icons.local_shipping,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DistributionCenterScreen()),
                );
              },
              gradientColors: [Colors.green, Colors.teal],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required String title,
        required IconData icon,
        required List<Color> gradientColors,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 80,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
