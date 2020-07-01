import 'package:Komeet/brain/progression_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/friend_profil_screen.dart';
import 'package:Komeet/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _fs = Firestore.instance;

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender, this.text, this.isMe, this.image, @required this.rank});
  final int rank;
  final String sender;
  final String text;
  final bool isMe;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              Provider.of<ProfilBrainData>(context).getMissionsCompletedList(
                  await Provider.of<ProfilBrainData>(context).getEmail(sender));
              Provider.of<ProfilBrainData>(context)
                  .getBadgeList(await ProfilBrainData().getEmail(sender));
              if (sender ==
                  await ProfilBrainData().getUserName(currentUserEmail)) {
                Navigator.pushNamed(context, MainScreen.id);
              } else {
                Navigator.pushNamed(context, FriendProfilScreen.id);
              }
            },
            child: Text(
              sender,
              style: TextStyle(
                fontSize: 14.0,
                color: Level().levelColor(rank),
              ),
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Color(0xFFE1E1E1),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: image == ""
                  ? Text(
                      text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black54,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image(
                        image: NetworkImage(image),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  Comment({this.sender, this.text, this.isMe, this.profilPicture, this.email});

  final String sender;
  final String text;
  final String email;
  final String profilPicture;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  Provider.of<ProfilBrainData>(context)
                      .getMissionsCompletedList(
                          await Provider.of<ProfilBrainData>(context)
                              .getEmail(sender));
                  Provider.of<ProfilBrainData>(context)
                      .getBadgeList(await ProfilBrainData().getEmail(sender));
                  Navigator.pushNamed(context, FriendProfilScreen.id);
                },
                child: profilPicture != null
                    ? CircleAvatar(
                        minRadius: 10.0,
                        maxRadius: 20.0,
                        backgroundImage: NetworkImage(profilPicture),
                      )
                    : StreamBuilder<DocumentSnapshot>(
                        stream:
                            _fs.collection("Users").document(email).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: data.size.height / 10,
                              width: data.size.width / 10,
                              child: Avatar(
                                  clotheColor: 1,
                                  bodyType: "female",
                                  bodyColor: 5,
                                  hairColor: 3,
                                  hairStyle: 4,
                                  background: 3),
                            );
                          }
                          var avatar = snapshot.data["Avatar"];
                          return Container(
                            height: data.size.height / 10,
                            width: data.size.width / 10,
                            child: Avatar(
                                clotheColor: avatar["clotheColor"],
                                bodyType: avatar["avatarType"],
                                bodyColor: avatar["bodyColor"],
                                hairColor: avatar["hairColor"],
                                hairStyle: avatar["hairStyle"],
                                background: avatar["backgroundColor"]),
                          );
                        }),
              ),
              SizedBox(
                width: data.size.width / 40,
              ),
              GestureDetector(
                onTap: () async {
                  Provider.of<ProfilBrainData>(context)
                      .getMissionsCompletedList(
                          await Provider.of<ProfilBrainData>(context)
                              .getEmail(sender));
                  Provider.of<ProfilBrainData>(context)
                      .getBadgeList(await ProfilBrainData().getEmail(sender));
                  await Provider.of<ProfilBrainData>(context)
                      .isAlreadyFriend(sender);
                  Navigator.pushNamed(context, FriendProfilScreen.id);
                },
                child: Text(
                  sender,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
