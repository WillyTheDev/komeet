import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_screen.dart';

final Firestore _fs = Firestore.instance;

class CreateCommunityMission extends StatefulWidget {
  static String id = "create_community_mission";
  @override
  _CreateCommunityMissionState createState() => _CreateCommunityMissionState();
}

class _CreateCommunityMissionState extends State<CreateCommunityMission>
    with SingleTickerProviderStateMixin {
  int difficulty = 1;
  int days = 0;
  bool public = true;
  int power = 0;
  AnimationController controller;
  Animation animation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
      lowerBound: 0.18,
      upperBound: 0.22,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 0.75);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });
  }

  static DateTime _selectedDate = DateTime.now();
  String formattedDateTime = DateFormat('dd MMMM y').format(_selectedDate);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final _pr = Provider.of<MissionData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("New mission", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      //backgroundColor: Color(0xFFE1E8E7),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 1,
            child: Container(
              color: Color(0xFFE1E8E7),
            ),
          ),
          SafeArea(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _pr.getCommunityTitle(value);
                        },
                        minLines: 1,
                        maxLines: 3,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter something";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Mission Title",
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _pr.getCommunityDescription(value);
                        },
                        minLines: 1,
                        maxLines: 3,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter something";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Description",
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _pr.getCommunityBadgeLink(value);
                        },
                        minLines: 1,
                        maxLines: 3,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter something";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Reward link",
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _pr.getCommunityExp(int.parse(value));
                        },
                        minLines: 1,
                        maxLines: 3,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Please Enter something";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Mission Exp",
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4.0),
                      child: Container(
                          height: data.size.height / 7,
                          width: data.size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 15.0,
                                offset: Offset.fromDirection(-20, 0),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Choose a Category",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, CategoryScreen.id);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          _pr.categoryIcon,
                                          size: 50.0,
                                          color: _pr.categoryIconColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _pr.categoryTitle,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              _pr.categorySubtitle,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Container(
                        height: data.size.height / 6,
                        width: data.size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 15.0,
                              offset: Offset.fromDirection(-20, 0),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text("Difficulty",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600)),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    inactiveTrackColor: Colors.grey,
                                    activeTrackColor: Colors.blue,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 10.0),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 15.0),
                                    thumbColor: Colors.blue,
                                    overlayColor: Colors.blue[900]),
                                child: Slider(
                                  value: difficulty.toDouble(),
                                  min: 1,
                                  max: 3,
                                  onChanged: (double value) {
                                    setState(() {
                                      difficulty = value.round();
                                      _pr.getDifficultyMission(value.round());
                                    });
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "easy",
                                    style: difficulty == 1
                                        ? TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600)
                                        : TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "medium",
                                    style: difficulty == 2
                                        ? TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600)
                                        : TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Hard",
                                    style: difficulty == 3
                                        ? TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600)
                                        : TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  elevation: 5.0,
                                  title: Center(
                                    child: Text(
                                      "Select the Deadline",
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(8.0),
                                  backgroundColor: Color(0xFFE1E8E7),
                                  content: Container(
                                      height: data.size.height / 2,
                                      width: data.size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: CalendarCarousel(
                                        onDayPressed:
                                            (DateTime value, List event) {
                                          Navigator.pop(context);
                                          print("Day pressed");
                                          print("before $_selectedDate");
                                          _pr.getCommunityDeadline(value);
                                          setState(() {
                                            formattedDateTime =
                                                DateFormat('dd MMMM y')
                                                    .format(value);
                                            _selectedDate = value;
                                            print("after $_selectedDate");
                                          });
                                        },
                                        todayButtonColor: Colors.grey,
                                        selectedDateTime: _selectedDate,
                                        selectedDayButtonColor:
                                            Colors.lightBlueAccent,
                                      )),
                                );
                              });
                        },
                        child: Container(
                            height: data.size.height / 8,
                            width: data.size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 15.0,
                                  offset: Offset.fromDirection(-20, 0),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Deadline",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.calendar_today,
                                          size: 35.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "$formattedDateTime",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5.0,
                      onPressed: () {
                        MissionBrain().addCommunityMissionToDatabase(
                            _pr.communityTitle,
                            _pr.communityDescription,
                            _pr.badgeLink,
                            _pr.communityExp,
                            _pr.communityDeadline,
                            _pr.difficulty,
                            _pr.categoryTitle);
                        Navigator.pop(context);
                      },
                      color: Colors.lightBlueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Add this Mission",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: animation.value * 100),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: data.size.height / 10,
                    ),
                    FlatButton(
                      onPressed: () async {
                        var stepDocuments =
                            await _fs.collection("Missions").getDocuments();
                        for (var document in stepDocuments.documents) {
                          document.reference.delete();
                        }
                      },
                      color: Colors.blueGrey,
                      child: Text("Clean Missions Data"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
