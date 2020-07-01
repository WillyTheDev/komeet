import 'dart:io';

import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../loading_screen.dart';
import 'create_goals.dart';

Firestore _fs = Firestore.instance;

class ChooseGoalScreen extends StatefulWidget {
  static String id = "set_goals_screens";
  @override
  _ChooseGoalScreenState createState() => _ChooseGoalScreenState();
}

class _ChooseGoalScreenState extends State<ChooseGoalScreen> {
  bool moveBubble = false;
  @override
  void initState() {
    sleep(Duration(seconds: 1));
    setState(() {
      moveBubble = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
        floatingActionButton: MyFabButton(
          iconSize: 50.0,
          size: 70.0,
          onPressed: () {
            {
              Navigator.pushNamed(context, CreateGoals.id);
            }
          },
        ),
        backgroundColor: Color(0xFF000428),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: kgradientBackground,
              ),
              Positioned(
                top: data.size.height / 2.1,
                left: data.size.width / 3,
                child: Hero(
                  tag: 2,
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
              Hero(
                tag: 1,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          image: AssetImage(
                            "lib/images/horizon-mini.png",
                          ))),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _fs
                      .collection("Users")
                      .document(currentUserEmail)
                      .collection("Missions")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: kBlueLaserColor,
                        ),
                      );
                    }
                    print("NEW DATA MISSIONS !");
                    List<Widget> missionsList = [];
                    final missions = snapshot.data.documents;
                    for (var mission in missions) {
                      final String reference = mission.data["missionReference"];
                      final String missionText =
                          mission.data["missionReference"];
                      print(reference);
                      if (reference.length > 8) {
                        final bool public = mission.data["public"];
                        print(public);
                        missionsList.add(CurrentMission(
                          data: data,
                          reference: reference,
                          public: public,
                          missionText: missionText,
                        ));
                      } else {
                        missionsList.add(CommunityMissionAccepted(
                          missionReference: reference,
                        ));
                        print(missionsList.length);
                      }
                    }
                    return ListView(
                      children: missionsList,
                    );
                  }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: data.size.height / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        color: kBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 10.0,
                            offset: Offset(5, 5),
                          ),
                          BoxShadow(
                            color: Color(0XFFFFFFFF),
                            blurRadius: 7.0,
                            offset: Offset(-5, -5),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Create a New Mission 🧧 with this Button ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
