import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'profilBrainData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedData extends ChangeNotifier {
  static Firestore _fs = Firestore.instance;
  List<FeedMissions> missionsFeedList = [];
  bool getFeedScreenDataIsOver = true;
  String commentText;

  void getCommentText(String value) {
    commentText = value;
    notifyListeners();
  }

  Future getFeedScreenData() async {
    getFeedScreenDataIsOver = false;
    missionsFeedList.clear();
    print("SEARCHING FOR FEED DATA...");
    print("SEARCHING FOR  MY OWN FEED DATA...");
    var userMissionsCompleted = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("MissionsCompleted")
        .orderBy("completedTime", descending: true)
        .getDocuments();
    for (var missionCompleted in userMissionsCompleted.documents) {
      final String missionText = missionCompleted.data["missionText"];
      final String missionReference = missionCompleted.data["reference"];
      final String missionCategory = missionCompleted.data["missionCategory"];
      final int missionDifficulty = missionCompleted.data["missionDifficulty"];
      final int missionExp = missionCompleted.data["missionExp"];
      final String missionPicture = missionCompleted.data["missionPicture"];
      final Timestamp missionDeadline =
          missionCompleted.data["missionDeadline"];
      final String profilPicture = missionCompleted.data["profilPicture"];
      final String rank = missionCompleted.data["rank"].toString();
      final String userName = missionCompleted.data["userName"];
      final String userText = missionCompleted.data["userText"];
      final int date = missionCompleted.data["date"];
      missionsFeedList.add(FeedMissions(
          userEmail: currentUserEmail,
          isCompleted: true,
          missionReference: missionReference,
          missionText: missionText,
          missionCategory: missionCategory,
          userName: userName,
          profilPicture: profilPicture,
          rank: rank,
          userText: userText,
          missionPicture: missionPicture,
          missionDifficulty: missionDifficulty,
          missionExp: missionExp.toDouble(),
          date: date,
          missionDeadline: missionDeadline.toDate()));
    }
    var friends = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Friends")
        .getDocuments();
    print("SEARCHING FOR FRIENDS FEED DATA...");
    print("friends feed search: ${friends.documents.length}");
    if (friends.documents.length > 0) {
      for (var friend in friends.documents) {
        String friendName = friend.data["friendName"];
        String friendEmail = await ProfilBrainData().getEmail(friendName);
        print("Step 1: $friendName, $friendEmail");
        var missionsCompleted = await _fs
            .collection("Users")
            .document(friendEmail)
            .collection("MissionsCompleted")
            .orderBy("completedTime", descending: false)
            .getDocuments();
        for (var missionCompleted in missionsCompleted.documents) {
          final String missionText = missionCompleted.data["missionText"];
          final String missionCategory =
              missionCompleted.data["missionCategory"];
          final int missionDifficulty =
              missionCompleted.data["missionDifficulty"];
          final int missionExp = missionCompleted.data["missionExp"];
          final String missionPicture = missionCompleted.data["missionPicture"];
          final Timestamp missionDeadline =
              missionCompleted.data["missionDeadline"];
          final String profilPicture = missionCompleted.data["profilPicture"];
          final String rank = missionCompleted.data["rank"].toString();
          final String userName = missionCompleted.data["userName"];
          final String userText = missionCompleted.data["userText"];
          final int date = missionCompleted.data["date"];
          final String missionReference = missionCompleted.data["reference"];
          print("FRIEND COMPLETED MISSION ADDED");
          missionsFeedList.add(FeedMissions(
              userEmail: friendEmail,
              isCompleted: true,
              missionText: missionText,
              missionCategory: missionCategory,
              userName: userName,
              profilPicture: profilPicture,
              rank: rank,
              userText: userText,
              missionPicture: missionPicture,
              missionDifficulty: missionDifficulty,
              missionExp: missionExp.toDouble(),
              missionDeadline: missionDeadline.toDate(),
              date: date,
              missionReference: missionReference));
        }
        var currentMissions = await _fs
            .collection("Users")
            .document(friendEmail)
            .collection("Missions")
            .orderBy("date", descending: true)
            .getDocuments();
        for (var currentMission in currentMissions.documents) {
          String missionReference = currentMission.data["missionReference"];
          bool isPublic = currentMission.data["public"];

          if (missionReference.length > 8 && isPublic == true) {
            var mission = await _fs
                .collection("Missions")
                .document(missionReference)
                .get();
            String userEmail = mission.data["missionAdmin"];
            if (userEmail == friendEmail) {
              String missionText = mission.data["missionText"];
              String missionCategory = mission.data["missionCategory"];
              String userText;
              if (userEmail == friendEmail) {
                userText = "New mission created !";
              } else {
                userText = "Has joined the mission";
              }
              String profilPicture =
                  await ProfilBrainData().getProfilePicture(userEmail);
              String userName = await ProfilBrainData().getUserName(userEmail);
              int userRank = await ProfilBrainData().getUserRank(userEmail);
              int missionDifficulty = mission.data["missionDifficulty"];
              dynamic missionExp = mission.data["missionExp"];
              Timestamp missionDeadline = mission.data["missionDeadline"];
              int date = mission.data["date"];
              missionsFeedList.add(FeedMissions(
                  userEmail: userEmail,
                  missionText: missionText,
                  missionCategory: missionCategory,
                  userName: userName,
                  profilPicture: profilPicture,
                  rank: userRank.toString(),
                  userText: userText,
                  missionPicture: null,
                  missionDifficulty: missionDifficulty,
                  missionExp: missionExp.toDouble(),
                  missionDeadline: missionDeadline.toDate(),
                  missionReference: missionReference,
                  isCompleted: false,
                  date: date));
            }
          }
        }
        print("SEARCHING FEED DATA IS OVER");
        print("SEARCHING FEED DATA IS OVER");
        print(missionsFeedList.length);
        if (missionsFeedList.length > 1) {
          missionsFeedList.sort((a, b) => b.date.compareTo(a.date));
        }
        print("SEARCHING FEED DATA IS OVER");
        print("SEARCHING FEED DATA IS OVER");
        getFeedScreenDataIsOver = true;
        notifyListeners();
      }
    }else {
      print("SEARCHING FEED DATA IS OVER");
      print("SEARCHING FEED DATA IS OVER");
      print(missionsFeedList.length);
      if (missionsFeedList.length > 1) {
        missionsFeedList.sort((a, b) => b.date.compareTo(a.date));
      }
      print("SEARCHING FEED DATA IS OVER");
      print("SEARCHING FEED DATA IS OVER");
      getFeedScreenDataIsOver = true;
      notifyListeners();
    }
  }
}
