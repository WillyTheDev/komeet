import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Tutoriel/tutorial_mission_screen.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/main_screen.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_screen.dart';

class CreateGoals extends StatefulWidget {
  static String id = "create_goals";
  @override
  _CreateGoalsState createState() => _CreateGoalsState();
}

class _CreateGoalsState extends State<CreateGoals>
    with SingleTickerProviderStateMixin {
  int difficulty = 1;
  int days = 0;
  bool public = true;
  int power = 0;
  AnimationController controller;
  Animation animation;
  bool isExpanded = false;
  final TextEditingController textController = TextEditingController();
  final _stepKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

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

  static DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
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
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        title: Text("New mission", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kBackgroundColor,
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
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {
                            _pr.getTextMission(value);
                          },
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
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Title ex: Eat more vegetable 🥕",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            horizontal: 8.0, vertical: 4.0),
                        child: Container(
                          height: isExpanded
                              ? data.size.height / 2
                              : data.size.height / 7,
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Add Steps",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "Any steps can be added further",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16.0, right: 16.0),
                                      child: IconButton(
                                        onPressed: () {
                                          isExpanded
                                              ? isExpanded = false
                                              : isExpanded = true;
                                        },
                                        icon: Icon(
                                          isExpanded
                                              ? Icons.remove_circle
                                              : Icons.add_circle,
                                          color: Colors.lightBlueAccent,
                                          size: 40.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Visibility(
                                  visible: isExpanded,
                                  child: Expanded(
                                      child: ListView.builder(
                                    itemCount: _pr.stepsList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            "${_pr.stepsList[index].index}."),
                                        subtitle: Text(
                                          _pr.stepsList[index].text,
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                            size: 25.0,
                                          ),
                                          onPressed: () {
                                            _pr.removeStep(index);
                                          },
                                        ),
                                      );
                                    },
                                  )),
                                ),
                                Visibility(
                                    visible: isExpanded,
                                    child: Form(
                                      key: _stepKey,
                                      child: TextFormField(
                                        controller: textController,
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "Please Enter something";
                                          }
                                          return null;
                                        },
                                        onChanged: (String value) {
                                          _pr.getStepText(value);
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor:
                                              Colors.grey.withOpacity(0.20),
                                          hintText: "Write steps Here",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              if (_stepKey.currentState
                                                  .validate()) {
                                                print(_pr.stepText);
                                                _pr.addStep();
                                                textController.clear();
                                              }
                                            },
                                            icon: Icon(
                                              Icons.add_circle,
                                              size: 30.0,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
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
                                        _pr.getExpValue();
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5.0,
                                fillColor: public
                                    ? Colors.lightBlueAccent
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Public",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: public
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    public = true;
                                    _pr.getPrivacyMission(true);
                                    _pr.getExpValue();
                                    print(_pr.privacy);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: data.size.width / 80,
                            ),
                            Expanded(
                              child: RawMaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5.0,
                                fillColor: public
                                    ? Colors.white
                                    : Colors.lightBlueAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Private",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: public
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    public = false;
                                    _pr.getPrivacyMission(false);
                                    _pr.getExpValue();
                                    print(_pr.privacy);
                                  });
                                },
                              ),
                            )
                          ],
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
                                            setState(() {
                                              formattedDateTime =
                                                  DateFormat('dd MMMM y')
                                                      .format(value);
                                              _selectedDate = value;
                                              _pr.getDeadline(_selectedDate);
                                              _pr.getExpValue();
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _pr.exp.toString() == "null"
                                  ? "100"
                                  : _pr.exp.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40.0,
                                  color: Color(0xFF22DFD4)),
                            ),
                            Image(
                              width: 70.0,
                              height: 70.0,
                              image: AssetImage("lib/images/power.png"),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5.0,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            print(_pr.privacy);
                            await MissionBrain().addMissionToDatabase(
                                _pr.textMission,
                                _pr.categoryTitle,
                                _pr.stepsList,
                                _pr.difficulty,
                                _pr.privacy,
                                await ProfilBrainData()
                                    .getUserName(currentUserEmail),
                                _pr.deadline,
                                _pr.getExpValue());
                            _pr.getPrivacyMission(true);
                            _pr.getDeadline(_selectedDate);
                            _pr.getDifficultyMission(1);
                            _pr.stepsList.clear();
                            print("Navigate Main SCREEN");
                            if (_pr.firstMission == true) {
                              await Navigator.pushNamed(
                                  context, TutorialMissionScreen.id);
                              Provider.of<MissionData>(context)
                                  .getFirstMissionValue(false);
                            } else {
                              Navigator.pushNamed(context, MainScreen.id);
                            }
                          }
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
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
