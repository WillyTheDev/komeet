import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/messages.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Firestore _fs = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static String id = "Chat_Screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kBackgroundColor,
        title: Text(
          Provider.of<ProfilBrainData>(context).currentFriend,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _fs
                .collection("PrivateChat")
                .document(
                    Provider.of<ProfilBrainData>(context).privateChatReference)
                .collection("Chat")
                .orderBy("date", descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data.documents.reversed;
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  final messageText = message.data["text"];
                  final messageSender = message.data["sender"];
                  final messageImage = message.data["image"];
                  final messageRankUser = message.data["rank"];
                  final messageBubble = MessageBubble(
                    rank: messageRankUser,
                    image: messageImage,
                    sender: messageSender,
                    text: messageText,
                    isMe: Provider.of<ProfilBrainData>(context).userName ==
                        messageSender,
                  );
                  messageBubbles.add(messageBubble);
                }
                return ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: messageBubbles,
                );
              } else {
                return Center(
                  child: Text("No Data"),
                );
              }
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
                Provider.of<ProfilBrainData>(context).getPrivateMessage(value);
              },
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                suffixIcon: Container(
                  width: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          ProfilBrainData().getImageInChat(
                              await ProfilBrainData()
                                  .getUserName(currentUserEmail),
                              Provider.of<ProfilBrainData>(context)
                                  .currentFriend);
                          messageTextController.clear();
                        },
                        icon: Icon(
                          Icons.panorama,
                          size: 30.0,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          messageTextController.clear();
                          Provider.of<ProfilBrainData>(context)
                              .sendPrivateMessage(
                                  Provider.of<ProfilBrainData>(context)
                                      .currentFriend);
                        },
                        icon: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ],
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
