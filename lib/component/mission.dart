import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/brain/progression_brain.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/add_step_screen.dart';
import 'package:Komeet/screens/main/completed_mission_public_screen.dart';
import 'package:Komeet/screens/main/congratulation_screen.dart';
import 'package:Komeet/screens/main/friend_profil_screen.dart';
import 'package:Komeet/screens/main/main_screen.dart';
import 'package:Komeet/screens/main/mission_chat_screen.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/screens/main/profil_screen.dart';
import 'package:Komeet/screens/main/send_invitation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Komeet/provider/MissionsData.dart' as MD;
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Firestore _fs = Firestore.instance;

class CurrentMission extends StatefulWidget {
  CurrentMission({
    @required this.data,
    @required this.reference,
    @required this.public,
    @required this.missionText,
  });
  final bool public;
  final String reference;
  final String missionText;
  final MediaQueryData data;

  @override
  _CurrentMissionState createState() => _CurrentMissionState();
}

class _CurrentMissionState extends State<CurrentMission>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  Animation<double> sizeAnimation;
  bool stepsCompleted = false;
  int actualStep = 0;
  int urgency = 0;
  QuerySnapshot stepsData;

  bool animated = false;
  bool isAnimated = true;

  Future loopAnimation() async {
    while (isAnimated = true) {
      await Future.delayed(Duration(milliseconds: 1500));
      print(animated);
      if (animated == false) {
        setState(() {
          animated = true;
        });
      } else {
        setState(() {
          animated = false;
        });
      }
    }
  }

  void getStepsData()async{
    stepsData = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(widget.public
        ? widget.missionText
        : widget.reference)
        .collection("Steps").getDocuments();
  }


  @override
  void initState() {
    getStepsData();
  super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1300), vsync: this);
    animation = Tween<double>(begin: 0, end: 60).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    sizeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        setState(() {});
      });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _pr = Provider.of<MD.MissionData>(context);
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: widget.public
              ? _fs
                  .collection("Missions")
                  .document(widget.reference)
                  .snapshots()
              : _fs
                  .collection("Users")
                  .document(currentUserEmail)
                  .collection("Missions")
                  .document(widget.reference)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.ease,
                  width: data.size.width,
                  height: data.size.height / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: animated ? Color(0xFFE1E1E1) : Colors.grey,
                  ),
                ),
              );
            }
            bool outDated;
            final String missionCategory = snapshot.data["missionCategory"];
            final Timestamp deadline = snapshot.data["missionDeadline"];
            final int missionDifficulty = snapshot.data["missionDifficulty"];
            final int usersSubscribed = snapshot.data["usersSubscribed"];
            final dynamic missionExp = snapshot.data["missionExp"];
            final String missionText = snapshot.data["missionText"];
            snapshot.data["outDated"] != null
                ? outDated = snapshot.data["outDated"]
                : outDated = false;
            int urgency = 0;
            if (deadline.toDate().difference(DateTime.now()).inSeconds <= 0) {
              urgency = 2;
              double result = missionExp / 2;
              !outDated
                  ? widget.public
                      ? _fs
                          .collection("Missions")
                          .document(widget.reference)
                          .updateData({
                          "outDated": true,
                          "missionExp": result,
                        })
                      : _fs
                          .collection("Users")
                          .document(currentUserEmail)
                          .collection("Missions")
                          .document(widget.reference)
                          .updateData({
                          "outDated": true,
                          "missionExp": result,
                        })
                  : print("isAlready outDated");
            } else if (deadline.toDate().difference(DateTime.now()).inHours <=
                24) {
              urgency = 1;
            }

            return Stack(
              children: <Widget>[
                Hero(
                  tag: missionText,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Dismissible(
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete"),
                                content: Text(
                                    "Do you really want to abort the mission ?"),
                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 28.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        MissionBrain().removeMission(
                                            widget.reference,
                                            widget.public,
                                            missionText);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 28.0),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (direction == DismissDirection.startToEnd) {
                          _pr.getPrivacyMission(widget.public);
                          _pr.getReference(widget.reference);
                          _pr.getTextMission(missionText);
                          _pr.getExp(missionExp.floor());
                          _pr.getCategoryMission(missionCategory);
                          _pr.getDeadline(deadline.toDate());
                          _pr.getDifficultyMission(missionDifficulty);
                          _pr.getIsCommunity(false);
                          Navigator.pushNamed(context, CongratulationScreen.id);
                        }
                      },
                      key: UniqueKey(),
                      background: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kBlueLaserColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Complete 🌝",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryBackground: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "Delete 😰",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
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
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          MissionBrain().missionCategoryIcon(
                                              missionCategory),
                                          size: 30.0,
                                          color: MissionBrain()
                                              .missionCategoryIconColor(
                                                  missionCategory),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: GestureDetector(
                                              onTap: () {
                                                MissionBrain()
                                                    .showMissionBubble(
                                                        context,
                                                        widget.reference,
                                                        missionText,
                                                        missionCategory,
                                                        false);
                                              },
                                              child: Text(
                                                missionText,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SimpleDialog(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          FlatButton(
                                                            onPressed:
                                                                () async {
                                                              print(
                                                                  "send invitation");
                                                              _pr.getReference(
                                                                  widget
                                                                      .reference);
                                                              _pr.getTextMission(
                                                                  missionText);
                                                              await Provider.of<
                                                                          ProfilBrainData>(
                                                                      context)
                                                                  .getListOfFriends(
                                                                      currentUserEmail);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      SendInvitationScreen
                                                                          .id);
                                                            },
                                                            child: Text(
                                                              "Send invitation",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              _pr.getTextMission(
                                                                  missionText);
                                                              _pr.stepsList
                                                                  .clear();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      AddStepScreen
                                                                          .id);
                                                            },
                                                            child: Text(
                                                              "Add step",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () {
                                                              MissionBrain().restartStep(
                                                                  missionText,
                                                                  widget
                                                                      .reference,
                                                                  widget
                                                                      .public);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Restart all steps",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("Close",
                                                            style: TextStyle(
                                                                color:
                                                                    kBlueLaserColor,
                                                                fontSize:
                                                                    18.0)),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.more_vert),
                                        )
                                      ],
                                    ),
                                  ),
                                  FutureBuilder(
                                    initialData: stepsData,
                                      future: _fs
                                          .collection("Users")
                                          .document(currentUserEmail)
                                          .collection("Missions")
                                          .document(widget.public
                                              ? missionText
                                              : widget.reference)
                                          .collection("Steps")
                                          .getDocuments(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              "Swipe to complete",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueGrey),
                                            ),
                                          );
                                        } else {
                                          List<MD.Step> stepsList = [];
                                          final steps = snapshot.data.documents;
                                          for (var step in steps) {
                                            if (step.data["actualIndex"] ==
                                                null) {
                                              stepsList.add(MD.Step(
                                                  index: step.data["stepIndex"],
                                                  text: step.data["stepName"]));
                                            } else {
                                              actualStep =
                                                  step.data["actualIndex"];
                                            }
                                          }
                                          return actualStep != stepsList.length
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        "$actualStep / ${stepsList.length}",
                                                        style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .blueGrey),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              stepsList[
                                                                      actualStep]
                                                                  .text,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .blueGrey),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            stepsCompleted =
                                                                true;
                                                          });
                                                          MissionBrain()
                                                              .completeStep(
                                                                  missionText,
                                                                  widget
                                                                      .reference,
                                                                  widget
                                                                      .public);
                                                          await Future.delayed(
                                                              Duration(
                                                                  milliseconds:
                                                                      500));
                                                          animationController
                                                              .forward();
                                                          setState(() {
                                                            stepsCompleted =
                                                                false;
                                                          });
                                                        },
                                                        icon: Icon(
                                                            Icons.check_box,
                                                            color: stepsCompleted
                                                                ? Colors
                                                                    .lightGreenAccent
                                                                : Colors.grey
                                                                    .shade400,
                                                            size: 30.0),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          "Swipe to complete",
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .blueGrey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                        }
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Visibility(
                                        visible: widget.public,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: _fs
                                                .collection("Missions")
                                                .document(widget.reference)
                                                .collection("Chat")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              bool newMessage = false;
                                              if (!snapshot.hasData) {
                                                return FlatButton(
                                                  onPressed: () {
                                                    _pr.getTextMission(
                                                        missionText);
                                                    _pr.getReference(
                                                        widget.reference);
                                                    _pr.getIsCommunity(widget
                                                            .reference.length >
                                                        8);
                                                    _pr.readAllMissionMessage(
                                                        widget.reference);
                                                    Navigator.pushNamed(context,
                                                        MissionChatScreen.id);
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.chat,
                                                        size: 20.0,
                                                        color: newMessage
                                                            ? Colors.pink
                                                            : kCTA,
                                                      ),
                                                      Text(
                                                        "Chat",
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: newMessage
                                                                ? Colors.pink
                                                                : kCTA),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              for (var message
                                                  in snapshot.data.documents) {
                                                if (message.data["email"] !=
                                                    currentUserEmail) {
                                                  if (message.data["read"] ==
                                                      false) {
                                                    newMessage = true;
                                                    _pr.getNewMissionMessage(
                                                        true);
                                                  }
                                                }
                                              }
                                              return FlatButton(
                                                onPressed: () {
                                                  _pr.getTextMission(
                                                      missionText);
                                                  _pr.getReference(
                                                      widget.reference);
                                                  _pr.getIsCommunity(
                                                      widget.reference.length >
                                                          8);
                                                  _pr.readAllMissionMessage(
                                                      widget.reference);
                                                  Navigator.pushNamed(context,
                                                      MissionChatScreen.id);
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.chat,
                                                      size: 20.0,
                                                      color: newMessage
                                                          ? Colors.pink
                                                          : kCTA,
                                                    ),
                                                    Text(
                                                      "Chat",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: newMessage
                                                              ? Colors.pink
                                                              : kCTA),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      Visibility(
                                        visible: widget.public,
                                        child: FlatButton(
                                          onPressed: () async {
                                            MissionBrain().showMissionBubble(
                                                context,
                                                widget.reference,
                                                missionText,
                                                missionCategory,
                                                false);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Row(
                                              children: <Widget>[
                                                StreamBuilder<QuerySnapshot>(
                                                    stream: _fs
                                                        .collection("Missions")
                                                        .document(
                                                            widget.reference)
                                                        .collection(
                                                            "Subscribers")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Text(
                                                          usersSubscribed
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        );
                                                      }
                                                      return Text(
                                                        snapshot.data.documents
                                                            .length
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      );
                                                    }),
                                                Text(
                                                  "Challengers",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 0.0),
                                        child: Row(
                                          children: <Widget>[
                                            Image(
                                              image: AssetImage(
                                                  "lib/images/power.png"),
                                              height: data.size.height / 30,
                                              width: data.size.height / 30,
                                            ),
                                            Text(
                                              missionExp.floor().toString(),
                                              style: TextStyle(
                                                  color: Color(0xFF22DFD4),
                                                  fontSize:
                                                      data.size.height / 35,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: sizeAnimation.value,
                                child: Container(
                                  width: 1000.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                      color: kBackgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Center(
                                    child: Text(
                                      "🎉 50 Exp 🎉 ",
                                      style: TextStyle(
                                          color: Color(0xFF22DFD4),
                                          fontSize: 34.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: urgency == 1
                          ? Colors.red
                          : urgency == 2 ? Colors.blueGrey : kBlueLaserColor,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: CountdownFormatted(
                          onFinish: () async {},
                          duration: deadline
                              .toDate()
                              .add(Duration(hours: 24))
                              .difference(DateTime.now()),
                          builder: (BuildContext ctx, String remaining) {
                            return Text(
                              urgency == 2 ? "Outdated" : remaining,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ); // 01:00:00
                          },
                        )),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class SearchedMission extends StatelessWidget {
  SearchedMission(
      {@required this.missionText,
      @required this.missionAdmin,
      @required this.missionCategory,
      @required this.deadline,
      @required this.missionExp,
      @required this.missionDifficulty,
      @required this.missionReference,
      @required this.isRequest,
      @required this.usersSubscribed});
  final String missionText;
  final String missionAdmin;
  final String missionCategory;
  final bool isRequest;
  final DateTime deadline;
  final int missionDifficulty;
  final double missionExp;
  final String missionReference;
  final int usersSubscribed;
  final addMission = SnackBar(
    backgroundColor: Color(0xFFE1E1E1),
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Mission Added ! 🔥",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kBackgroundColor,
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
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(MissionBrain().missionCategoryIcon(missionCategory),
                      size: 28.0,
                      color: MissionBrain()
                          .missionCategoryIconColor(missionCategory)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        MissionBrain().showMissionBubble(
                            context,
                            missionReference,
                            missionText,
                            missionCategory,
                            false);
                      },
                      child: Text(
                        missionText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                DateFormat('dd MMMM y').format(deadline),
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      if (isRequest == true) {
                        MissionBrain().rejectMissionRequest(missionReference);
                      }
                      MissionBrain().addMission(
                          missionText,
                          missionReference,
                          Provider.of<ProfilBrainData>(context).userName,
                          await ProfilBrainData()
                              .getProfilePicture(currentUserEmail));
                      Scaffold.of(context).showSnackBar(addMission);
                    },
                    child: Text(
                      "Add mission",
                      style: TextStyle(
                          fontSize: data.size.width / 20,
                          fontWeight: FontWeight.w700,
                          color: kCTA),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      MissionBrain().showMissionBubble(
                          context,
                          missionReference,
                          missionText,
                          missionCategory,
                          false);
                    },
                    child: Row(
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                            stream: _fs
                                .collection("Missions")
                                .document(missionReference)
                                .collection("Subscribers")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text(
                                  usersSubscribed.toString(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: data.size.width / 25,
                                      fontWeight: FontWeight.w500),
                                );
                              }
                              return Text(
                                snapshot.data.documents.length.toString(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: data.size.width / 25,
                                    fontWeight: FontWeight.w500),
                              );
                            }),
                        SizedBox(
                          width: data.size.width / 100,
                        ),
                        Text(
                          "Challengers",
                          style: TextStyle(
                              fontSize: data.size.width / 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: data.size.width / 50,
                  ),
                  Row(
                    children: <Widget>[
                      Image(
                        width: 20.0,
                        height: 20.0,
                        image: AssetImage("lib/images/power.png"),
                      ),
                      Text(
                        missionExp.floor().toString(),
                        style: TextStyle(
                            color: kBlueLaserColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MissionCompletedPost extends StatefulWidget {
  MissionCompletedPost(
      {@required this.missionText,
      @required this.missionCategory,
      @required this.userName,
      @required this.profilPicture,
      @required this.rank,
      @required this.userText,
      @required this.missionPicture,
      @required this.missionDifficulty,
      @required this.missionExp,
      @required this.missionDeadline,
      @required this.userEmail,
      @required this.missionReference});
  final String missionText;
  final String missionCategory;
  final int missionDifficulty;
  final int missionExp;
  final String missionPicture;
  final DateTime missionDeadline;
  final String profilPicture;
  final String rank;
  final String userName;
  final String userEmail;
  final String userText;
  final String missionReference;

  @override
  _MissionCompletedPostState createState() => _MissionCompletedPostState();
}

class _MissionCompletedPostState extends State<MissionCompletedPost>
    with SingleTickerProviderStateMixin {
  final addMission = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Mission Added ! 🔥",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );
  AnimationController animationController;
  Animation<double> animation;
  Animation<double> sizeAnimation;
  int currentState = 0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    animation = Tween<double>(begin: 0, end: 60).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    sizeAnimation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        setState(() {});
      });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 7.0,
                  offset: Offset(3, 3),
                )
              ],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context, listen: false)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(widget.userName));
                    Provider.of<ProfilBrainData>(context, listen: false).getBadgeList(
                        await ProfilBrainData().getEmail(widget.userName));
                    await Provider.of<ProfilBrainData>(context, listen: false)
                        .isAlreadyFriend(widget.userName);
                    if (widget.userEmail == currentUserEmail) {
                      Navigator.pushNamed(context, ProfilScreen.id);
                    } else {
                      Navigator.pushNamed(context, FriendProfilScreen.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 22.0, bottom: 12.0),
                    child: Row(
                      children: <Widget>[
                        widget.profilPicture != null
                            ? CircleAvatar(
                                minRadius: 10.0,
                                maxRadius: 20.0,
                                backgroundColor: Color(0xFFE1E8E7),
                                backgroundImage:
                                    NetworkImage(widget.profilPicture),
                              )
                            : StreamBuilder<DocumentSnapshot>(
                                stream: _fs
                                    .collection("Users")
                                    .document(widget.userEmail)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Avatar(
                                        clotheColor: 1,
                                        bodyType: "female",
                                        bodyColor: 3,
                                        hairColor: 1,
                                        hairStyle: 5,
                                        background: 3);
                                  }
                                  var avatar = snapshot.data["Avatar"];
                                  return Container(
                                    height: 50.0,
                                    width: 50.0,
                                    child: Avatar(
                                        clotheColor: avatar["clotheColor"],
                                        bodyType: avatar["avatarType"],
                                        bodyColor: avatar["bodyColor"],
                                        hairColor: avatar["hairColor"],
                                        hairStyle: avatar["hairStyle"],
                                        background: avatar["backgroundColor"]),
                                  );
                                }),
                        SizedBox(width: data.size.width / 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black),
                            ),
                            Text(
                              "level ${widget.rank}",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Level()
                                      .levelColor(int.parse(widget.rank))),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                widget.missionPicture != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            animationController.forward();
                            await MissionBrain().likeCompletedMission(
                                widget.missionText, widget.userName);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  width: double.infinity,
                                  image: NetworkImage(widget.missionPicture),
                                ),
                              ),
                              Transform.scale(
                                scale: sizeAnimation.value,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 0.0),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            animationController.forward();
                            await MissionBrain().likeCompletedMission(
                                widget.missionText, widget.userName);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: data.size.height / 4,
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Icon(
                                  MissionBrain().missionCategoryIcon(
                                      widget.missionCategory),
                                  color: MissionBrain()
                                      .missionCategoryIconColor(
                                          widget.missionCategory),
                                  size: 155.0,
                                ),
                              ),
                              Transform.scale(
                                scale: sizeAnimation.value,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.missionText,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.userText != null ? widget.userText : "",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          MissionBrain().addMission(
                              widget.missionText,
                              widget.missionReference,
                              await ProfilBrainData()
                                  .getUserName(currentUserEmail),
                              await ProfilBrainData()
                                  .getProfilePicture(currentUserEmail));
                          Scaffold.of(context).showSnackBar(addMission);
                        },
                        child: Text(
                          "Add Mission",
                          style: TextStyle(
                              fontSize: data.size.width / 20,
                              fontWeight: FontWeight.w700,
                              color: kCTA),
                        ),
                      ),
                      FlatButton(
                          onPressed: () async {
                            Provider.of<ProfilBrainData>(context, listen: false)
                                .getEmail(widget.userName);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CompletedMissionScreen(
                                    userEmail: widget.userEmail,
                                    rank: widget.rank,
                                    profilPicture: widget.profilPicture,
                                    missionDifficulty: widget.missionDifficulty,
                                    missionPicture: widget.missionPicture,
                                    missionReference: widget.missionReference,
                                    missionExp: widget.missionExp,
                                    missionDeadline: widget.missionDeadline,
                                    missionCategory: widget.missionCategory,
                                    missionText: widget.missionText,
                                    userName: widget.userName,
                                    userText: widget.userText,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Comment",
                            style: TextStyle(
                                fontSize: data.size.width / 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: _fs
                              .collection("Users")
                              .document(widget.userEmail)
                              .collection("MissionsCompleted")
                              .document(widget.missionText)
                              .collection("Like")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () async {
                                        await MissionBrain()
                                            .likeCompletedMission(
                                                widget.missionText,
                                                widget.userName);
                                      },
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Colors.blueGrey,
                                        size: 30.0,
                                      ),
                                    ),
                                    Text(
                                      "0 ",
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              );
                            }
                            for (var user in snapshot.data.documents) {
                              if (user.data["email"] == currentUserEmail) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () async {
                                          await MissionBrain()
                                              .likeCompletedMission(
                                                  widget.missionText,
                                                  widget.userName);
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 30.0,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          MissionBrain().showMissionLike(
                                            context,
                                            widget.userEmail,
                                            widget.missionText,
                                          );
                                        },
                                        child: Text(
                                          snapshot.data.documents.length
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () async {
                                      await MissionBrain().likeCompletedMission(
                                          widget.missionText, widget.userName);
                                    },
                                    icon: Icon(
                                      Icons.favorite_border,
                                      color: Colors.blueGrey,
                                      size: 30.0,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      MissionBrain().showMissionLike(
                                        context,
                                        widget.userEmail,
                                        widget.missionText,
                                      );
                                    },
                                    child: Text(
                                      snapshot.data.documents.length.toString(),
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.blue,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  "Finished",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MissionFeedCurrent extends StatelessWidget {
  MissionFeedCurrent({
    @required this.userText,
    @required this.date,
    @required this.missionReference,
    @required this.missionDeadline,
    @required this.missionExp,
    @required this.missionDifficulty,
    @required this.userRank,
    @required this.profilPicture,
    @required this.userName,
    @required this.missionCategory,
    @required this.missionText,
  });
  final String missionReference;
  final String missionText;
  final String missionCategory;
  final String userText;
  final String profilPicture;
  final String userName;
  final int userRank;
  final int missionDifficulty;
  final int missionExp;
  final DateTime missionDeadline;
  final int date;

  final addMission = SnackBar(
    backgroundColor: Colors.white,
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Mission Added ! 🔥",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundColor,
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
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    Provider.of<ProfilBrainData>(context)
                        .getMissionsCompletedList(
                            await Provider.of<ProfilBrainData>(context)
                                .getEmail(userName));
                    await Provider.of<ProfilBrainData>(context)
                        .isAlreadyFriend(userName);
                    Provider.of<ProfilBrainData>(context).getBadgeList(
                        await ProfilBrainData().getEmail(userName));
                    if (await ProfilBrainData().getEmail(userName) ==
                        currentUserEmail) {
                      Navigator.pushNamed(context, ProfilScreen.id);
                    } else {
                      Navigator.pushNamed(context, FriendProfilScreen.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 22.0, bottom: 12.0),
                    child: Row(
                      children: <Widget>[
                        profilPicture != null
                            ? CircleAvatar(
                                minRadius: 10.0,
                                maxRadius: 20.0,
                                backgroundColor: Color(0xFFE1E8E7),
                                backgroundImage: NetworkImage(profilPicture),
                              )
                            : StreamBuilder<QuerySnapshot>(
                                stream: _fs.collection("Users").snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Avatar(
                                        clotheColor: 1,
                                        bodyType: "male",
                                        bodyColor: 1,
                                        hairColor: 2,
                                        hairStyle: 4,
                                        background: 1);
                                  }
                                  for (var user in snapshot.data.documents) {
                                    if (user.data["userName"] == userName) {
                                      var avatar = user.data["Avatar"];
                                      return Container(
                                        width: 50.0,
                                        height: 50.0,
                                        child: Avatar(
                                            clotheColor: avatar["clotheColor"],
                                            bodyType: avatar["avatarType"],
                                            bodyColor: avatar["bodyColor"],
                                            hairColor: avatar["hairColor"],
                                            hairStyle: avatar["hairStyle"],
                                            background:
                                                avatar["backgroundColor"]),
                                      );
                                    }
                                  }
                                  return Avatar(
                                      clotheColor: 1,
                                      bodyType: "male",
                                      bodyColor: 1,
                                      hairColor: 2,
                                      hairStyle: 4,
                                      background: 1);
                                }),
                        SizedBox(width: data.size.width / 80),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black),
                            ),
                            Text(
                              "level $userRank",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Level().levelColor(userRank)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: data.size.height / 4,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Icon(
                    MissionBrain().missionCategoryIcon(missionCategory),
                    color: MissionBrain()
                        .missionCategoryIconColor(missionCategory),
                    size: 155.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        missionText,
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        MissionBrain().addMission(
                            missionText,
                            missionReference,
                            await ProfilBrainData()
                                .getUserName(currentUserEmail),
                            await ProfilBrainData()
                                .getProfilePicture(currentUserEmail));
                        Scaffold.of(context).showSnackBar(addMission);
                      },
                      child: Text(
                        "Add Mission",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: kCTA),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: userText == "New mission created !"
                    ? Colors.lightGreen
                    : Colors.amber,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Text(
                  userText == "New mission created !" ? "New" : "Joined",
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MissionCompletedGridItem extends StatelessWidget {
  MissionCompletedGridItem(
      {@required this.missionText,
      @required this.missionCategory,
      @required this.userName,
      @required this.profilPicture,
      @required this.rank,
      @required this.userText,
      @required this.missionPicture,
      @required this.missionDifficulty,
      @required this.missionExp,
      @required this.missionDeadline,
      @required this.missionReference});
  final String missionText;
  final String missionCategory;
  final int missionDifficulty;
  final int missionExp;
  final String missionPicture;
  final DateTime missionDeadline;
  final String profilPicture;
  final String rank;
  final String userName;
  final String userText;
  final String missionReference;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Provider.of<ProfilBrainData>(context, listen: false).getEmail(userName);
        await Provider.of<ProfilBrainData>(context, listen: false).isAlreadyFriend(userName);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CompletedMissionScreen(
                userEmail: Provider.of<ProfilBrainData>(context).email,
                rank: rank,
                profilPicture: profilPicture,
                missionDifficulty: missionDifficulty,
                missionPicture: missionPicture,
                missionReference: missionReference,
                missionExp: missionExp,
                missionDeadline: missionDeadline,
                missionCategory: missionCategory,
                missionText: missionText,
                userName: userName,
                userText: userText,
              );
            },
          ),
        );
      },
      child: missionPicture == null
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey,
                          blurRadius: 10.0,
                          offset: Offset(3, 3),
                        ),
                        BoxShadow(
                          color: Color(0XFFFFFFFF),
                          blurRadius: 10.0,
                          offset: Offset(-3, -3),
                        )
                      ]),
                  child: Icon(
                    MissionBrain().missionCategoryIcon(missionCategory),
                    color: MissionBrain()
                        .missionCategoryIconColor(missionCategory),
                    size: 50.0,
                  )),
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFE1E1E1),
                    borderRadius: BorderRadius.circular(10.0),
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
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    image: NetworkImage(missionPicture),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
    );
  }
}

class CommunityMission extends StatefulWidget {
  CommunityMission({
    @required this.missionTitle,
    @required this.missionSubTitle,
    @required this.nbOfSubscribers,
    @required this.rewardLink,
    @required this.exp,
    @required this.missionDeadline,
    @required this.missionCategory,
    @required this.missionReference,
    @required this.missionDifficulty,
  });
  final String missionTitle;
  final String missionSubTitle;
  final int nbOfSubscribers;
  final String rewardLink;
  final int exp;
  final Timestamp missionDeadline;
  final String missionReference;
  final String missionCategory;
  final int missionDifficulty;

  @override
  _CommunityMissionState createState() => _CommunityMissionState();
}

class _CommunityMissionState extends State<CommunityMission> {
  final addMission = SnackBar(
    backgroundColor: Color(0xFFE1E1E1),
    content: Container(
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Text(
        "Mission Added ! 🔥",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
      ),
    ),
  );
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['comfort zone', 'adventure'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );
  bool _loaded = false;
  @override
  void initState() {
    RewardedVideoAd.instance
        .load(
            adUnitId: 'ca-app-pub-1019750920692164/2001475403',
            // adUnitId: 'ca-app-pub-1019750920692164/8452662675', TODO  ios
            targetingInfo: targetingInfo)
        .catchError((e) => print("error in loading 1st time"))
        .then((v) => setState(() => _loaded = v));
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        MissionBrain()
            .addCommunityMission(widget.missionReference, widget.missionTitle);
        Scaffold.of(context).showSnackBar(addMission);
        Navigator.pushNamed(context, MainScreen.id);
        RewardedVideoAd.instance
            .load(
                adUnitId: 'ca-app-pub-1019750920692164/2001475403',
                // adUnitId: 'ca-app-pub-1019750920692164/8452662675', TODO  ios
                targetingInfo: targetingInfo)
            .catchError((e) => print("error in loading 1st time"))
            .then((v) => setState(() => _loaded = v));
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                  ]),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            height: 140.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFF5B62FF),
                                      Color(0xFF000000)
                                    ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 10.0,
                                      offset: Offset(0, 0),
                                      spreadRadius: -7),
                                  BoxShadow(
                                      color: Color(0XFFFFFFFF),
                                      blurRadius: 7.0,
                                      offset: Offset(-0, -0),
                                      spreadRadius: -7)
                                ]),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: data.size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.missionTitle,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    widget.missionSubTitle,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 18.0,
                        child: GestureDetector(
                          onTap: () {
                            MissionBrain().showMissionBubble(
                                context,
                                widget.missionReference,
                                widget.missionTitle,
                                widget.missionCategory,
                                true);
                          },
                          child: Row(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                  stream: _fs
                                      .collection("CommunityMissions")
                                      .document(widget.missionReference)
                                      .collection("Subscribers")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text(
                                        widget.nbOfSubscribers.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      );
                                    }
                                    return Text(
                                      snapshot.data.documents.length.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    );
                                  }),
                              Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 35.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30.0,
                        right: 20.0,
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.50),
                                blurRadius: 15.0,
                                offset: Offset.fromDirection(-5, 5),
                              )
                            ],
                          ),
                          child: Image(
                            image: NetworkImage(widget.rewardLink),
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            if (await ProfilBrainData()
                                    .checkPremiumStatus(currentUserEmail) ==
                                true) {
                              Scaffold.of(context).showSnackBar(addMission);
                              MissionBrain().addCommunityMission(
                                  widget.missionReference, widget.missionTitle);
                            } else {
                              RewardedVideoAd.instance.show();
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Add mission",
                                style: TextStyle(
                                    fontSize: data.size.width / 18,
                                    fontWeight: FontWeight.w700,
                                    color: kCTA),
                              ),
                              Container(
                                  width: 50.0,
                                  child: Image(
                                      image: AssetImage("lib/images/ad.png")))
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              widget.exp.toString(),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: kBlueLaserColor),
                            ),
                            Image(
                              image: AssetImage("lib/images/power.png"),
                              width: 25.0,
                              height: 25.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: kBlueLaserColor,
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: CountdownFormatted(
                    onFinish: () async {},
                    duration: widget.missionDeadline
                        .toDate()
                        .difference(DateTime.now()),
                    builder: (BuildContext ctx, String remaining) {
                      return Text(
                        remaining,
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ); // 01:00:00
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityMissionAccepted extends StatelessWidget {
  CommunityMissionAccepted({
    @required this.missionReference,
  });
  final String missionReference;

  @override
  Widget build(BuildContext context) {
    var _pr = Provider.of<MD.MissionData>(context);
    final data = MediaQuery.of(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: _fs
            .collection("CommunityMissions")
            .document(missionReference)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kBlueLaserColor,
              ),
            );
          }
          final String missionTitle = snapshot.data["missionTitle"];
          final String missionSubTitle = snapshot.data["missionSubtitle"];
          final String rewardLink = snapshot.data["missionReward"];
          final int exp = snapshot.data["missionExp"];
          final Timestamp deadline = snapshot.data["missionDeadline"];
          final String missionCategory = snapshot.data["missionCategory"];
          final int missionDifficulty = snapshot.data["missionDifficulty"];
          DateTime missionDeadline = deadline.toDate();
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      MissionBrain()
                          .removeMission(missionReference, true, missionTitle);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete"),
                            content: Text("oh no"),
                          );
                        },
                      );
                    } else if (direction == DismissDirection.startToEnd) {
                      _pr.getPrivacyMission(true);
                      _pr.getReference(missionReference);
                      _pr.getTextMission(missionTitle);
                      _pr.getExp(exp);
                      _pr.getCategoryMission(missionCategory);
                      _pr.getDeadline(deadline.toDate());
                      _pr.getDifficultyMission(missionDifficulty);
                      Navigator.pushNamed(context, CongratulationScreen.id);
                    }
                  },
                  key: UniqueKey(),
                  background: Container(
                    decoration: BoxDecoration(
                      color: kBlueLaserColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "complete 🌝",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "Delete 😰",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: data.size.width / 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        missionTitle,
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        missionSubTitle,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(
                                        height: data.size.height / 40,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                Container(
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 10.0,
                                        offset: Offset.fromDirection(-5, 5),
                                      )
                                    ],
                                  ),
                                  child: Image(
                                    image: NetworkImage(rewardLink),
                                    width: 100.0,
                                    height: 100.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _pr.getTextMission(missionTitle);
                                    _pr.getReference(missionReference);
                                    _pr.getIsCommunity(
                                        missionReference.length > 8);
                                    Navigator.pushNamed(
                                        context, MissionChatScreen.id);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.chat,
                                        size: 25.0,
                                        color: kCTA,
                                      ),
                                      Text("Chat",
                                          style: TextStyle(
                                              fontSize: data.size.width / 18,
                                              fontWeight: FontWeight.w700,
                                              color: kCTA))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    MissionBrain().showMissionBubble(
                                        context,
                                        missionReference,
                                        missionTitle,
                                        missionCategory,
                                        true);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      StreamBuilder<QuerySnapshot>(
                                          stream: _fs
                                              .collection("CommunityMissions")
                                              .document(missionReference)
                                              .collection("Subscribers")
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 2.0),
                                                child: Text(
                                                  "",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black54),
                                                ),
                                              );
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 2.0),
                                              child: Text(
                                                snapshot.data.documents.length
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20.0,
                                                    color: Colors.black54),
                                              ),
                                            );
                                          }),
                                      Text("Challengers",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: data.size.width / 20,
                                              color: Colors.black54))
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage("lib/images/power.png"),
                                      width: 35.0,
                                      height: 35.0,
                                    ),
                                    Text(
                                      exp.toString(),
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF22DFD4)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: kBlueLaserColor,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: CountdownFormatted(
                        onFinish: () async {},
                        duration: missionDeadline.difference(DateTime.now()),
                        builder: (BuildContext ctx, String remaining) {
                          return Text(
                            remaining,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ); // 01:00:00
                        },
                      )),
                ),
              ),
            ],
          );
        });
  }
}
