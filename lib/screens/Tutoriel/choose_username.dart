import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/text_form_field.dart';
import 'package:Komeet/provider/LoginRegisterData.dart';
import 'package:Komeet/screens/Tutoriel/choose_profile_picture.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _fs = Firestore.instance;

class ChooseUsername extends StatefulWidget {
  static String id = "choose_username";
  @override
  _ChooseUsernameState createState() => _ChooseUsernameState();
}

class _ChooseUsernameState extends State<ChooseUsername> {
  IconData icon = Icons.clear;
  int step = 0;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                height: data.size.height / 3,
              ),
            ),
            Text(
              "Choose your username",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
            ),
            SizedBox(
              height: data.size.height / 15,
            ),
            TextFieldUsername(
                icon: icon,
                onChanged: (value) async {
                  Provider.of<LoginRegisterData>(context).getUsername(value);
                  if (step == 0) {
                    if (value.toString().length <= 3) {
                      setState(() {
                        icon = Icons.clear;
                      });
                    } else {
                      await for (var snapshot
                          in _fs.collection("Users").snapshots()) {
                        for (var user in snapshot.documents) {
                          if (user.data["userName"].toString().toLowerCase() ==
                              value.toString().toLowerCase()) {
                            print(
                                "username already taked ! = ${user.data["userName"]}");
                            setState(() {
                              icon = Icons.warning;
                            });
                            return;
                          } else {
                            print("Username is Correct");
                            setState(() {
                              icon = Icons.check_circle;
                            });
                          }
                        }
                      }
                    }
                  }
                }),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (icon == Icons.check_circle) {
                      setState(() {
                        step = 1;
                      });
                      _fs
                          .collection("Users")
                          .document(currentUserEmail)
                          .updateData({
                        "userName":
                            Provider.of<LoginRegisterData>(context).userName,
                      });
                      await Future.delayed(Duration(milliseconds: 1500));
                      Navigator.pushNamed(context, ChooseProfilPicture.id);
                    } else if (icon == Icons.clear) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Please Enter Something 😓",
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                  "You need to check validity of your username"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"),
                                )
                              ],
                            );
                          });
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  color: icon == Icons.check_circle
                      ? Colors.blueAccent
                      : icon == Icons.clear ? Colors.grey : Colors.red,
                  disabledColor: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      icon == Icons.check_circle
                          ? "Next"
                          : icon == Icons.clear ? "Next" : "Unavailable",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: data.size.height,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "$step/5",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: data.size.height / 70,
                    width: data.size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  AnimatedContainer(
                    height: data.size.height / 70,
                    width: step == 1 ? data.size.width / 6 : 0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.ease,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
