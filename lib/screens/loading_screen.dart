import 'dart:async';
import 'dart:io';

import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/flare/Astronaut.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/SearchAutoData.dart';
import 'package:Komeet/provider/feedData.dart';

import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Tutoriel/choose_username.dart';
import 'package:Komeet/screens/Tutoriel/create_avatar_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'connexion/HomeScreen.dart';
import 'main/main_screen.dart';
import 'package:provider/provider.dart';

Firestore _fs = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();
FirebaseAuth _auth = FirebaseAuth.instance;
String currentUserEmail;

class LoadingScreen extends StatefulWidget {
  static String id = "loading_screen";
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // ignore: cancel_subscriptions
  StreamSubscription iosSubscription;
  void getCurrentUser() async {
    print("getCurrentuser launched  !");
    try {
      final user = await _auth.currentUser();
      final googleAccount = GoogleSignIn().currentUser;
      if (user != null || googleAccount != null) {
        currentUserEmail = user.email;
        print("auth : ${user.email}");
        DocumentSnapshot userData =
            await _fs.collection("Users").document(currentUserEmail).get();
        print("Tutorial is Over ? = ${userData.data["tutorialIsOver"]}");
        if (userData.data["tutorialIsOver"] == true) {
          print("TuTorial is OvEr");
          print("TuTorial is OvEr");
          await ProfilBrainData().getUserAvatar(currentUserEmail);
          ProfilBrainData().getMissionsCompletedList(currentUserEmail);
          await ProfilBrainData().getProfilInitialData();
          await MissionData().getCurrentMissionsData();
          _fcm.subscribeToTopic("CommunityMissions");
          Navigator.pushNamed(context, MainScreen.id);
        } else {
          print("TuTorial is not OvEr");
          print("TuTorial is not OvEr");
          await ProfilBrainData().getUserRank(currentUserEmail);
          await ProfilBrainData().getProfilInitialData();
          await MissionData().getCurrentMissionsData();
          await Future.delayed(Duration(seconds: 2));
          _fcm.subscribeToTopic("CommunityMissions");
          Navigator.pushNamed(context, ChooseUsername.id);
        }
      } else {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print("Loading Screen InitState Launched");
    getCurrentUser();
    _fcm.requestNotificationPermissions();
    super.initState();
    if (Platform.isIOS) {
      _fcm.configure();
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
      Provider.of<SearchAutoData>(context, listen: false).giveSuggestion(
          "", "Users");
      Provider.of<FeedData>(context, listen: false).getFeedScreenData();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: kgradientBackground,
            child: loadingAstronaut(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: data.size.height / 1.7,
              ),
              Center(
                child: Text(
                  "Komeet",
                  style: TextStyle(
                      color: Colors.indigoAccent[100],
                      fontSize: 30.0,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
