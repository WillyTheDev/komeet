import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/feedData.dart';
import 'package:Komeet/screens/main/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class PostMissionScreen extends StatefulWidget {
  static String id = "mission_post_screen";

  @override
  _PostMissionScreenState createState() => _PostMissionScreenState();
}

class _PostMissionScreenState extends State<PostMissionScreen> {
  String url;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<MissionData>(context);
    final addPicture = SnackBar(
      backgroundColor: Colors.white,
      content: Container(
        height: 100.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Text(
          "Picture Added ! ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30.0),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              child: Text(
                "Publish",
                style: TextStyle(
                    color: kBlueLaserColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 22.0),
              ),
              onPressed: () async {
                await MissionBrain().completeMission(
                  _pr.reference,
                  _pr.missionPicture,
                  _pr.privacy,
                  _pr.userText,
                  _pr.textMission,
                  _pr.exp,
                  _pr.categoryTitle,
                  _pr.deadline,
                  _pr.difficulty,
                  DateTime.now(),
                );
                Provider.of<FeedData>(context, listen: false).getFeedScreenData();
                Provider.of<MissionData>(context, listen: false).getUserMissionText("");
                await myInterstitial.show();
                Navigator.pushNamed(context, MainScreen.id);
              },
            ),
          )
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Save your Accomplishment",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              _pr.getLoadingPostMissionImage(true);
              await MissionBrain().getImage(_pr.textMission);
              Future.delayed(Duration(seconds: 1));
              String newUrl =
                  await MissionBrain().getMissionPicture(_pr.textMission);
              setState(() {
                url = newUrl;
              });
              Provider.of<MissionData>(context, listen: false).getMissionPicture(url);
              _pr.getLoadingPostMissionImage(false);
              Scaffold.of(context).showSnackBar(addPicture);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: data.size.height / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 15.0,
                        offset: Offset.fromDirection(-5, 5),
                      )
                    ]),
                child: url != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      )
                    : _pr.loadingPostMissionImage
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Icon(
                            Icons.add_a_photo,
                            size: 75.0,
                            color: Color(0xFFE1E8E7),
                          ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String value) {
                _pr.getUserMissionText(value);
              },
              maxLines: 12,
              minLines: 1,
              autofocus: true,
              decoration: InputDecoration(
                  hintText: "(Optional) Write something",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          BorderSide(width: 4.0, color: kBlueLaserColor))),
            ),
          ),
        ],
      ),
    );
  }
}
