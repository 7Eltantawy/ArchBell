import 'package:flutter/material.dart';
import 'package:arch_bell/screen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ArchBell',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}
