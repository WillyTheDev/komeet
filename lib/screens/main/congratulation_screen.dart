import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/main.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/screens/main/mission_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:provider/provider.dart';

class CongratulationScreen extends StatefulWidget {
  static String id = "congratulation_screen";
  @override
  _State createState() => _State();
}

class _State extends State<CongratulationScreen> {
  ConfettiController _controllerBottomLeft;
  ConfettiController _controllerBottomRight;

  @override
  void initState() {
    _controllerBottomLeft = ConfettiController(duration: Duration(seconds: 10));
    _controllerBottomRight =
        ConfettiController(duration: Duration(seconds: 10));
    _controllerBottomLeft.play();
    _controllerBottomRight.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerBottomLeft.dispose();
    _controllerBottomRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: kBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: data.size.height / 3,
                    height: data.size.height / 3,
                    child: Image(
                      image: AssetImage("lib/images/mountain.png"),
                    ),
                  ),
                  Text(
                    "Congratulations !",
                    style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  Text(
                    "You have successfully completed this mission. You can be proud of you !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black38),
                  ),
                  SizedBox(
                    height: data.size.height / 40,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 16.0),
                      child: RaisedButton(
                        color: kCTA,
                        onPressed: () async {
                          await MissionBrain().completeMission(
                              Provider.of<MissionData>(context).reference,
                              null,
                              Provider.of<MissionData>(context).privacy,
                              null,
                              Provider.of<MissionData>(context).textMission,
                              Provider.of<MissionData>(context).exp,
                              Provider.of<MissionData>(context).categoryTitle,
                              Provider.of<MissionData>(context).deadline,
                              Provider.of<MissionData>(context).difficulty,
                              DateTime.now());
                          await myInterstitial.show();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Get Rewarded ! 💎",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RaisedButton(
                        color: kBlueLaserColor,
                        onPressed: () {
                          Navigator.pushNamed(context, PostMissionScreen.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Create a Memory  ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                              Icon(
                                Icons.public,
                                size: 25.0,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ConfettiWidget(
              confettiController: _controllerBottomRight,
              blastDirection: 180.0, // radial value - LEFT
              emissionFrequency: 0.03,
              numberOfParticles: 4,
              shouldLoop: true,
              colors: [
                Colors.amber,
                Colors.blue,
                Colors.pink
              ], // manually specify the colors to be used
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ConfettiWidget(
              confettiController: _controllerBottomLeft,
              blastDirection: 270, // radial value - LEFT
              emissionFrequency: 0.04,
              numberOfParticles: 4,
              shouldLoop: true,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink
              ], // manually specify the colors to be used
            ),
          ),
        ],
      ),
    );
  }
}
