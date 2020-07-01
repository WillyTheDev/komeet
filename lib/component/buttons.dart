import 'package:Komeet/brain/register_brain.dart';
import 'package:Komeet/screens/Goals/create_goals.dart';
import 'package:Komeet/screens/connexion/login_screen.dart';
import 'package:Komeet/screens/connexion/register_screen.dart';
import 'package:flutter/material.dart';

import 'background_gradient.dart';

class RaisedButtonRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, RegisterScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 80.0),
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: Offset.fromDirection(-5, 5),
              )
            ],
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.circular(18.0),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blueAccent, Color(0xFF004e92)])),
      ),
    );
  }
}

class RaisedButtonLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.pushNamed(context, LoginScreen.id);
      },
      disabledElevation: 10.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blueGrey, width: 3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 25.0),
        child: Text(
          "Log in",
          style: TextStyle(
              color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class RaisedButtonCreate extends StatelessWidget {
  RaisedButtonCreate(
      {@required this.onPressed,
      @required this.buttonText,
      @required this.padding});
  final Function onPressed;
  final String buttonText;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Container(
        child: Padding(
          padding: padding,
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
                offset: Offset.fromDirection(-5, 5),
              )
            ],
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF004e92), Colors.blueAccent])),
      ),
    );
  }
}

class ButtonGoogleSignIn extends StatelessWidget {
  const ButtonGoogleSignIn({
    @required this.buttonText,
  });
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Container(
      width: data.size.width / 1.8,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
              offset: Offset.fromDirection(-5, 5),
            )
          ],
          borderRadius: BorderRadius.circular(5.0)),
      child: InkWell(
        onTap: () async {
          RegisterBrain().googleRegister(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("lib/images/google_logo.png"),
                        fit: BoxFit.fill)),
              ),
            ),
            Text(buttonText),
          ],
        ),
      ),
    );
  }
}

class MyFabButton extends StatelessWidget {
  final Function onPressed;
  final double size;
  final double iconSize;
  MyFabButton(
      {@required this.size, @required this.iconSize, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: size * 1.3,
          height: size * 1.3,
          child: new RawMaterialButton(
            fillColor: kBlueLaserColor.withOpacity(0.2),
            shape: new CircleBorder(),
            elevation: 5.0,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: mainColorGradient),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: iconSize,
              ),
            ),
            onPressed: onPressed,
          )),
    );
  }
}

class GoalsButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  const GoalsButton({
    @required this.assetPath,
    @required this.subtitle,
    @required this.title,
    @required this.data,
  });
  final MediaQueryData data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: data.size.height / 8,
        width: data.size.width,
        decoration: BoxDecoration(
            color: Color(0xFF252542),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset.fromDirection(-5, 5),
              )
            ],
            borderRadius: BorderRadius.circular(20.0)),
        child: RawMaterialButton(
          splashColor: Color(0xFF535384),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: () {
            Navigator.pushNamed(context, CreateGoals.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Container(
                      width: data.size.width / 2,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Image(
                  width: data.size.width / 7,
                  height: data.size.height / 7,
                  image: AssetImage(assetPath),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
