import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/flare/Astronaut.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        decoration: kgradientBackground,
        child: Stack(
          children: <Widget>[
            astronaut(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: data.size.height / 20),
                  Center(
                    child: Text(
                      "Komeet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lulo",
                          fontSize: data.size.width / 8,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: data.size.height / 2,
                  ),
                  RaisedButtonRegister(),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButtonLogIn()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
