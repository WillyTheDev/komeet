import 'dart:math';
import 'package:Komeet/brain/progression_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/friend_profil_screen.dart';
import 'package:Komeet/screens/main/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

class SpaceShipBrainData extends ChangeNotifier {
  final Firestore _fs = Firestore.instance;

  int spaceShip = 1;
  int spaceShipColor = 3;
  int spaceShipVersion = 1;
  int myRank;
  int myWin;
  List<BattleEvent> battleHistory = [];

  int basePrecision = 50;
  int baseDamage = 5;

  Map pirateAvatar = {
    "avatarType": "male",
    "bodyColor": Random().nextInt(4) + 1,
    "hairStyle": Random().nextInt(4) + 1,
    "hairColor": Random().nextInt(4) + 1,
    "backgroundColor": Random().nextInt(2) + 1
  };
  String enemyName;
  String enemyEmail;
  int enemyWin;
  Map enemyAvatar;
  Map enemySpaceShip;
  Map mySpaceShip;

  void getRank(int value) {
    myRank = value;
    notifyListeners();
  }

  void getEnemyName(String value) {
    enemyName = value;
    notifyListeners();
  }

  void getEnemyWin(int value) {
    enemyWin = value;
    notifyListeners();
  }

  void getEnemyEmail(String value) {
    enemyEmail = value;
    notifyListeners();
  }

  void getMySpaceShip(Map value) {
    mySpaceShip = value;
    notifyListeners();
  }

  void getMyWin(int value) {
    myWin = value;
    notifyListeners();
  }

  void upgradeMySpaceShip(String stat) {
    mySpaceShip[stat] = mySpaceShip[stat] + 1;
    notifyListeners();
  }

  void getEnemySpaceShip(Map value) {
    enemySpaceShip = value;
    notifyListeners();
  }

  void getEnemyAvatar(Map value) {
    enemyAvatar = value;
    notifyListeners();
  }

  void getSpaceShip(int value) {
    spaceShip = value;
    notifyListeners();
  }

  void getSpaceShipColor(int value) {
    spaceShipColor = value;
    notifyListeners();
  }

  void getSpaceShipVersion(int value) {
    spaceShipVersion = value;
    notifyListeners();
  }

  void updateSpaceShip(
      int spaceShip,
      int spaceShipColor,
      int spaceShipVersion,
      int health,
      int armor,
      int mobility,
      int damage,
      int accuracy,
      int fireRate) {
    Map spaceShipMap = {
      "spaceShip": spaceShip,
      "spaceShipVersion": spaceShipVersion,
      "spaceShipColor": spaceShipColor,
      "health": health,
      "armor": armor,
      "mobility": mobility,
      "damage": damage,
      "accuracy": accuracy,
      "firerate": fireRate
    };
    _fs.collection("Users").document(currentUserEmail).updateData({
      "SpaceShip": spaceShipMap,
    });
  }

  void addFirstSpaceShip(
    int spaceShip,
    int spaceShipColor,
  ) {
    Map spaceShipMap = {
      "spaceShip": spaceShip,
      "spaceShipVersion": 1,
      "spaceShipColor": spaceShipColor,
      "health": 80,
      "armor": 30,
      "mobility": 30,
      "damage": 30,
      "accuracy": 30,
      "firerate": 30,
    };
    _fs.collection("Users").document(currentUserEmail).updateData({
      "SpaceShip": spaceShipMap,
      "battleWin": 0,
      "statPoints": 0,
    });
  }

