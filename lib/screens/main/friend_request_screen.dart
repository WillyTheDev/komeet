import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

Firestore _fs = Firestore.instance;

class FriendRequestScreen extends StatefulWidget {
  static String id = "friend_request_screen";
  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, MainScreen.id);
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Friend Request",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fs
            .collection("Users")
            .document(currentUserEmail)
            .collection("FriendsRequest")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kBlueLaserColor,
              ),
            );
          } else {
            List<FriendRequestProfil> friendsRequestList = [];
            var documents = snapshot.data.documents;
            for (var document in documents) {
              final String requestName = document.data["friendName"];
              final String requestEmail = document.data["friendEmail"];
              final String requestPicture = document.data["profilPicture"];
              friendsRequestList.add(FriendRequestProfil(
                  profilPicture: requestPicture, userName: requestName, friendEmail: requestEmail,));
            }return friendsRequestList.length > 0 ? ListView(
              children: friendsRequestList,
            )
                :
            Center(
                child: Text(
              "There is no Request for the moment... 👨‍🚀",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500),
            ));
          }
        },
      ),
    );
  }
}
