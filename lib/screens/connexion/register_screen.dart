import 'package:Komeet/brain/register_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/component/text_form_field.dart';
import 'package:Komeet/flare/Astronaut.dart';
import 'package:Komeet/provider/LoginRegisterData.dart';
import 'package:Komeet/screens/connexion/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "register_screen";
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showSpinner = false;
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
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: data.size.height / 8,
                  ),
                  Center(
                      child: Text(
                    "Register",
                    style: TextStyle(
                        fontFamily: "Lulo",
                        fontSize: data.size.height / 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                  SizedBox(
                    height: data.size.height / 40,
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
                  TextFieldConfirmPassword(
                    onChanged: (value) {
                      _pr.getConfirmPassword(value);
                    },
                  ),
                  SizedBox(
                    height: data.size.height / 80,
                  ),
                  RaisedButtonCreate(
                    buttonText: "Create Account",
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          showSpinner = true;
                        });
                        print(
                            "${_pr.email}, ${_pr.userName}, ${_pr.password},${_pr.confirmPassword}");
                        await RegisterBrain().createUser(_pr.email,
                            _pr.password, _pr.confirmPassword, context);
                        setState(() {
                          showSpinner = false;
                        });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account ?  ",
                        style: TextStyle(fontSize: data.size.height / 40),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          "Click Here !",
                          style: TextStyle(
                              fontSize: data.size.height / 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800]),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: data.size.height / 50,
                  ),
                  Text("Or"),
                  SizedBox(
                    height: data.size.height / 50,
                  ),
                  ButtonGoogleSignIn(
                    buttonText: "Register with Google",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
