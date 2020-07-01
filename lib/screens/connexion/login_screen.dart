import 'package:Komeet/brain/register_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/component/text_form_field.dart';
import 'package:Komeet/flare/Astronaut.dart';
import 'package:Komeet/provider/LoginRegisterData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String password;
  bool resetEmail = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<LoginRegisterData>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: kgradientBackground,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("lib/images/background.png"))),
            ),
          ),
          registerAstronaut(),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: data.size.height / 4,
                ),
                Center(
                    child: Text(
                  "Login",
                  style: TextStyle(
                      fontFamily: "Lulo",
                      fontSize: data.size.height / 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
                SizedBox(
                  height: data.size.height / 13,
                ),
                TextFieldEmail(
                  onChanged: (value) {
                    _pr.getEmail(value);
                  },
                ),
                TextFieldPassword(
                  onChanged: (value) {
                    _pr.getPassword(value);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Forget your password ?  ",
                      style: TextStyle(fontSize: data.size.height / 40),
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(("Enter your email")),
                                content: Stack(
                                  children: <Widget>[
                                    Visibility(
                                      visible: resetEmail == false,
                                      child: TextFieldEmail(
                                        onChanged: (value) {
                                          _pr.getEmail(value);
                                        },
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      curve: Curves.bounceIn,
                                      width: !resetEmail ? 0 : 100.0,
                                      height: !resetEmail ? 0 : 100.0,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: !resetEmail ? 0 : 100.0,
                                      ),
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () async {
                                      await _auth.sendPasswordResetEmail(
                                          email: _pr.email);
                                      setState(() {
                                        print("resetEmail state change");
                                        resetEmail = true;
                                      });
                                      await Future.delayed(
                                          Duration(seconds: 3));
                                      setState(() {
                                        resetEmail = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Reset Password",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: kCTA,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: Text(
                        "Click Here !",
                        style: TextStyle(
                            fontSize: data.size.height / 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: data.size.height / 70,
                ),
                RaisedButtonCreate(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 130.0),
                  buttonText: "Log In",
                  onPressed: () async {
                    print("${_pr.email}, ${_pr.password} value");
                    if (_formKey.currentState.validate()) {
                      await RegisterBrain().logInUser(
                          Provider.of<LoginRegisterData>(context).email,
                          Provider.of<LoginRegisterData>(context).password,
                          context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Oops..."),
                            content:
                                Text("Something went wrong, check again !"),
                          );
                        },
                      );
                    }
                  },
                ),
                SizedBox(
                  height: data.size.height / 50,
                ),
                Text("Or"),
                SizedBox(
                  height: data.size.height / 50,
                ),
                ButtonGoogleSignIn(
                  buttonText: "Connect with Google",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
