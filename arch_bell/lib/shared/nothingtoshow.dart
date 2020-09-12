import 'package:flutter/material.dart';

class NoThing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/nothing.png',
            scale: 5,
          ),
        ],
      ),
    );
  }
}
