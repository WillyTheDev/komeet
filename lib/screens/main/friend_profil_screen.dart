import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendProfilScreen extends StatefulWidget {
  static String id = "friend_profil_screen";

  @override
  _FriendProfilScreenState createState() => _FriendProfilScreenState();
}

class _FriendProfilScreenState extends State<FriendProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<ProfilBrainData>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.white,
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            backgroundColor: Colors.white,
            expandedHeight: data.size.height / 2.2,
            flexibleSpace: FlexibleSpaceBar(
              background: FriendProfil(
                email: _pr.email,
                data: data,
              ),
            ),
          ),
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return MissionCompletedGridItem(
                    missionReference:
                        _pr.missionsCompletedList[index].missionReference,
                    missionText: _pr.missionsCompletedList[index].missionText,
                    missionCategory:
                        _pr.missionsCompletedList[index].missionCategory,
                    userName: _pr.missionsCompletedList[index].userName,
                    profilPicture:
                        _pr.missionsCompletedList[index].profilPicture,
                    rank: _pr.missionsCompletedList[index].rank,
                    userText: _pr.missionsCompletedList[index].userText,
                    missionPicture:
                        _pr.missionsCompletedList[index].missionPicture,
                    missionDifficulty:
                        _pr.missionsCompletedList[index].missionDifficulty,
                    missionExp:
                        _pr.missionsCompletedList[index].missionExp.floor(),
                    missionDeadline:
                        _pr.missionsCompletedList[index].missionDeadline);
              }, childCount: _pr.missionsCompletedList.length)),
        ],
      ),
    );
  }
}
