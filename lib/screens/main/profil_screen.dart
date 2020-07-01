import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Tutoriel/create_avatar_screen.dart';
import 'package:Komeet/screens/connexion/HomeScreen.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/mission_request_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friend_request_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilScreen extends StatefulWidget {
  static String id = "profil_screen";
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<ProfilBrainData>(context);

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBackgroundColor,
      endDrawer: ProfilDrawer(data: data, pr: _pr),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[Container()],
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    _pr.userName,
                    style: TextStyle(color: Colors.black),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("open drawer");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Column(
                      children: <Widget>[
                        _pr.newFriendsRequest > 0 || _pr.newMissionsRequest > 0
                            ? Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    (_pr.newFriendsRequest +
                                            _pr.newMissionsRequest)
                                        .toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.dehaze,
                                color: Colors.black87,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            elevation: 10.0,
            pinned: true,
            floating: false,
            backgroundColor: kBackgroundColor,
            expandedHeight: data.size.height / 2,
            flexibleSpace: FlexibleSpaceBar(
              background: Profil(
                email: currentUserEmail,
                data: data,
              ),
            ),
          ),
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
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
                },
                childCount: _pr.missionsCompletedList.length,
              )),
          SliverToBoxAdapter(
            child: SizedBox(
              height: data.size.height / 11,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilDrawer extends StatelessWidget {
  const ProfilDrawer({
    Key key,
    @required this.data,
    @required ProfilBrainData pr,
  })  : _pr = pr,
        super(key: key);

  final MediaQueryData data;
  final ProfilBrainData _pr;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: data.size.width / 1.5,
      child: Drawer(
        elevation: 10.0,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Set Avatar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0),
                ),
                onPressed: () {
                  _pr.getUserRank(currentUserEmail);
                  Navigator.pushNamed(context, CreateAvatarScreen.id);
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, FriendRequestScreen.id);
                },
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _pr.newFriendsRequest > 0,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _pr.newFriendsRequest > 0
                              ? Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      _pr.newFriendsRequest.toString(),
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      _pr.newFriendsRequest.toString(),
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ),
                                )),
                    ),
                    Text(
                      "Friend Request",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, MissionRequestScreen.id);
                },
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _pr.newMissionsRequest > 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _pr.newMissionsRequest > 0
                            ? Container(
                                width: 35.0,
                                height: 35.0,
                                decoration: BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    (_pr.newMissionsRequest).toString(),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    (_pr.newFriendsRequest +
                                            _pr.newMissionsRequest)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Text(
                      "Missions Request",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Share iOs App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0),
                  ),
                ),
                onPressed: () {
                  Share.share(
                      "https://apps.apple.com/us/app/komeet-accomplish-anything/id1500486262?l=fr&ls=1");
                },
              ),
//TODO UNCOMMENT FOR ANDROID BUILD or COMMENT FOR iOS BUILD
//              Padding(
//                padding: const EdgeInsets.only(top: 8.0),
//                child: FlatButton(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text(
//                      "Share Android App",
//                      textAlign: TextAlign.center,
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontWeight: FontWeight.w600,
//                          fontSize: 20.0),
//                    ),
//                  ),
//                  onPressed: () {
//                    Share.share(
//                        "https://play.google.com/store/apps/details?id=ch.wappli.Komeet");
//                  },
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Crédits",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0),
                      ),
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text("Crédits"),
                                content: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text("Icons made by"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Dimitry Miroliubov",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "https://www.flaticon.com/authors/dimitry-miroliubov",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        launch(
                                            "https://www.flaticon.com/authors/dimitry-miroliubov");
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("from"),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "https://www.flaticon.com/",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        launch("https://www.flaticon.com/");
                                      },
                                    ),
                                    Divider(
                                      height: 4.0,
                                      thickness: 2.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "SmashIcons",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "https://www.flaticon.com/authors/smashicons",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        launch(
                                            "https://www.flaticon.com/authors/smashicons");
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("from"),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "https://www.flaticon.com/",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        launch("https://www.flaticon.com/");
                                      },
                                    ),
                                    Divider(
                                      height: 4.0,
                                      thickness: 2.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Freepik",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "https://www.flaticon.com/authors/freepik",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        launch(
                                            "https://www.flaticon.com/authors/freepik");
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("from"),
                                    ),
                                    InkWell(
                                      child: Text(
                                        "https://www.flaticon.com/",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        launch("https://www.flaticon.com/");
                                      },
                                    ),
                                    Divider(
                                      height: 4.0,
                                      thickness: 2.0,
                                    ),
                                  ],
                                ));
                          });
                    }),
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 32.0),
                  child: Text(
                    "Admin",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0),
                  ),
                ),
                onPressed: () async {
                  MissionBrain().adminKeyGenerate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Key"),
                          content: TextField(
                            decoration: InputDecoration(hintText: "AdminKey"),
                            onChanged: (String value) {
                              MissionBrain()
                                  .checkAdminKeyValidity(value, context);
                            },
                          ),
                        );
                      });
                },
              ),
              RaisedButton(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Disconnect",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0),
                  ),
                ),
                onPressed: () async {
                  try {
                    await _auth.signOut();
                    await GoogleSignIn().signOut();
                  } catch (e) {
                    print(e);
                  }

                  Navigator.popAndPushNamed(context, HomeScreen.id);
                },
              ),
              SizedBox(
                height: data.size.height / 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
