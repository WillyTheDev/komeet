import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/screens/Goals/create_goals.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'community_mission_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Firestore _fs = Firestore.instance;

class CalendarScreen extends StatefulWidget {
  static String id = "calendar_screen";
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    print("Calendar Screen Loaded !");
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: <Widget>[
            Text(
              "Your Missions",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CommunityMissionScreen.id);
                },
                child: Container(
                  height: data.size.height / 20,
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10.0,
                      offset: Offset(3, 3),
                    ),
                  ]),
                  child: Image(
                    image: AssetImage("lib/images/communityIcon.png"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: MyFabButton(
          onPressed: () {
            MissionData().getExpValue();
            Navigator.pushNamed(context, CreateGoals.id);
          },
          size: 50.0,
          iconSize: 35.0,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              initialData:
                  Provider.of<MissionData>(context).currentMissionsData,
              stream: _fs
                  .collection("Users")
                  .document(currentUserEmail)
                  .collection("Missions")
                  .snapshots(),
              builder: (context, snapshot){
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
                    itemCount: 5,
                  );
                } else{
                  print("NEW DATA MISSIONS !");
                  List<Widget> missionsList = [];
                  final missions = snapshot.data.documents;
                  for (var mission in missions){
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
                  missionsList.add(SizedBox(
                    height: data.size.height / 8,
                  ));
                  return missionsList.length > 1
                      ? ListView(
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
              })
        ],
      ),
    );
  }
}
