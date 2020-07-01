import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/SearchAutoData.dart';
import 'package:Komeet/provider/feedData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/calendar_screen.dart';
import 'package:Komeet/screens/main/feed_screen.dart';
import 'package:Komeet/screens/main/profil_screen.dart';
import 'package:Komeet/screens/main/search_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

final FirebaseMessaging _fcm = FirebaseMessaging();

class MainScreen extends StatefulWidget {
  static String id = "main_screen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController = PageController(
    initialPage: 3,
  );
  Map activePages = {
    "page0": false,
    "page1": false,
    "page2": false,
    "page3": true,
    "page4": false,
  };


  bool newRequest = false;
  @override
  void initState() {
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      Flushbar(
        backgroundColor: Colors.white,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.easeIn,
        reverseAnimationCurve: Curves.easeOut,
        titleText: Text(
          message["notification"]["title"],
          style: TextStyle(color: Colors.black),
        ),
        messageText: Text(
          message["notification"]["body"],
          style: TextStyle(color: Colors.black),
        ),
        duration: Duration(seconds: 3),
        isDismissible: true,
      )..show(context);
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    });
    ProfilBrainData().saveDeviceToken();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    print("MainScreenDispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("MainScreenLoaded");
    final data = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          children: <Widget>[
            PageView(
              onPageChanged: (int) async {
                setState(() {
                  activePages = {
                    "page0": false,
                    "page1": false,
                    "page2": false,
                    "page3": false,
                    "page4": false,
                  };
                  activePages["page$int"] = true;
                });
                Provider.of<ProfilBrainData>(context,listen: false).checkFriendsRequest();
                Provider.of<ProfilBrainData>(context,listen: false).checkNewPrivateMission();

                if (int == 3) {
                  Provider.of<ProfilBrainData>(context,listen: false).getUserName(currentUserEmail);
                  Provider.of<ProfilBrainData>(context,listen: false)
                      .getMissionsCompletedList(currentUserEmail);
                  Provider.of<ProfilBrainData>(context,listen: false)
                      .getBadgeList(currentUserEmail);
                  Provider.of<ProfilBrainData>(context,listen: false).getProfilInitialData();
                  await Provider.of<ProfilBrainData>(context,listen: false)
                      .getUserAvatar(currentUserEmail);
                  await Provider.of<ProfilBrainData>(context,listen: false)
                      .getNewFriendsRequest();
                  await Provider.of<ProfilBrainData>(context,listen: false)
                      .getNewMissionsRequest();
                }
              },
              physics: BouncingScrollPhysics(),
              controller: pageController,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                FeedScreen(),
                SearchScreen(),
                CalendarScreen(),
                ProfilScreen(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(color: kBackgroundColor, boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10.0,
                    offset: Offset(-3, -3),
                  )
                ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Provider.of<ProfilBrainData>(context, listen: false)
                              .checkFriendsList();
                          setState(() {
                            pageController.jumpToPage(0);
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.dashboard,
                              size: 35.0,
                              color: activePages["page0"]
                                  ? kCTA
                                  : Colors.grey.shade400,
                            ),
                            Provider.of<ProfilBrainData>(context)
                                    .newPrivateMessage
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                    ),
                                  )
                                : Container(
                                    width: 12.0,
                                    height: 12.0,
                                  ),
                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              pageController.jumpToPage(1);
                            });
                          },
                          child: Icon(
                            Icons.search,
                            size: 35.0,
                            color: activePages["page1"]
                                ? kCTA
                                : Colors.grey.shade400,
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pageController.jumpToPage(2);
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Provider.of<MissionData>(context).newMissionMessage
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                          color: kBlueLaserColor,
                                          shape: BoxShape.circle),
                                    ),
                                  )
                                : Container(
                                    width: 12.0,
                                    height: 12.0,
                                  ),
                            Icon(
                              Icons.flag,
                              size: 35.0,
                              color: activePages["page2"]
                                  ? kCTA
                                  : Colors.grey.shade400,
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            pageController.jumpToPage(3);
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Icon(
                              Icons.account_box,
                              size: 35.0,
                              color: activePages["page3"]
                                  ? kCTA
                                  : Colors.grey.shade400,
                            ),
                            Provider.of<ProfilBrainData>(context).newRequest
                                ? Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                    ),
                                  )
                                : Container(
                                    width: 12.0,
                                    height: 12.0,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
