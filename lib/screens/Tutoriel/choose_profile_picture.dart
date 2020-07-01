import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Tutoriel/complete_profil_screen.dart';
import 'package:Komeet/screens/Tutoriel/create_avatar_screen.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _fs = Firestore.instance;

class ChooseProfilPicture extends StatefulWidget {
  static String id = "choose_profile_picture";
  @override
  _ChooseProfilPictureState createState() => _ChooseProfilPictureState();
}

class _ChooseProfilPictureState extends State<ChooseProfilPicture> {
  @override
  int step = 1;
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<ProfilBrainData>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
          stream:
              _fs.collection("Users").document(currentUserEmail).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Icon(
                  Icons.signal_wifi_off,
                  color: Colors.grey.shade400,
                  size: 120.0,
                ),
              );
            }
            String profilPicture = snapshot.data["profilPicture"];
            Map avatar = snapshot.data["Avatar"];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: data.size.height / 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Choose your Avatar",
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.shade300,
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
                        CircleAvatar(
                          child: _pr.isLoadingImage == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : profilPicture != null
                                  ? Container()
                                  : avatar["avatarType"] != null
                                      ? Avatar(
                                          clotheColor: avatar["clotheColor"],
                                          bodyType: avatar["avatarType"],
                                          bodyColor: avatar["bodyColor"],
                                          hairColor: avatar["hairColor"],
                                          hairStyle: avatar["hairStyle"],
                                          background: avatar["backgroundColor"])
                                      : Icon(
                                          Icons.add_a_photo,
                                          size: 100.0,
                                          color: Colors.grey.shade400,
                                        ),
                          backgroundColor: kBackgroundColor,
                          backgroundImage: profilPicture != null
                              ? NetworkImage(profilPicture)
                              : NetworkImage(""),
                          maxRadius: 100.0,
                          minRadius: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.blueAccent,
                      onPressed: () async {
                        _pr.getImage("mySelf");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Import picture 📸",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                    child: Text(
                  "Or",
                  style: TextStyle(fontSize: 18.0),
                )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.lightBlueAccent,
                      onPressed: () async {
                        await _pr.getUserRank(currentUserEmail);
                        Navigator.pushNamed(context, CreateAvatarScreen.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Create Avatar 🙍‍♂️",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        if (profilPicture != null ||
                            avatar["avatarType"] != null) {
                          setState(() {
                            step = 2;
                          });
                          await Future.delayed(Duration(milliseconds: 1500));
                          Navigator.pushNamed(context, CompleteScreen.id);
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Please add a picture or create Avatar 🙏",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                      "It's nicer to have a face on this app"),
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
                      color: profilPicture != null || avatar != {}
                          ? Colors.blueAccent
                          : Colors.grey,
                      disabledColor: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontSize: 22.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: data.size.height / 50,
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
                        width: step == 2
                            ? (data.size.width / 6) * 2
                            : data.size.width / 6,
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
            );
          }),
    );
  }
}
