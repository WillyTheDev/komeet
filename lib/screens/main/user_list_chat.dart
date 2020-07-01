import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsListChatScreen extends StatefulWidget {
  static String id = "personnal_chat_screen";
  @override
  _FriendsListChatScreenState createState() => _FriendsListChatScreenState();
}

class _FriendsListChatScreenState extends State<FriendsListChatScreen> {
  @override
  Widget build(BuildContext context) {
    var _pr = Provider.of<ProfilBrainData>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.white,
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _pr.chatFriendsList.length == 0
          ? Center(
              child: Text(
                  "There is nothing to show, you might need to add some friends  👩‍🚀‍",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500)),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ChatProfil(
                  chatReference: _pr.chatFriendsList[index].chatReference,
                  username: _pr.chatFriendsList[index].username,
                  profilPicture: _pr.chatFriendsList[index].profilPicture,
                );
              },
              itemCount: _pr.chatFriendsList.length,
            ),
    );
  }
}
