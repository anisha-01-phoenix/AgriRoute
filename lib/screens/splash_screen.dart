import 'dart:async';
import 'package:agro_route/screens/starting_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StartingScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          image: DecorationImage(
            image: AssetImage('assets/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
