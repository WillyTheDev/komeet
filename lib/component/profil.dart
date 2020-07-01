import 'package:Komeet/brain/friend_brain.dart';
import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/brain/progression_brain.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/Chat_Screen.dart';
import 'package:Komeet/screens/main/friend_list_screen.dart';
import 'package:Komeet/screens/main/friend_profil_screen.dart';
import 'package:Komeet/screens/main/profil_screen.dart';
import 'package:Komeet/screens/main/user_list_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Komeet/screens/Tutoriel/create_avatar_screen.dart';

import 'package:provider/provider.dart';

import 'background_gradient.dart';

Firestore _fs = Firestore.instance;

class Profil extends StatefulWidget {
  Profil({
    @required this.data,
    @required this.email,
  });
  final String email;
  final MediaQueryData data;

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String profilPicture;
  String userName = "loading";
  String userRank = "loading";
  String userFriends = "loading";
  String userMissionCompleted = "loading";
  int userExp = 0;
  String userFollowing = "loading";
  String currentMissionsLength;
  Map avatar;

  final imageAddedSnackBar = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Picture added !  📸 ",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<ProfilBrainData>(context);
    return StreamBuilder(
        stream: _fs.collection("Users").document(currentUserEmail).snapshots(),
        initialData: _pr.profilData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("user email = $currentUserEmail");
            return Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Container(
                  width: widget.data.size.width,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey,
                        blurRadius: 10.0,
                        offset: Offset(3, 3),
                      ),
                      BoxShadow(
                        color: Color(0XFFFFFFFF),
                        blurRadius: 7.0,
                        offset: Offset(-3, -3),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "No Connection...🦖",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ));
          }
          avatar = snapshot.data["Avatar"];
          userName = snapshot.data["userName"];
          userRank = snapshot.data["rank"].toString();
          userFriends = snapshot.data["friends"].toString();
          userMissionCompleted = snapshot.data["missionCompleted"].toString();
          userExp = snapshot.data["userExp"];
          userFollowing = snapshot.data["following"].toString();
          profilPicture = snapshot.data["profilPicture"];

          return Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Container(
              width: widget.data.size.width,
              decoration: BoxDecoration(
                color: kBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 10.0,
                    offset: Offset(3, 3),
                  ),
                  BoxShadow(
                    color: Color(0XFFFFFFFF),
                    blurRadius: 7.0,
                    offset: Offset(-3, -3),
                  )
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: widget.data.size.height / 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          profilPicture != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kBackgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey,
                                        blurRadius: 10.0,
                                        offset: Offset(3, 3),
                                      ),
                                      BoxShadow(
                                        color: Color(0XFFFFFFFF),
                                        blurRadius: 7.0,
                                        offset: Offset(-3, -3),
                                      )
                                    ],
                                  ),
                                  child: InkWell(
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFFE1E8E7),
                                      backgroundImage:
                                          NetworkImage(profilPicture),
                                      maxRadius: 50.0,
                                      minRadius: 20.0,
                                    ),
                                    onTap: () {
                                      ProfilBrainData().getImage(userName);
                                    },
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ProfilBrainData().getImage(userName);
                                  },
                                  child: Container(
                                    height: data.size.height / 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: kBackgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey,
                                          blurRadius: 10.0,
                                          offset: Offset(3, 3),
                                        ),
                                        BoxShadow(
                                          color: Color(0XFFFFFFFF),
                                          blurRadius: 7.0,
                                          offset: Offset(-3, -3),
                                        )
                                      ],
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Avatar(
                                            clotheColor: avatar["clotheColor"],
                                            bodyType: avatar["avatarType"],
                                            bodyColor: avatar["bodyColor"],
                                            hairColor: avatar["hairColor"],
                                            hairStyle: avatar["hairStyle"],
                                            background:
                                                avatar["backgroundColor"]),
                                      ],
                                    ),
                                  ),
                                ),
                          Column(
                            children: <Widget>[
                              Text(
                                userName,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Level : ",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "$userRank",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        color: Level()
                                            .levelColor(int.parse(userRank)),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FutureBuilder<QuerySnapshot>(
                                        future: _fs
                                            .collection("Users")
                                            .document(currentUserEmail)
                                            .collection("Missions")
                                            .getDocuments(),
                                        initialData:
                                            Provider.of<MissionData>(context)
                                                .currentMissionsData,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            print("NODATACURENTMISSION");
                                            return Column(
                                              children: <Widget>[
                                                Text(
                                                  "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18.0),
                                                ),
                                                Text("Current...")
                                              ],
                                            );
                                          } else {
                                            print("CURRENT MISSION = ${snapshot.data.documents.length}");
                                            return Column(
                                              children: <Widget>[
                                                Text(

                                                  snapshot.data.documents.length.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18.0),
                                                ),
                                                Text("Current...")
                                              ],
                                            );
                                          }
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          userMissionCompleted,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0),
                                        ),
                                        Text("Completed...")
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Provider.of<ProfilBrainData>(context, listen: false)
                                            .listOfChatFriend();
                                        Navigator.pushNamed(
                                            context, FriendsListChatScreen.id);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            userFriends,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.0),
                                          ),
                                          Text(
                                            "Friends",
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text("$userExp/1000"),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        width: widget.data.size.width,
                        height: 35.0,
                        alignment: Alignment(-1.0, 0.0),
                        decoration: BoxDecoration(
                            color: kBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey,
                                blurRadius: 10.0,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: Color(0XFFFFFFFF),
                                blurRadius: 7.0,
                                offset: Offset(-3, -3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width:
                                widget.data.size.width / 100 * (userExp / 10),
                            height: 24.0,
                            decoration: BoxDecoration(
                              gradient: mainColorGradient,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10.0,
                                  offset: Offset(2, 2),
                                ),
                                BoxShadow(
                                  color: Color(0XFFFFFFFF),
                                  blurRadius: 7.0,
                                  offset: Offset(-2, -2),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment(-1.0, 0.0),
                        child: Text(
                          "Badges",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: kBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 10.0,
                                    offset: Offset(3, 3),
                                  ),
                                  BoxShadow(
                                    color: Color(0XFFFFFFFF),
                                    blurRadius: 7.0,
                                    offset: Offset(-3, -3),
                                  )
                                ],
                              ),
                              child: Tooltip(
                                message: _pr.userBadgeList[index].description,
                                child: Image(
                                  image: NetworkImage(
                                      _pr.userBadgeList[index].url),
                                  height: data.size.height / 9,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: _pr.userBadgeList.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class FriendProfil extends StatefulWidget {
  FriendProfil({@required this.data, @required this.email});
  final String email;
  final MediaQueryData data;
  @override
  _FriendProfilState createState() => _FriendProfilState();
}

class _FriendProfilState extends State<FriendProfil> {
  String profilPicture;
  String userName = "loading";
  String userRank = "loading";
  String userFriends = "loading";
  String userMissionCompleted = "loading";
  int userExp = 0;
  String userFollowing = "loading";
  String currentMissionsLength;

  final sendRequest = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Friend Request Send !  📨",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 25.0),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<ProfilBrainData>(context);
    return StreamBuilder(
        stream: _fs.collection("Users").document(widget.email).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          userName = snapshot.data["userName"];
          userRank = snapshot.data["rank"].toString();
          userFriends = snapshot.data["friends"].toString();
          userMissionCompleted = snapshot.data["missionCompleted"].toString();
          userExp = snapshot.data["userExp"];
          userFollowing = snapshot.data["following"].toString();
          profilPicture = snapshot.data["profilPicture"];
          currentMissionsLength = snapshot.data["currentMission"].toString();
          if (userName == ProfilBrainData().userName) {
            Navigator.pushNamed(context, ProfilScreen.id);
          }
          return Container(
            width: widget.data.size.width,
            decoration: BoxDecoration(
              color: kBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  blurRadius: 10.0,
                  offset: Offset(3, 3),
                ),
                BoxShadow(
                  color: Color(0XFFFFFFFF),
                  blurRadius: 7.0,
                  offset: Offset(-3, -3),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        profilPicture != null
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 10.0,
                                      offset: Offset(3, 3),
                                    ),
                                    BoxShadow(
                                      color: Color(0XFFFFFFFF),
                                      blurRadius: 7.0,
                                      offset: Offset(-3, -3),
                                    )
                                  ],
                                ),
                                child: Image(
                                  image: NetworkImage(profilPicture),
                                )

//                                CircleAvatar(
//                                  backgroundColor: Color(0xFFE1E8E7),
//                                  backgroundImage: NetworkImage(profilPicture),
//                                ),
                                )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 10.0,
                                      offset: Offset(3, 3),
                                    ),
                                    BoxShadow(
                                      color: Color(0XFFFFFFFF),
                                      blurRadius: 7.0,
                                      offset: Offset(-3, -3),
                                    )
                                  ],
                                ),
                                child: StreamBuilder<DocumentSnapshot>(
                                    stream: _fs
                                        .collection("Users")
                                        .document(widget.email)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Avatar(
                                            clotheColor: 1,
                                            bodyType: "female",
                                            bodyColor: 5,
                                            hairColor: 3,
                                            hairStyle: 4,
                                            background: 3);
                                      }
                                      var avatar = snapshot.data["Avatar"];
                                      return Avatar(
                                          clotheColor: avatar["clotheColor"],
                                          bodyType: avatar["avatarType"],
                                          bodyColor: avatar["bodyColor"],
                                          hairColor: avatar["hairColor"],
                                          hairStyle: avatar["hairStyle"],
                                          background:
                                              avatar["backgroundColor"]);
                                    }),
                              ),
                        Column(
                          children: <Widget>[
                            Text(
                              userName,
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Level :  ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "$userRank",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Level()
                                          .levelColor(int.parse(userRank)),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: _fs
                                              .collection("Users")
                                              .document(widget.email)
                                              .collection("Missions")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text(
                                                "0",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18.0),
                                              );
                                            }
                                            return Text(
                                              snapshot.data.documents.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18.0),
                                            );
                                          }),
                                    ),
                                    Text("Current...")
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        userMissionCompleted,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    Text("Complete...")
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Provider.of<ProfilBrainData>(context, listen: false).getListOfFriends(
                                        await Provider.of<ProfilBrainData>(context, listen: false).getEmail(userName));
                                    Navigator.pushNamed(
                                        context, FriendsListScreen.id);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          userFriends,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                      Text("Friends")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Provider.of<ProfilBrainData>(context).isFriend
                                ? SizedBox(
                                    height: 50.0,
                                  )
                                : Provider.of<ProfilBrainData>(context)
                                        .friendRequestAlreadySend
                                    ? Text(
                                        "Friend Request already send",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0),
                                      )
                                    : RaisedButton(
                                        onPressed: () {
                                          FriendBrain().askFriends(userName);
                                          Scaffold.of(context)
                                              .showSnackBar(sendRequest);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        color: kCTA,
                                        child: Text(
                                          "Send Friend Request",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20.0),
                                        ),
                                      ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text("$userExp/1000"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      width: widget.data.size.width,
                      height: 30.0,
                      alignment: Alignment(-1.0, 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: kBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 10.0,
                            offset: Offset(3, 3),
                          ),
                          BoxShadow(
                            color: Color(0XFFFFFFFF),
                            blurRadius: 7.0,
                            offset: Offset(-3, -3),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: widget.data.size.width / 100 * (userExp / 10),
                          height: 20.0,
                          decoration: BoxDecoration(
                            gradient: mainColorGradient,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey,
                                blurRadius: 10.0,
                                offset: Offset(3, 3),
                              ),
                              BoxShadow(
                                color: Color(0XFFFFFFFF),
                                blurRadius: 7.0,
                                offset: Offset(-3, -3),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "Badge",
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10.0,
                                  offset: Offset(3, 3),
                                ),
                                BoxShadow(
                                  color: Color(0XFFFFFFFF),
                                  blurRadius: 7.0,
                                  offset: Offset(-3, -3),
                                )
                              ],
                            ),
                            child: Tooltip(
                              message: _pr.userBadgeList[index].description,
                              child: Image(
                                image:
                                    NetworkImage(_pr.userBadgeList[index].url),
                                height: data.size.height / 9,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _pr.userBadgeList.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class SearchedProfile extends StatelessWidget {
  final String profilPicture;
  final String username;
  final String userRank;
  final String searchUserEmail;
  SearchedProfile(
      {@required this.profilPicture,
      @required this.username,
      @required this.userRank,
      @required this.searchUserEmail});
  final requestFriends = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Request Send !  📨",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );
  bool friendRequestAlreadySend = false;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        height: data.size.height / 9,
        decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  Provider.of<ProfilBrainData>(context, listen: false).getEmail(username);
                  Provider.of<ProfilBrainData>(context, listen: false)
                      .getMissionsCompletedList(
                          await ProfilBrainData().getEmail(username));
                  Provider.of<ProfilBrainData>(context, listen: false)
                      .getBadgeList(await ProfilBrainData().getEmail(username));
                  Provider.of<ProfilBrainData>(context, listen: false)
                      .isAlreadyFriend(username);
                  Navigator.pushNamed(context, FriendProfilScreen.id);
                },
                child: profilPicture != null
                    ? CircleAvatar(
                        backgroundColor: Color(0xFFE1E8E7),
                        backgroundImage: NetworkImage(profilPicture),
                        maxRadius: 30.0,
                        minRadius: 20.0,
                      )
                    : StreamBuilder<DocumentSnapshot>(
                        stream: _fs
                            .collection("Users")
                            .document(searchUserEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          print("user email = $searchUserEmail");
                          if (!snapshot.hasData) {
                            return Avatar(
                                clotheColor: 1,
                                bodyType: "female",
                                bodyColor: 3,
                                hairColor: 4,
                                hairStyle: 3,
                                background: 2);
                          }
                          var avatar = snapshot.data["Avatar"];
                          print("clotheColor = ${avatar["clotheColor"]}");
                          return Avatar(
                              clotheColor: avatar["clotheColor"],
                              bodyType: avatar["avatarType"],
                              bodyColor: avatar["bodyColor"],
                              hairColor: avatar["hairColor"],
                              hairStyle: avatar["hairStyle"],
                              background: avatar["backgroundColor"]);
                        }),
              ),
              SizedBox(
                width: data.size.width / 20,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                        await ProfilBrainData().getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .isAlreadyFriend(username);
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .checkFriendRequestAlreadySend(
                            friendRequestAlreadySend);
                    Navigator.pushNamed(context, FriendProfilScreen.id);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "level: ",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "$userRank",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Level().levelColor(int.parse(userRank)),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _fs
                      .collection("Users")
                      .document(searchUserEmail)
                      .collection("FriendsRequest")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              FriendBrain().askFriends(username);
                              Scaffold.of(context).showSnackBar(requestFriends);
                            },
                            child: Icon(
                              Icons.person_add,
                              size: 30.0,
                              color: kCTA,
                            ),
                          ));
                    }
                    for (var user in snapshot.data.documents) {
                      if (user.data["friendEmail"] == currentUserEmail) {
                        friendRequestAlreadySend = true;
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "📨",
                              style: TextStyle(fontSize: 30.0),
                            ));
                      }
                    }
                    friendRequestAlreadySend = false;
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            FriendBrain().askFriends(username);
                            Scaffold.of(context).showSnackBar(requestFriends);
                          },
                          child: Icon(
                            Icons.person_add,
                            size: 30.0,
                            color: kCTA,
                          ),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class ChatProfil extends StatelessWidget {
  ChatProfil(
      {@required this.username,
      @required this.profilPicture,
      @required this.chatReference});
  final chatReference;
  final String profilPicture;
  final String username;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: InkWell(
        onTap: () async {
          Provider.of<ProfilBrainData>(context, listen: false).getChatReference(username);
          Provider.of<ProfilBrainData>(context, listen: false).getCurrentFriends(username);
          Provider.of<ProfilBrainData>(context, listen: false).getUserName(currentUserEmail);
          Navigator.pushNamed(context, ChatScreen.id);
        },
        child: Container(
          width: data.size.width,
          height: data.size.height / 10,
          decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
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
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .isAlreadyFriend(username);
                    Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                        await ProfilBrainData().getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .checkFriendRequestAlreadySend(true);
                    Navigator.pushNamed(context, FriendProfilScreen.id);
                  },
                  child: profilPicture != null
                      ? CircleAvatar(
                          maxRadius: 30.0,
                          minRadius: 15.0,
                          backgroundColor: Color(0xFFE1E8E7),
                          backgroundImage: NetworkImage(profilPicture))
                      : StreamBuilder<QuerySnapshot>(
                          stream: _fs.collection("Users").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Avatar(
                                  clotheColor: 1,
                                  bodyType: "female",
                                  bodyColor: 4,
                                  hairColor: 5,
                                  hairStyle: 5,
                                  background: 1);
                            }
                            for (var user in snapshot.data.documents) {
                              if (user.data["userName"] == username) {
                                var avatar = user.data["Avatar"];
                                return Avatar(
                                    clotheColor: avatar["clotheColor"],
                                    bodyType: avatar["avatarType"],
                                    bodyColor: avatar["bodyColor"],
                                    hairColor: avatar["hairColor"],
                                    hairStyle: avatar["hairStyle"],
                                    background: avatar["backgroundColor"]);
                              }
                            }
                            return Avatar(
                                clotheColor: 1,
                                bodyType: "female",
                                bodyColor: 4,
                                hairColor: 5,
                                hairStyle: 5,
                                background: 1);
                          }),
                ),
                SizedBox(
                  width: data.size.width / 50,
                ),
                InkWell(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .isAlreadyFriend(username);
                    Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                        await ProfilBrainData().getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .checkFriendRequestAlreadySend(true);
                    Navigator.pushNamed(context, FriendProfilScreen.id);
                  },
                  child: Text(
                    username,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _fs
                      .collection("PrivateChat")
                      .document(chatReference)
                      .collection("Chat")
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool newMessage = false;
                    if (!snapshot.hasData) {
                      return IconButton(
                        icon: Icon(
                          Icons.message,
                          color: newMessage ? Colors.red : Colors.black,
                          size: 30.0,
                        ),
                        onPressed: () async {
                          await Provider.of<ProfilBrainData>(context, listen: false)
                              .getChatReference(username);
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .getCurrentFriends(username);
                          await Provider.of<ProfilBrainData>(context, listen: false)
                              .getUserName(currentUserEmail);
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .readAllPrivateMessage(chatReference);
                          Navigator.pushNamed(context, ChatScreen.id);
                        },
                      );
                    }
                    for (var message in snapshot.data.documents) {
                      if (message.data["email"] != currentUserEmail) {
                        if (message.data["read"] == false) {
                          newMessage = true;
                          Provider.of<ProfilBrainData>(context)
                              .getNewPrivateMessage(true);
                        }
                      }
                    }
                    return IconButton(
                      icon: Icon(
                        Icons.message,
                        color: newMessage ? Colors.red : Colors.black,
                        size: 30.0,
                      ),
                      onPressed: () async {
                        await Provider.of<ProfilBrainData>(context, listen: false)
                            .getChatReference(username);
                        Provider.of<ProfilBrainData>(context, listen: false)
                            .getCurrentFriends(username);
                        Provider.of<ProfilBrainData>(context, listen: false)
                            .getUserName(currentUserEmail);
                        Provider.of<ProfilBrainData>(context, listen: false)
                            .readAllPrivateMessage(chatReference);
                        Navigator.pushNamed(context, ChatScreen.id);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FriendRequestProfil extends StatelessWidget {
  FriendRequestProfil({@required this.profilPicture, @required this.userName, @required this.friendEmail});
  final String profilPicture;
  final String userName;
  final String friendEmail;
  final accept = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Friend Request Accepted ! 👏 ",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26.0),
      ),
    ),
  );
  final denied = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Friend Request Rejected ! 😮 ",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26.0),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      height: data.size.height / 12,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                Provider.of<ProfilBrainData>(context, listen: false).getMissionsCompletedList(
                    await Provider.of<ProfilBrainData>(context, listen: false)
                        .getEmail(userName));
                Provider.of<ProfilBrainData>(context, listen: false)
                    .getBadgeList(await ProfilBrainData().getEmail(userName));
                Provider.of<ProfilBrainData>(context, listen: false)
                    .checkFriendRequestAlreadySend(false);
                Navigator.pushNamed(context, FriendProfilScreen.id);
              },
              child: profilPicture != null
                  ? CircleAvatar(
                      maxRadius: 25.0,
                      minRadius: 15.0,
                      backgroundColor: Color(0xFFE1E8E7),
                      backgroundImage: NetworkImage(profilPicture),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: _fs.collection("Users").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Avatar(
                              clotheColor: 1,
                              bodyType: "female",
                              bodyColor: 4,
                              hairColor: 5,
                              hairStyle: 5,
                              background: 1);
                        }
                        for (var user in snapshot.data.documents) {
                          if (user.data["userName"] == userName) {
                            var avatar = user.data["Avatar"];
                            return Avatar(
                                clotheColor: avatar["clotheColor"],
                                bodyType: avatar["avatarType"],
                                bodyColor: avatar["bodyColor"],
                                hairColor: avatar["hairColor"],
                                hairStyle: avatar["hairStyle"],
                                background: avatar["backgroundColor"]);
                          }
                        }
                        return Avatar(
                            clotheColor: 1,
                            bodyType: "female",
                            bodyColor: 4,
                            hairColor: 5,
                            hairStyle: 5,
                            background: 1);
                      }),
            ),
            GestureDetector(
              onTap: () async {
                Provider.of<ProfilBrainData>(context, listen: false).getMissionsCompletedList(
                    await Provider.of<ProfilBrainData>(context, listen: false)
                        .getEmail(userName));
                Provider.of<ProfilBrainData>(context, listen: false)
                    .getBadgeList(await ProfilBrainData().getEmail(userName));
                Provider.of<ProfilBrainData>(context, listen: false)
                    .checkFriendRequestAlreadySend(false);
                Navigator.pushNamed(context, FriendProfilScreen.id);
              },
              child: Container(
                padding: EdgeInsets.only(left: 4.0),
                constraints: BoxConstraints(maxWidth: data.size.width / 3.2),
                child: Text(
                  userName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                FriendBrain().rejectFriends(userName);
                Scaffold.of(context).showSnackBar(denied);
              },
              child: Text("Reject",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
            FlatButton(
              onPressed: () {
                FriendBrain().acceptFriends(userName, profilPicture, friendEmail);
                Scaffold.of(context).showSnackBar(accept);
              },
              color: kBlueLaserColor,
              child: Text("Accept",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class FriendMissionRequestProfil extends StatelessWidget {
  FriendMissionRequestProfil(
      {@required this.profilPicture,
      @required this.userName,
      @required this.reference});
  final String profilPicture;
  final String userName;
  final String reference;
  final accept = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Mission Request Accepted ! 👏 ",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26.0),
      ),
    ),
  );
  final denied = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Mission Request Rejected ! 😮 ",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 26.0),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .getMissionsCompletedList(
                                  await Provider.of<ProfilBrainData>(context, listen: false)
                                      .getEmail(userName));
                          Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                              await ProfilBrainData().getEmail(userName));
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .checkFriendRequestAlreadySend(false);
                          Navigator.pushNamed(context, FriendProfilScreen.id);
                        },
                        child: profilPicture != null
                            ? CircleAvatar(
                                maxRadius: 25.0,
                                minRadius: 15.0,
                                backgroundColor: Color(0xFFE1E8E7),
                                backgroundImage: NetworkImage(profilPicture),
                              )
                            : StreamBuilder<QuerySnapshot>(
                                stream: _fs.collection("Users").snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Avatar(
                                        clotheColor: 1,
                                        bodyType: "female",
                                        bodyColor: 4,
                                        hairColor: 5,
                                        hairStyle: 5,
                                        background: 1);
                                  }
                                  for (var user in snapshot.data.documents) {
                                    if (user.data["userName"] == userName) {
                                      var avatar = user.data["Avatar"];
                                      return Avatar(
                                          clotheColor: avatar["clotheColor"],
                                          bodyType: avatar["avatarType"],
                                          bodyColor: avatar["bodyColor"],
                                          hairColor: avatar["hairColor"],
                                          hairStyle: avatar["hairStyle"],
                                          background:
                                              avatar["backgroundColor"]);
                                    }
                                  }
                                  return Avatar(
                                      clotheColor: 1,
                                      bodyType: "female",
                                      bodyColor: 4,
                                      hairColor: 5,
                                      hairStyle: 5,
                                      background: 1);
                                }),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .getMissionsCompletedList(
                                  await Provider.of<ProfilBrainData>(context, listen: false)
                                      .getEmail(userName));
                          Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                              await ProfilBrainData().getEmail(userName));
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .checkFriendRequestAlreadySend(false);
                          Navigator.pushNamed(context, FriendProfilScreen.id);
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 4.0),
                          constraints:
                              BoxConstraints(maxWidth: data.size.width / 2),
                          child: Text(
                            userName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      MissionBrain().rejectMissionRequest(reference);
                      Scaffold.of(context).showSnackBar(denied);
                    },
                    child: Text("Reject",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: _fs
                      .collection("Missions")
                      .document(reference)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String missionText = snapshot.data["missionText"];
                    String missionAdmin = snapshot.data["missionAdmin"];
                    String missionCategory = snapshot.data["missionCategory"];
                    Timestamp deadline = snapshot.data["missionDeadline"];
                    DateTime missionDeadline = deadline.toDate();
                    dynamic missionExp = snapshot.data["missionExp"];
                    int missionDifficulty = snapshot.data["missionDifficulty"];
                    int usersSubscribed = snapshot.data["usersSubscribed"];
                    return SearchedMission(
                        isRequest: true,
                        missionText: missionText,
                        missionAdmin: missionAdmin,
                        missionCategory: missionCategory,
                        deadline: missionDeadline,
                        missionExp: missionExp.toDouble(),
                        missionDifficulty: missionDifficulty,
                        missionReference: reference,
                        usersSubscribed: usersSubscribed);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class SendMissionInvitationProfil extends StatelessWidget {
  SendMissionInvitationProfil(
      {@required this.username,
      @required this.profilPicture,
      @required this.userEmail});
  final String profilPicture;
  final String username;
  final String userEmail;
  final missionRequest = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Request Send !  📨",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );
  bool missionInvitationSend = false;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: InkWell(
        onTap: () async {
          Provider.of<ProfilBrainData>(context, listen: false).getChatReference(username);
          Provider.of<ProfilBrainData>(context, listen: false).getCurrentFriends(username);
          Provider.of<ProfilBrainData>(context, listen: false).getUserName(currentUserEmail);
          Navigator.pushNamed(context, ChatScreen.id);
        },
        child: Container(
          width: data.size.width,
          height: data.size.height / 10,
          decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
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
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .isAlreadyFriend(username);
                    Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                        await ProfilBrainData().getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .checkFriendRequestAlreadySend(true);
                    Navigator.pushNamed(context, FriendProfilScreen.id);
                  },
                  child: profilPicture != null
                      ? CircleAvatar(
                          maxRadius: 30.0,
                          minRadius: 15.0,
                          backgroundColor: Color(0xFFE1E8E7),
                          backgroundImage: NetworkImage(profilPicture))
                      : StreamBuilder<QuerySnapshot>(
                          stream: _fs.collection("Users").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Avatar(
                                  clotheColor: 1,
                                  bodyType: "female",
                                  bodyColor: 4,
                                  hairColor: 5,
                                  hairStyle: 5,
                                  background: 1);
                            }
                            for (var user in snapshot.data.documents) {
                              if (user.data["userName"] == username) {
                                var avatar = user.data["Avatar"];
                                return Avatar(
                                    clotheColor: avatar["clotheColor"],
                                    bodyType: avatar["avatarType"],
                                    bodyColor: avatar["bodyColor"],
                                    hairColor: avatar["hairColor"],
                                    hairStyle: avatar["hairStyle"],
                                    background: avatar["backgroundColor"]);
                              }
                            }
                            return Avatar(
                                bodyType: "female",
                                clotheColor: 1,
                                bodyColor: 4,
                                hairColor: 5,
                                hairStyle: 5,
                                background: 1);
                          }),
                ),
                SizedBox(
                  width: data.size.width / 50,
                ),
                InkWell(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .isAlreadyFriend(username);
                    Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                        await ProfilBrainData().getEmail(username));
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .checkFriendRequestAlreadySend(true);
                    Navigator.pushNamed(context, FriendProfilScreen.id);
                  },
                  child: Text(
                    username,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _fs
                        .collection("Users")
                        .document(userEmail)
                        .collection("MissionsRequest")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                MissionBrain();
                                Scaffold.of(context)
                                    .showSnackBar(missionRequest);
                              },
                              child: Icon(
                                Icons.send,
                                size: 30.0,
                                color: kBlueLaserColor,
                              ),
                            ));
                      }
                      for (var mission in snapshot.data.documents) {
                        if (mission.data["email"] == currentUserEmail) {
                          missionInvitationSend = true;
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "📨",
                                style: TextStyle(fontSize: 30.0),
                              ));
                        }
                      }
                      missionInvitationSend = false;
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () async {
                              await MissionBrain().sendMissionInvitation(
                                  userEmail,
                                  Provider.of<MissionData>(context).reference,
                                  Provider.of<MissionData>(context)
                                      .textMission);
                              Scaffold.of(context).showSnackBar(missionRequest);
                            },
                            child: Icon(
                              Icons.send,
                              size: 30.0,
                              color: kBlueLaserColor,
                            ),
                          ));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
