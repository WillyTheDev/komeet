import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsListScreen extends StatefulWidget {
  static String id = "friend_list_screen";

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  @override
  Widget build(BuildContext context) {
    var _pr = Provider.of<ProfilBrainData>(context);
    print("FRIENDSLISTSCREEN BUILD");
    print(_pr.friendsList.length);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Friend's List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _pr.friendsList.length,
        itemBuilder: (context, index) {
          return !_pr.friendsList[index].isFriend
              ? SearchedProfile(
                  username: _pr.friendsList[index].username,
                  profilPicture: _pr.friendsList[index].profilPicture,
                  searchUserEmail: _pr.friendsList[index].userEmail,
                  userRank: _pr.friendsList[index].userRank,
                )
              : ChatProfil(
                  chatReference: _pr.friendsList[index].chatReference,
                  username: _pr.friendsList[index].username,
                  profilPicture: _pr.friendsList[index].profilPicture,
                );
        },
      ),
    );
  }
}
