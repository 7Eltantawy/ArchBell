import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arch_bell/pages/dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Dashboard())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Arch",
              style: TextStyle(fontSize: 35),
            ),
            Text(
              "Bell",
              style: TextStyle(color: Colors.blue, fontSize: 35),
            ),
          ],
        ),
      ),
    );
  }
}
