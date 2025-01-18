import 'package:agro_route/screens/farmer_screen.dart';
import 'package:agro_route/screens/logistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/styled_text.dart';
import 'navigation_farms_page.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {

  String? _selectedItem = "";
  final List<Widget> _pages = [
    FarmerScreen(),
    LogisticsScreen(),
    MainNavigationScreen()
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool exit = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Styled_Text(
            icon: Icon(CupertinoIcons.question_diamond_fill, color: Colors.orange),
            text: 'Confirm Exit',
            color: Colors.orange,
            size: 18,
            fontWeight: FontWeight.bold),
        content: Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                exit = false;
              });
              Navigator.of(context).pop(false);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
            ),
            child: Text("No",
                style: TextStyle(
                    color: Colors.white, backgroundColor: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                exit = true;
                SystemNavigator.pop();
              });
              Navigator.of(context).pop(true);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            child: Text("Yes",
                style: TextStyle(
                    color: Colors.white, backgroundColor: Colors.red)),
          ),
        ],
      ),
    );
    return exit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitConfirmationDialog(context);
        return shouldExit;
      },
      child: Scaffold(
        // drawer: NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Styled_Text(text: 'AgriRoute', color: Colors.white, size: 18, fontWeight: FontWeight.w600),
        ),
        body:  _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          onTap: _onTapped,
          currentIndex: _currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.agriculture_outlined),
              label: "Farmer",
              activeIcon: Icon(Icons.agriculture_rounded),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Logistics",
              activeIcon: Icon(Icons.list_alt_rounded),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house_outlined),
              label: "Farms",
              activeIcon: Icon(Icons.house_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