  bool tirer(double chanceDeTirer) {
    int tir = Random().nextInt(100);
    if (tir <= chanceDeTirer.floor()) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> combatUser(
      Map you, Map enemy, BuildContext context, String enemyName) async {
    print("Combat1 Launched");
    int fireRate = 2000 - you["firerate"] * 10;
    double chanceDeToucher =
        (basePrecision + (you["accuracy"] / 2) - (enemy["mobility"] / 2));
    while (enemy["health"] > 0 && you["health"] > 0) {
      print("BattleHistory = ${battleHistory.length}");
      print("'you' prépare son tir");
      await Future.delayed(Duration(milliseconds: fireRate), () {
        if (tirer(chanceDeToucher) == true) {
          print("you = Tir Réussi");
          double degatInflige =
              (enemy["armor"] / 10 + (-baseDamage - you["damage"] / 2));
          enemy["health"] = enemy["health"] + degatInflige;
          if (enemy["health"] < 0) {
            enemy["health"] = 0;
          }
          print("enemy = ${enemy["health"]}");
          battleHistory.add(BattleEvent(damage: degatInflige, isEnemy: false));
          notifyListeners();
        } else {
          print("you = tir failed");
        }
      });
    }
    await Future.delayed(Duration(seconds: 2));
    if (enemy["health"] > you["health"]) {
      print("Ennemi Win");
      return "Ennemi Win";
    } else if (enemy["health"] < you["health"]) {
      _fs.collection("Users").document(currentUserEmail).updateData({
        "battleWin": myWin + 1,
      });
      if (enemyName != "Pirate") {
        _fs.collection("Users").document(enemyEmail).updateData({
          "battleWin": enemyWin - 1,
        });
      }
      print("You win");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text(
                "You Win 💪",
                style: TextStyle(color: Colors.blue),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text("$enemyName's ship is Destroyed !",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16.0)),
                ),
                FlatButton(
                  onPressed: () async {
                    print("show ad");
                    print(" ad is loaded ? = ${myInterstitial.isLoaded()}");
                    if (await ProfilBrainData()
                            .checkPremiumStatus(currentUserEmail) ==
                        true) {
                      battleHistory.clear();
                      notifyListeners();
                      Navigator.pushNamed(context, MainScreen.id);
                    } else {
                      myInterstitial..show();
                      battleHistory.clear();
                      notifyListeners();
                      Navigator.pushNamed(context, MainScreen.id);
                    }
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            );
          });
      return "Ennemi loose";
    } else {
      print("combatYou Draw");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text("Draw"),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Both ship are Destroyed !",
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 16.0),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    print(" ad is loaded ? = ${myInterstitial.isLoaded()}");
                    if (await ProfilBrainData()
                            .checkPremiumStatus(currentUserEmail) ==
                        true) {
                      battleHistory.clear();
                      notifyListeners();
                      Navigator.pushNamed(context, MainScreen.id);
                    } else {
                      myInterstitial..show();
                      battleHistory.clear();
                      notifyListeners();
                      Navigator.pushNamed(context, MainScreen.id);
                    }
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            );
          });
      return "Draw";
    }
  }

  Future<String> combatEnemy(
      Map you, Map enemy, BuildContext context, String enemyName) async {
    print("Combat1 Launched");
    int fireRate = 2000 - you["firerate"] * 10;
    double chanceDeToucher =
        (basePrecision + (you["accuracy"] / 2) - (enemy["mobility"] / 2));
    while (enemy["health"] > 0 && you["health"] > 0) {
      print("Enemy prépare son tir");
      await Future.delayed(Duration(milliseconds: fireRate), () {
        if (tirer(chanceDeToucher) == true) {
          print("Enemy = Tir Réussi");
          double degatInflige =
              (enemy["armor"] / 10 + (-baseDamage - you["damage"] / 2));
          enemy["health"] = enemy["health"] + degatInflige;
          if (enemy["health"] < 0) {
            enemy["health"] = 0;
          }
          print("you = ${enemy["health"]}");
          battleHistory.add(BattleEvent(damage: degatInflige, isEnemy: true));
          notifyListeners();
        } else {
          print("Enemy = tir failed");
        }
      });
    }
    await Future.delayed(Duration(seconds: 2));
    if (enemy["health"] < you["health"]) {
      print("Enemy Win");

      if (enemyName != "Pirate") {
        _fs.collection("Users").document(enemyEmail).updateData({
          "battleWin": enemyWin + 1,
        });
      }
      _fs.collection("Users").document(currentUserEmail).updateData({
        "battleWin": myWin - 1,
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text("You loose 🏴‍☠️"),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Your ship has been Destroyed",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    if (await ProfilBrainData()
                            .checkPremiumStatus(currentUserEmail) ==
                        true) {
                      battleHistory.clear();
                      notifyListeners();
                      Navigator.pushNamed(context, MainScreen.id);
                    } else {
                      print("show ad");
                      print(" ad is loaded ? = ${myInterstitial.isLoaded()}");
                      myInterstitial..show();
                      battleHistory.clear();
                      notifyListeners();
                      Navigator.pushNamed(context, MainScreen.id);
                    }
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            );
          });
      return "Enemy Win";
    } else if (enemy["health"] > you["health"]) {
      print("enemy loose");
      return "Ennemi loose";
    } else {
      print("combat enemy : Draw");
      return "Draw";
    }
  }

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['comfort zone', 'adventure'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: 'ca-app-pub-1019750920692164/6379187192',
    // adUnitId: 'ca-app-pub-1019750920692164/3879826995', TODO Ios
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  Future<void> battle(
      Map you, Map enemy, BuildContext context, String enemyName) async {
    await myInterstitial.load();
    print(" ad is loaded ? = ${myInterstitial.isLoaded()}");
    combatUser(you, enemy, context, enemyName).whenComplete(() {
      return true;
    });
    combatEnemy(enemy, you, context, enemyName).whenComplete(() {
      return false;
    });
    print("launched combat");
  }

  Future showLadderBubble(
    BuildContext context,
  ) async {
    final user = MediaQuery.of(context);
    print("Mission Bubble Open !");
    List<Widget> userSubscribed = [];
    var users = await _fs
        .collection("Users")
        .orderBy("battleWin", descending: true)
        .getDocuments();
    for (var user in users.documents) {
      print("${user.documentID}");
      String userName;
      userName = await user.data["userName"];
      print(userName);
      String profilPicture = user.data["profilPicture"];
      int battleWin = user.data["battleWin"];
      if (user.data["SpaceShip"] != null) {
        userSubscribed.add(Container(
          child: GestureDetector(
            onTap: () async {
              Provider.of<ProfilBrainData>(context).getEmail(userName);
              Provider.of<ProfilBrainData>(context).getMissionsCompletedList(
                  await ProfilBrainData().getEmail(userName));
              Provider.of<ProfilBrainData>(context)
                  .getBadgeList(await ProfilBrainData().getEmail(userName));
              Provider.of<ProfilBrainData>(context).isAlreadyFriend(userName);
              Navigator.pushNamed(context, FriendProfilScreen.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: profilPicture != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(profilPicture),
                          )
                        : StreamBuilder<DocumentSnapshot>(
                            stream: _fs
                                .collection("Users")
                                .document(user.documentID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  width: 35.0,
                                  height: 35.0,
                                  child: Avatar(
                                    clotheColor: 1,
                                    bodyType: "male",
                                    background: 2,
                                    bodyColor: 2,
                                    hairStyle: 3,
                                    hairColor: 2,
                                  ),
                                );
                              }
                              var user = snapshot.data["Avatar"];
                              print(
                                  "bodyType: ${user["avatarType"]} background: ${user["backgroundColor"]},");
                              return Container(
                                width: 35.0,
                                height: 35.0,
                                child: Avatar(
                                  clotheColor: user["clotheColor"],
                                  bodyType: user["avatarType"],
                                  background: user["backgroundColor"],
                                  bodyColor: user["bodyColor"],
                                  hairStyle: user["hairStyle"],
                                  hairColor: user["hairColor"],
                                ),
                              );
                            }),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          userName,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          battleWin.toString(),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Level().levelColor(battleWin)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.format_list_numbered,
                      size: 30.0, color: Colors.blue),
                ),
                Flexible(child: Text("LeaderBoard")),
              ],
            ),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: user.size.width / 1.4,
                    height: user.size.height / 2,
                    child: ListView(children: userSubscribed),
                  ),
                ],
              )
            ],
          );
        });
  }
}

class BattleEvent {
  BattleEvent({@required this.isEnemy, @required this.damage});
  bool isEnemy;
  double damage;
}
