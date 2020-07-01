import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchAutoData extends ChangeNotifier {
  final Firestore _fs = Firestore.instance;
  String section = "Users";
  List<ProfilResult> profilList = [];
  List<ProfilResult> resultProfilList = [];
  List<MissionResult> resultMissionList = [];
  String search = "";
  String searchCategory = "All";

  void getSearch(value) {
    search = value;
    giveSuggestion(search, section);
    notifyListeners();
  }

  void getSearchCategory(String category) {
    searchCategory = category;
    notifyListeners();
    giveSuggestion(search, section);
  }

  void getSection(String value) {
    section = value;
    giveSuggestion(search, section);
    notifyListeners();
  }

  Future<bool> isItFriend(String username) async {
    print("ISITFRIEND? RESULTNAME $username");
    try {
      var friendData = await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Friends")
          .document(username).get();
      if (friendData.data["friendName"] == username) {
        print("Friend Found !");
        return true;
      } else {
        print("not a friend");
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future giveSuggestion(String search, String section) async {
    resultProfilList.clear();
    resultMissionList.clear();
    if (section == "Users") {
      QuerySnapshot users = await _fs.collection("Users").getDocuments();
      for (var user in users.documents) {
        String resultUserName = user.data["userName"];
        String resultUserEmail = await user.data["email"];
        if (resultUserName.toLowerCase().contains(search.toLowerCase()) &&
            resultUserEmail != currentUserEmail) {
          print("$resultUserName contains $search !");
          String searchUserName = user.data["userName"];
          bool isFriend = await isItFriend(searchUserName);
          String searchUserRank = user.data["rank"].toString();
          String searchUserFriends = user.data["friends"].toString();
          String searchUserMissionCompleted =
              user.data["missionCompleted"].toString();
          String profilPicture = user.data["profilPicture"];
          print("$searchUserName is friend ? $isFriend");
          String chatReference = "ChatReference";
          if (isFriend == true) {
            chatReference =
                await ProfilBrainData().getChatReference(searchUserName);
          }
          resultProfilList.add(ProfilResult(
            isFriend: isFriend,
            profilPicture: profilPicture,
            username: searchUserName,
            userRank: searchUserRank,
            userFriends: searchUserFriends,
            userMissions: searchUserMissionCompleted,
            userEmail: resultUserEmail,
            chatReference: chatReference,
          ));
          notifyListeners();
        }
        notifyListeners();
      }
    } else if (section == "Missions") {
      print(" Search value is $search");
      await for (var snapshot in _fs
          .collection("Missions")
          .orderBy("usersSubscribed", descending: true)
          .snapshots()) {
        for (var mission in snapshot.documents) {
          print(snapshot.documents.length);
          print("reference mission= ${mission.data["missionReference"]}");
          print("text mission= ${mission.data["missionText"]}");
          String missionText = await mission.data["missionText"];
          String missionAdmin = await mission.data["missionAdmin"];
          print(missionText);
          if (missionText.toLowerCase().contains(search.toLowerCase()) &&
              missionAdmin != currentUserEmail) {
            var _m = mission.data;
            print("$missionText contains $search");
            String missionCategory = _m["missionCategory"];
            if (searchCategory == "All") {
              Timestamp deadline = _m["missionDeadline"];
              int missionDifficulty = _m["missionDifficulty"];
              dynamic missionExp = _m["missionExp"];
              String missionReference = _m["missionReference"];
              int usersSubscribed = _m["usersSubscribed"];
              resultMissionList.add(MissionResult(
                  missionAdmin: missionAdmin,
                  missionText: missionText,
                  missionDifficulty: missionDifficulty,
                  missionReference: missionReference,
                  missionExp: missionExp.toDouble(),
                  missionCategory: missionCategory,
                  deadline: deadline.toDate(),
                  userSubscribed: usersSubscribed));
              notifyListeners();
            } else if (missionCategory == searchCategory) {
              Timestamp deadline = _m["missionDeadline"];
              int missionDifficulty = _m["missionDifficulty"];
              dynamic missionExp = _m["missionExp"];
              String missionReference = _m["missionReference"];
              int usersSubscribed = _m["usersSubscribed"];
              resultMissionList.add(MissionResult(
                  missionAdmin: missionAdmin,
                  missionText: missionText,
                  missionDifficulty: missionDifficulty,
                  missionReference: missionReference,
                  missionExp: missionExp.toDouble(),
                  missionCategory: missionCategory,
                  deadline: deadline.toDate(),
                  userSubscribed: usersSubscribed));
              notifyListeners();
            }
          }
          notifyListeners();
        }
      }
    }
  }
}

class ProfilResult {
  bool isFriend;
  String chatReference;
  String username;
  String userRank;
  String userFriends;
  String userMissions;
  String profilPicture;
  String userEmail;
  ProfilResult(
      {@required this.username,
      @required this.profilPicture,
      @required this.userRank,
      @required this.userFriends,
      @required this.userMissions,
      @required this.userEmail,
      @required this.isFriend,
      @required this.chatReference});
}

class MissionResult {
  final String missionAdmin;
  final String missionCategory;
  final DateTime deadline;
  final int missionDifficulty;
  final double missionExp;
  final String missionText;
  final String missionReference;
  final int userSubscribed;
  MissionResult(
      {@required this.missionAdmin,
      @required this.userSubscribed,
      @required this.missionText,
      @required this.missionDifficulty,
      @required this.missionReference,
      @required this.missionExp,
      @required this.missionCategory,
      @required this.deadline});
}

class ChatFriend {
  String profilPicture;
  String username;
  ChatFriend({@required this.profilPicture, @required this.username});
}
