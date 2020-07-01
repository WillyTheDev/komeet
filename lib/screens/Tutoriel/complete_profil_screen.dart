import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Tutoriel/first_mission_screen.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/main_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Komeet/provider/MissionsData.dart' as M;
import 'package:provider/provider.dart';
import 'package:Komeet/provider/feedData.dart';
import 'package:Komeet/provider/SearchAutoData.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

final FirebaseMessaging _fcm = FirebaseMessaging();

class CompleteScreen extends StatefulWidget {
  static String id = "complete_profil_screen";
  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  int step = 2;

  List<M.Step> stepsList = [
    M.Step(index: 0, text: "Check the first Step  ➡️"),
    M.Step(index: 1, text: "Create a new ChallengeⓂ️"),
    M.Step(index: 2, text: "Accept a Komeet Challenge 🌍"),
    M.Step(index: 3, text: "Send a Message in a the komeet Mission🙋‍♂"),
    M.Step(index: 4, text: "Search 'komeet' and send us a friend request👨‍🚀"),
    M.Step(index: 5, text: "Send us a message ✉"),
    M.Step(index: 6, text: "Swipe this mission ➡ to complete "),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.5,
      upperBound: 0.75,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 0.75);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64.0),
        child: MyFabButton(
          onPressed: () async {
            setState(() {
              step = 3;
            });
            await MissionBrain().addMissionToDatabase(
                "Tutorial",
                "Single Task",
                stepsList,
                1,
                true,
                await ProfilBrainData().getUserName(currentUserEmail),
                DateTime.now().add(Duration(days: 2)),
                500);
//            await ProfilBrainData().finishTutorial();
//            Phoenix.rebirth(context);
            Future.delayed(Duration(milliseconds: 500));
            Navigator.pushNamed(context, FirstMissionScreen.id);
          },
          size: animation.value * 70,
          iconSize: animation.value * 50,
        ),
      ),
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomPadding: false,
      body: Stack(children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Add your first Mission 🎯",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 45.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Click on the blue Button",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30.0,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: data.size.height / 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "$step/5",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
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
                        width: step == 3
                            ? (data.size.width / 6) * 3
                            : data.size.width / 6 * 2,
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
        ),
      ]),
    );
  }
}
