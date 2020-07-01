import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/messages.dart';
import 'package:Komeet/provider/MissionsData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Firestore _fs = Firestore.instance;

class MissionChatScreen extends StatefulWidget {
  static String id = "mission_chat_screen";
  @override
  _MissionChatScreenState createState() => _MissionChatScreenState();
}

class _MissionChatScreenState extends State<MissionChatScreen> {
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _pr = Provider.of<MissionData>(context);
    print(_pr.reference);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.white,
        title: Text(
          _pr.textMission,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _fs
                .collection(!_pr.isCommunity ? "CommunityMissions" : "Missions")
                .document(_pr.reference)
                .collection("Chat")
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: kBlueLaserColor,
                  ),
                );
              }
              print("Mission Screen Reference ${_pr.reference}");
              print("Mission Collection  ${_pr.isCommunity}");
              final messages = snapshot.data.documents;
              List<MessageBubble> messageBubbles = [];
              for (var message in messages) {
                final messageText = message.data["text"];
                final messageSender = message.data["sender"];
                final messageImage = message.data["image"];
                final int messageRank = message.data["rank"];
                final messageBubble = MessageBubble(
                  rank: messageRank,
                  image: messageImage,
                  sender: messageSender,
                  text: messageText,
                  isMe: Provider.of<ProfilBrainData>(context).userName ==
                      messageSender,
                );
                print("New Message Mission ADD $messageText");
                messageBubbles.add(messageBubble);
              }
              return ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messageBubbles,
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageTextController,
              autofocus: true,
              minLines: 1,
              maxLines: 6,
              autocorrect: true,
              onChanged: (String value) {
                _pr.getMissionMessage(value);
              },
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: Container(
                    width: 100.0,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            MissionBrain().getImageInChat(
                                await ProfilBrainData()
                                    .getUserName(currentUserEmail),
                                Provider.of<ProfilBrainData>(context)
                                    .currentFriend,
                                _pr.reference);
                            messageTextController.clear();
                          },
                          icon: Icon(
                            Icons.panorama,
                            size: 30.0,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await MissionBrain().sendMissionMessage(
                                _pr.reference,
                                _pr.missionMessage,
                                await Provider.of<ProfilBrainData>(context)
                                    .getUserName(currentUserEmail));
                            messageTextController.clear();
                          },
                          icon: Icon(
                            Icons.send,
                            size: 40.0,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Send a message",
                focusColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 4.0, color: Colors.black87),
                    borderRadius: BorderRadius.circular(20.0)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.black26),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
