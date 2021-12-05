import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app/views/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigateToDeviceScreen);
  }

  navigateToDeviceScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFD98C82),
        body: Center(
          key: const Key('HomeScreen'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text("Bartender's",
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: "Roboto")),
              Text("Companion",
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: "Roboto")),
            ],
          ),
        ));
  }
}
