import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/messages.dart';
import 'package:Komeet/provider/feedData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Firestore _fs = Firestore.instance;

class CompletedMissionScreen extends StatefulWidget {
  static String id = "completed_mission_public_screen";
  CompletedMissionScreen(
      {@required this.missionText,
      @required this.userEmail,
      @required this.missionCategory,
      @required this.userName,
      @required this.profilPicture,
      @required this.rank,
      @required this.userText,
      @required this.missionPicture,
      @required this.missionDifficulty,
      @required this.missionExp,
      @required this.missionDeadline,
      @required this.missionReference});
  final String missionText;
  final String missionCategory;
  final int missionDifficulty;
  final int missionExp;
  final String missionPicture;
  final DateTime missionDeadline;
  final String profilPicture;
  final String rank;
  final String userName;
  final String userText;
  final String userEmail;
  final String missionReference;

  @override
  _CompletedMissionScreenState createState() => _CompletedMissionScreenState();
}

class _CompletedMissionScreenState extends State<CompletedMissionScreen> {
  final messageTextController = TextEditingController();
  @override
  void initState() {
    print("mission picture = ${widget.missionPicture}");
    print("mission Text = ${widget.missionText}");
    print("mission Category = ${widget.missionCategory}");
    print("mission Difficulty = ${widget.missionDifficulty}");
    print("profilPicture = ${widget.profilPicture}");
    print("userText = ${widget.userText}");
    print("userEmail = ${widget.userEmail}");
    print("missionReference = ${widget.missionReference}");
    print("userName = ${widget.userName}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _fs
          .collection("Users")
          .document(Provider.of<ProfilBrainData>(context).email)
          .collection("MissionsCompleted")
          .document(widget.missionText)
          .collection("Comments")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: kBlueLaserColor,
          ));
        }
        var comments = snapshot.data.documents;
        List<Comment> commentBubbles = [];
        for (var comment in comments) {
          final messageText = comment.data["text"];
          final messageSender = comment.data["sender"];
          final email = comment.data["email"];
          final commentBubble = Comment(
            sender: messageSender,
            text: messageText,
            isMe:
                Provider.of<ProfilBrainData>(context).userName == messageSender,
            profilPicture: widget.profilPicture,
            email: email,
          );
          commentBubbles.add(commentBubble);
        }
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Text(
              "Comments",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 8.0,
                    pinned: false,
                    expandedHeight: widget.missionPicture != null
                        ? data.size.height / 1.2
                        : data.size.height / 3,
                    floating: false,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.missionPicture != null
                                ? Container(
                                    width: data.size.width,
                                    height: data.size.height / 2.5,
                                    child: Image(
                                      image:
                                          NetworkImage(widget.missionPicture),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                            Row(
                              children: <Widget>[
                                widget.profilPicture != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(widget.profilPicture),
                                      )
                                    : StreamBuilder<DocumentSnapshot>(
                                        stream: _fs
                                            .collection("Users")
                                            .document(widget.userEmail)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Container(
                                              height: data.size.height / 8,
                                              width: data.size.width / 8,
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
                                            height: data.size.height / 8,
                                            width: data.size.width / 8,
                                            child: Avatar(
                                                clotheColor:
                                                    avatar["clotheColor"],
                                                bodyType: avatar["avatarType"],
                                                bodyColor: avatar["bodyColor"],
                                                hairColor: avatar["hairColor"],
                                                hairStyle: avatar["hairStyle"],
                                                background:
                                                    avatar["backgroundColor"]),
                                          );
                                        }),
                                SizedBox(
                                  width: data.size.width / 80,
                                ),
                                Text(
                                  widget.userName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: data.size.width / 20,
                            ),
                            Text(
                              widget.missionText,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 24.0),
                            ),
                            Expanded(
                              child: Text(
                                widget.userText != null ? widget.userText : "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,
                                    color: Colors.blueGrey),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.comment,
                                  size: 25.0,
                                  color: Colors.blueGrey,
                                ),
                                Text(
                                  commentBubbles.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0,
                                      color: Colors.blueGrey),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: _fs
                                        .collection("Users")
                                        .document(Provider.of<ProfilBrainData>(
                                                context)
                                            .email)
                                        .collection("MissionsCompleted")
                                        .document(widget.missionText)
                                        .collection("Like")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () async {
                                                  await MissionBrain()
                                                      .likeCompletedMission(
                                                          widget.missionText,
                                                          widget.userName);
                                                },
                                                icon: Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.blueGrey,
                                                  size: 30.0,
                                                ),
                                              ),
                                              Text(
                                                "0 ",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      print(
                                          "userEmail = ${Provider.of<ProfilBrainData>(context).email}, missionText = ${widget.missionText}");
                                      bool isLiked = false;
                                      for (var user
                                          in snapshot.data.documents) {
                                        String userEmail = user.data["email"];
                                        if (userEmail == currentUserEmail) {
                                          isLiked = true;
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () async {
                                                    await MissionBrain()
                                                        .likeCompletedMission(
                                                            widget.missionText,
                                                            widget.userName);
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 30.0,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    MissionBrain()
                                                        .showMissionLike(
                                                      context,
                                                      Provider.of<ProfilBrainData>(
                                                              context)
                                                          .email,
                                                      widget.missionText,
                                                    );
                                                  },
                                                  child: Text(
                                                    snapshot
                                                        .data.documents.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () async {
                                                    await MissionBrain()
                                                        .likeCompletedMission(
                                                            widget.missionText,
                                                            widget.userName);
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.blueGrey,
                                                    size: 30.0,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    MissionBrain()
                                                        .showMissionLike(
                                                      context,
                                                      Provider.of<ProfilBrainData>(
                                                              context)
                                                          .email,
                                                      widget.missionText,
                                                    );
                                                  },
                                                  child: Text(
                                                    snapshot
                                                        .data.documents.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.blueGrey,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            IconButton(
                                              onPressed: () async {
                                                await MissionBrain()
                                                    .likeCompletedMission(
                                                        widget.missionText,
                                                        widget.userName);
                                              },
                                              icon: Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isLiked
                                                    ? Colors.red
                                                    : Colors.blueGrey,
                                                size: 30.0,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data.documents.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: isLiked
                                                      ? Colors.red
                                                      : Colors.blueGrey,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      commentBubbles,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: data.size.height / 10,
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: messageTextController,
                  minLines: 1,
                  maxLines: 6,
                  autocorrect: true,
                  onChanged: (String value) {
                    Provider.of<FeedData>(context).getCommentText(value);
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: IconButton(
                        onPressed: () async {
                          String userName = await ProfilBrainData()
                              .getUserName(currentUserEmail);
                          String profilPicture = await ProfilBrainData()
                              .getProfilePicture(currentUserEmail);
                          _fs
                              .collection("Users")
                              .document(await ProfilBrainData()
                                  .getEmail(widget.userName))
                              .collection("MissionsCompleted")
                              .document(widget.missionText)
                              .collection("Comments")
                              .document(DateTime.now().toString())
                              .setData({
                            "email": currentUserEmail,
                            "text": Provider.of<FeedData>(context).commentText,
                            "sender": userName,
                            "profilPicture": profilPicture
                          });
                          messageTextController.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          size: 40.0,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Write a comment",
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black54),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black26),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
