import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/mission.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _fs = Firestore.instance;

class CommunityMissionScreen extends StatefulWidget {
  static String id = "community_mission_screen";
  @override
  _CommunityMissionScreenState createState() => _CommunityMissionScreenState();
}

class _CommunityMissionScreenState extends State<CommunityMissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        title: Row(
          children: <Widget>[
            Text(
              "Community Missions",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: _fs.collection("CommunityMissions").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: kBlueLaserColor,
              ));
            }
            List<CommunityMission> missionsList = [];
            var missions = snapshot.data.documents;
            for (var mission in missions) {
              String missionTitle = mission.data["missionTitle"];
              String missionSubTitle = mission.data["missionSubtitle"];
              String rewardLink = mission.data["missionReward"];
              Timestamp deadline = mission.data["missionDeadline"];
              int exp = mission.data["missionExp"];
              int nbOfSubscribers = mission.data["usersSubscribed"];
              String missionReference = mission.data["missionReference"];
              String missionCategory = mission.data["missionCategory"];
              int missionDifficulty = mission.data["missionDifficulty"];
              missionsList.add(CommunityMission(
                  missionTitle: missionTitle,
                  missionSubTitle: missionSubTitle,
                  nbOfSubscribers: nbOfSubscribers,
                  rewardLink: rewardLink,
                  exp: exp,
                  missionDeadline: deadline,
                  missionCategory: missionCategory,
                  missionReference: missionReference,
                  missionDifficulty: missionDifficulty));
            }
            return ListView(children: missionsList);
          }),
    );
  }
}
