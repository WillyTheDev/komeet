import 'package:Komeet/brain/progression_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _fs = Firestore.instance;

class SpacePassScreen extends StatefulWidget {
  static String id = "space_pass_screen";
  @override
  _SpacePassScreenState createState() => _SpacePassScreenState();
}

class _SpacePassScreenState extends State<SpacePassScreen> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        width: data.size.width,
        height: data.size.height,
        decoration: BoxDecoration(color: Color(0xFFE1E1E1)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: data.size.width / 20,
                  ),
                  Text(
                    "Space Pass",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: _fs
                        .collection("Users")
                        .document(currentUserEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      int rank = snapshot.data["rank"];
                      int userExp = snapshot.data["userExp"];
                      return Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: mainColorGradient),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade200),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          rank.toString(),
                                          style: TextStyle(
                                              color: Level().levelColor(rank),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  Container(
                                    width: 1000.0 / 6,
                                    height: data.size.height / 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE1E1E1),
                                      borderRadius: BorderRadius.circular(20.0),
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
                                  ),
                                  Container(
                                    width: userExp.toDouble() / 6,
                                    height: data.size.height / 40,
                                    decoration: BoxDecoration(
                                        gradient: mainColorGradient,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Stack(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: data.size.width / 2,
                                            height: data.size.width / 4,
                                            decoration: BoxDecoration(
                                                gradient: freeGradient,
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 4.0,
                                                        color: Colors.black54),
                                                    bottom: BorderSide(
                                                        width: 4.0,
                                                        color: Colors.black54),
                                                    right: BorderSide(
                                                        width: 2.0,
                                                        color: Colors
                                                            .grey.shade600))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    width: data.size.width / 8,
                                                    child: Image(
                                                      image: AssetImage(
                                                          "lib/images/free.png"),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Free",
                                                    style: TextStyle(
                                                        shadows: [
                                                          BoxShadow(
                                                            color: Colors.black,
                                                            blurRadius: 4.0,
                                                            offset:
                                                                Offset(2, 2),
                                                          ),
                                                        ],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: data.size.width / 2,
                                            height: data.size.width / 4,
                                            decoration: BoxDecoration(
                                              gradient: premiumGradient,
                                              border: Border(
                                                top: BorderSide(
                                                    width: 4.0,
                                                    color: Colors.black54),
                                                left: BorderSide(
                                                    width: 2.0,
                                                    color:
                                                        Colors.grey.shade600),
                                                bottom: BorderSide(
                                                    width: 4.0,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    width: data.size.width / 8,
                                                    child: Image(
                                                      image: AssetImage(
                                                          "lib/images/premium.png"),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Premium",
                                                    style: TextStyle(
                                                        shadows: [
                                                          BoxShadow(
                                                            color: Colors.black,
                                                            blurRadius: 4.0,
                                                            offset:
                                                                Offset(2, 2),
                                                          ),
                                                        ],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                }
                                return Stack(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: data.size.width / 2,
                                          height: data.size.width / 2,
                                          decoration: BoxDecoration(
                                              gradient: freeGradient,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 4.0,
                                                      color: Colors.black54),
                                                  right: BorderSide(
                                                      width: 2.0,
                                                      color: Colors
                                                          .grey.shade600))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: data.size.width / 4,
                                                height: data.size.width / 4,
                                                child: Image(
                                                  image: AssetImage(SpacePass()
                                                              .spacePassList[
                                                                  index]
                                                              .freeImage ==
                                                          null
                                                      ? index < 6
                                                          ? "lib/images/power.png"
                                                          : "lib/images/space-ship.png"
                                                      : SpacePass()
                                                          .spacePassList[index]
                                                          .freeImage),
                                                ),
                                              ),
                                              Text(
                                                SpacePass()
                                                            .spacePassList[
                                                                index]
                                                            .freeText ==
                                                        null
                                                    ? index < 6
                                                        ? "50EXP"
                                                        : "3 Stats Pts"
                                                    : SpacePass()
                                                        .spacePassList[index]
                                                        .freeText,
                                                style: TextStyle(
                                                    color: kBlueLaserColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.0),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: data.size.width / 2,
                                          height: data.size.width / 2,
                                          decoration: BoxDecoration(
                                            gradient: premiumGradient,
                                            border: Border(
                                              left: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.grey.shade600),
                                              bottom: BorderSide(
                                                  width: 4.0,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: data.size.width / 2,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: index <= rank
                                                  ? passValidColorGradient
                                                  : mainColorGradient),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: index <= rank
                                                      ? Colors
                                                          .lightGreen.shade100
                                                      : Color(0xFFE1E1E1)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  index <= rank
                                                      ? "✅"
                                                      : index.toString(),
                                                  style: TextStyle(
                                                      color: Level()
                                                          .levelColor(index),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 22.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: 101,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
