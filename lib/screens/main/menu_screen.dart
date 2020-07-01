import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/main/get_premium_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Komeet/flare/Astronaut.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Firestore _fs = Firestore.instance;

class MenuScreen extends StatefulWidget {
  static String id = "menu_screen";
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool showPatchNote = false;

  @override
  Widget build(BuildContext context) {
    print("MENU SCreen Loaded");
    final data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFE1E1E1),
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                decoration: kgradientBackground,
              ),
              planet(),
              Positioned(
                  top: data.size.height / 12,
                  left: data.size.width / 20,
                  child: Container(
                    width: data.size.width / 8,
                    height: data.size.width / 8,
                    child: Stack(
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return InformationDialog();
                                });
                          },
                          elevation: 6.0,
                          child: Image(
                            image: AssetImage("lib/images/head.png"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 20.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightBlueAccent),
                            child: Icon(
                              Icons.priority_high,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  top: data.size.height / 6,
                  left: data.size.width / 20,
                  child: Container(
                    width: data.size.width / 8,
                    height: data.size.width / 8,
                    child: Stack(
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(context, GetPremiumScreen.id);
                          },
                          elevation: 6.0,
                          child: Image(
                            image: AssetImage("lib/images/premium.png"),
                          ),
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 90.0, right: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: data.size.width / 2.3,
                        height: data.size.height / 7,
                        decoration: BoxDecoration(
                            gradient: hangarGradient,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87,
                                blurRadius: 7.0,
                                offset: Offset(5, 5),
                              ),
                            ]),
                        child: InkWell(
                          onTap: () {

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  "HANGAR",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22.0),
                                ),
                                Container(
                                  width: 60.0,
                                  child: Image(
                                    image:
                                        AssetImage("lib/images/space-ship.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class InformationDialog extends StatefulWidget {
  @override
  _InformationDialogState createState() => _InformationDialogState();
}

class _InformationDialogState extends State<InformationDialog> {
  bool showPatchNote = false;
  bool showSurvey = true;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text("Informations"),
      content: StreamBuilder<DocumentSnapshot>(
          stream:
              _fs.collection("AdminMessage").document("message").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Nothing to show");
            }
            Map surveyResult = snapshot.data["surveyResult"];
            String version = snapshot.data["version"];
            String surveyQuestion = snapshot.data["survey"];
            List news = snapshot.data["news"];
            List corrections = snapshot.data["correction"];
            List surveyUsers = snapshot.data["surveyUsers"];
            return Container(
              width: data.size.width / 1,
              height: data.size.height / 1,
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        !showPatchNote
                            ? showPatchNote = true
                            : showPatchNote = false;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Patch Notes",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            print("show patch note = $showPatchNote");
                            setState(() {
                              !showPatchNote
                                  ? showPatchNote = true
                                  : showPatchNote = false;
                            });
                          },
                          icon: Icon(
                            showPatchNote == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            size: 35.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showPatchNote,
                    child: Text(
                      "Version : $version",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black54),
                    ),
                  ),
                  Visibility(
                    visible: showPatchNote,
                    child: Text(
                      "New  Features",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: kCTA),
                    ),
                  ),
                  Visibility(
                    visible: showPatchNote,
                    child: Container(
                      height: data.size.height / 2.5,
                      child: ListView.builder(
                          itemCount: news.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${news[index]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Visibility(
                    visible: showPatchNote,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Corrections",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                            color: Colors.redAccent),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showPatchNote,
                    child: Container(
                      height: data.size.height / 2.5,
                      child: ListView.builder(
                          itemCount: corrections.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${corrections[index]}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        !showSurvey ? showSurvey = true : showSurvey = false;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Survey of The day",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            print("show patch note = $showSurvey");
                            setState(() {
                              !showSurvey
                                  ? showSurvey = true
                                  : showSurvey = false;
                            });
                          },
                          icon: Icon(
                            showSurvey == false
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            size: 35.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showSurvey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 22.0),
                          child: Text(
                            surveyQuestion,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  surveyResult = {
                                    "choice1": surveyResult["choice1"] + 1,
                                    "choice2": surveyResult["choice2"],
                                  };
                                  surveyUsers.add(
                                      Provider.of<ProfilBrainData>(context)
                                          .userName);
                                  _fs
                                      .collection("AdminMessage")
                                      .document("message")
                                      .updateData({
                                    "surveyResult": surveyResult,
                                    "surveyUsers": surveyUsers,
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  width: !surveyUsers.contains(
                                          Provider.of<ProfilBrainData>(context)
                                              .userName)
                                      ? data.size.width / 3
                                      : ((data.size.width / 1.5) /
                                          ((surveyResult["choice2"] +
                                                  surveyResult["choice1"]) /
                                              surveyResult["choice1"])),
                                  height: data.size.height / 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      !surveyUsers.contains(
                                              Provider.of<ProfilBrainData>(
                                                      context)
                                                  .userName)
                                          ? "YES"
                                          : surveyResult["choice1"].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 28.0),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  surveyResult = {
                                    "choice1": surveyResult["choice1"],
                                    "choice2": surveyResult["choice2"] + 1,
                                  };
                                  surveyUsers.add(
                                      Provider.of<ProfilBrainData>(context)
                                          .userName);
                                  _fs
                                      .collection("AdminMessage")
                                      .document("message")
                                      .updateData({
                                    "surveyResult": surveyResult,
                                    "surveyUsers": surveyUsers,
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  width: !surveyUsers.contains(
                                          Provider.of<ProfilBrainData>(context)
                                              .userName)
                                      ? data.size.width / 3
                                      : ((data.size.width / 1.5) /
                                          ((surveyResult["choice2"] +
                                                  surveyResult["choice1"]) /
                                              surveyResult["choice2"])),
                                  height: data.size.height / 10,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      !surveyUsers.contains(
                                              Provider.of<ProfilBrainData>(
                                                      context)
                                                  .userName)
                                          ? "NO"
                                          : surveyResult["choice2"].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 28.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Exit",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.black54),
          ),
        )
      ],
    );
  }
}
