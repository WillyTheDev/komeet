import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/screens/Goals/create_goals.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _fs = Firestore.instance;

class FirstMissionScreen extends StatefulWidget {
  static String id = "first_mission_screen";
  @override
  _FirstMissionScreenState createState() => _FirstMissionScreenState();
}

class _FirstMissionScreenState extends State<FirstMissionScreen> {
  int step = 3;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: MyFabButton(
            onPressed: () async {
              setState(() {
                step = 4;
              });
              await Future.delayed(Duration(milliseconds: 1000));
              Provider.of<MissionData>(context).getFirstMissionValue(true);
              MissionData().getExpValue();
              Navigator.pushNamed(context, CreateGoals.id);
            },
            size: 50.0,
            iconSize: 35.0,
          ),
        ),
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
                "This is your First Challenge 🔥",
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
                    itemCount: 1,
                  );
                } else {
                  print("NEW DATA MISSIONS !");
                  final missions = snapshot.data.documents;
                  for (var mission in missions) {
                    final String reference = mission.data["missionReference"];
                    final String missionText = mission.data["missionText"];
                    print(reference);
                    return CurrentMission(
                      data: data,
                      missionText: missionText,
                      reference: reference,
                      public: true,
                    );
                  }
                  return Container();
                }
              },
            ),
            SizedBox(
              height: data.size.height / 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Check the first Step and create a new Challenge",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25.0),
              ),
            ),
            SizedBox(
              height: data.size.height / 5,
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
                    width: step == 4
                        ? (data.size.width / 6) * 4
                        : data.size.width / 6 * 3,
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
