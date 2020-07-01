import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Goals/create_goals.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

final Firestore _fs = Firestore.instance;

class TutorialMissionScreen extends StatefulWidget {
  static String id = "tutorial_mission_screen";
  @override
  _TutorialMissionScreenState createState() => _TutorialMissionScreenState();
}

class _TutorialMissionScreenState extends State<TutorialMissionScreen> {
  int step = 4;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: data.size.height / 8,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Well Done 👨‍🚀",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
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
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16.0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.ease,
                          width: data.size.width,
                          height: data.size.height / 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xFFE1E1E1)),
                        ),
                      );
                    },
                    itemCount: 2,
                  );
                } else {
                  print("NEW DATA MISSIONS !");
                  List<Widget> missionsList = [];
                  final missions = snapshot.data.documents;
                  for (var mission in missions) {
                    final String reference = mission.data["missionReference"];
                    final String missionText = mission.data["missionText"];
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
                  return missionsList.length > 1
                      ? Column(
                          children: missionsList,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                              child: Text(
                            "You don't have any missions, Add a new one... 🌌",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500),
                          )),
                        );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () async {
                    setState(() {
                      step = 5;
                    });
                    Future.delayed(Duration(seconds: 1));
                    await ProfilBrainData().finishTutorial();
                    Phoenix.rebirth(context);
                  },
                  color: kCTA,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Finish the Tutorial",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ),
            ),
            SizedBox(
              height: data.size.height / 10,
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
                    width: step == 5
                        ? (data.size.width / 6) * 6
                        : data.size.width / 6 * 4,
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
        ));
  }
}
