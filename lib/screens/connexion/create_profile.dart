import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/flare/Astronaut.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingProfile extends StatefulWidget {
  static String id = "create_profil";
  @override
  _LoadingProfileState createState() => _LoadingProfileState();
}

class _LoadingProfileState extends State<LoadingProfile> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFF000428),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: kgradientBackground,
          ),
          speed(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoadingScreen.id);
            },
            child: Hero(
              tag: 2,
              child: Center(
                child: Container(
                  width: data.size.width / 3,
                  height: data.size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(
                            "lib/images/spaceship.png",
                          ))),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: data.size.height / 4,
              ),
              Center(
                child: Text(
                  "Creating Profil",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700),
                ),
              ),
              SpinKitThreeBounce(
                color: Colors.white,
                size: 30.0,
              ),
            ],
          )
        ],
      ),
    );
  }
}
