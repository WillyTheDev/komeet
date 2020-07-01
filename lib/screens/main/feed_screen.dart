import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/provider/feedData.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/main/user_list_chat.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  static String id = "feed_screen";
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  bool animated = false;
  bool isAnimated = true;
  PageController controller = PageController();
  ScrollController scrollController = ScrollController();
  int present = 10;

  Future loopAnimation() async {
    Future.delayed(Duration(seconds: 7)).whenComplete(() {
      print("IsAnimated = false");
      setState(() {
        isAnimated = false;
      });
    });
    while (isAnimated = true) {
      await Future.delayed(Duration(seconds: 1));
      if (animated == false) {
        setState(() {
          animated = true;
        });
      } else {
        setState(() {
          animated = false;
        });
      }
    }
    return;
  }

  @override
  void initState() {
    loopAnimation();
    super.initState();
  }

  @override
  void dispose() {
      isAnimated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _pr = Provider.of<FeedData>(context);
    print("feeds Element :${_pr.missionsFeedList.length}");
    print(_pr.getFeedScreenDataIsOver);
    final data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: !_pr.getFeedScreenDataIsOver ||
              _pr.getFeedScreenDataIsOver &&
                  Provider.of<ProfilBrainData>(context).haveFriends == false
          ? AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(gradient: oldReverseColorGradient),
              ),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Komeet",
                    style: TextStyle(
                      fontFamily: "Lulo",
                      color: kBackgroundColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Provider.of<ProfilBrainData>(context, listen: false)
                          .listOfChatFriend();
                      Navigator.pushNamed(context, FriendsListChatScreen.id);
                    },
                    child: Icon(
                      Icons.email,
                      color: Provider.of<ProfilBrainData>(context)
                              .newPrivateMessage
                          ? Colors.red
                          : kBackgroundColor,
                      size: 30.0,
                    ),
                  )
                ],
              ),
              elevation: 5.0,
            )
          : null,
      body: !_pr.getFeedScreenDataIsOver
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.ease,
                          width: data.size.width,
                          height: data.size.height / 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: animated ? kBackgroundColor : Colors.grey,
                          ),
                        ),
                      );
                    },
                    itemCount: 5,
                  ),
                )
              ],
            ))
          : _pr.getFeedScreenDataIsOver &&
                  Provider.of<ProfilBrainData>(context).haveFriends == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Nothing to show",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 75.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Search for Friends",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: 35.0,
                                child: Image(
                                  image: AssetImage(
                                      "lib/images/inactiveSearch.png"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : RefreshIndicator(
                  onRefresh: () => _pr.getFeedScreenData(),
                  child: CustomScrollView(
                    controller: ScrollController(),
                    physics: ClampingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        flexibleSpace: Container(
                          decoration:
                              BoxDecoration(gradient: oldReverseColorGradient),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Komeet",
                              style: TextStyle(
                                fontFamily: "Lulo",
                                color: kBackgroundColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                Provider.of<ProfilBrainData>(context, listen: false)
                                    .listOfChatFriend();
                                Navigator.pushNamed(
                                    context, FriendsListChatScreen.id);
                              },
                              child: Icon(
                                Icons.email,
                                color: Provider.of<ProfilBrainData>(context)
                                        .newPrivateMessage
                                    ? Colors.red
                                    : kBackgroundColor,
                                size: 30.0,
                              ),
                            ),
                          ],
                        ),
                        elevation: 5.0,
                        pinned: false,
                        floating: true,
                        backgroundColor: kBackgroundColor,
                      ),
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return index == present - 1
                              ? FlatButton(
                                  child: Text(
                                    "Load More",
                                    style:
                                        TextStyle(fontSize: 18.0, color: kCTA),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      present = present + 10;
                                    });
                                  },
                                )
                              : _pr.missionsFeedList[index].isCompleted
                                  ? MissionCompletedPost(
                                      userEmail:
                                          _pr.missionsFeedList[index].userEmail,
                                      missionText: _pr
                                          .missionsFeedList[index].missionText,
                                      missionCategory: _pr
                                          .missionsFeedList[index]
                                          .missionCategory,
                                      userName:
                                          _pr.missionsFeedList[index].userName,
                                      profilPicture: _pr.missionsFeedList[index]
                                          .profilPicture,
                                      rank: _pr.missionsFeedList[index].rank,
                                      userText:
                                          _pr.missionsFeedList[index].userText,
                                      missionPicture: _pr
                                          .missionsFeedList[index]
                                          .missionPicture,
                                      missionDifficulty: _pr
                                          .missionsFeedList[index]
                                          .missionDifficulty,
                                      missionExp: _pr
                                          .missionsFeedList[index].missionExp
                                          .floor(),
                                      missionDeadline: _pr
                                          .missionsFeedList[index]
                                          .missionDeadline,
                                      missionReference: _pr
                                          .missionsFeedList[index]
                                          .missionReference,
                                    )
                                  : MissionFeedCurrent(
                                      userRank: int.parse(
                                          _pr.missionsFeedList[index].rank),
                                      missionExp: _pr
                                          .missionsFeedList[index].missionExp
                                          .floor(),
                                      date: _pr.missionsFeedList[index].date,
                                      missionReference: _pr
                                          .missionsFeedList[index]
                                          .missionReference,
                                      userText:
                                          _pr.missionsFeedList[index].userText,
                                      userName:
                                          _pr.missionsFeedList[index].userName,
                                      profilPicture: _pr.missionsFeedList[index]
                                          .profilPicture,
                                      missionCategory: _pr
                                          .missionsFeedList[index]
                                          .missionCategory,
                                      missionText: _pr
                                          .missionsFeedList[index].missionText,
                                      missionDeadline: _pr
                                          .missionsFeedList[index]
                                          .missionDeadline,
                                      missionDifficulty: _pr
                                          .missionsFeedList[index]
                                          .missionDifficulty,
                                    );
                        },
                        childCount: present > _pr.missionsFeedList.length
                            ? _pr.missionsFeedList.length
                            : present,
                      )),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: data.size.height / 12,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
