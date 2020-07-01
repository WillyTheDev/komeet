import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _fs = Firestore.instance;

class MissionData extends ChangeNotifier {
  String textMission;
  String categoryTitle = "Click here";
  List<Step> stepsList = [];
  int difficulty = 1;
  String reference;
  String userText;
  String missionPicture;
  bool isCommunity;
  bool newMissionMessage = false;
  bool lookForCommunityMission = false;
  QuerySnapshot currentMissionsData;
  List <QuerySnapshot> currentMissionsStepsData = [];

  String communityTitle;
  String communityDescription;
  String badgeLink;
  DateTime communityDeadline;
  int communityExp;
  bool loadingPostMissionImage = false;

  String missionMessage;

  bool privacy = true;
  String stepText;
  int exp;
  DateTime deadline = DateTime.now().add(Duration(days: 1));
  DateTime now = DateTime.now();
  bool firstMission;

  IconData categoryIcon = Icons.storage;
  Color categoryIconColor = Colors.tealAccent;
  String categorySubtitle =
      "Category will help you to get some badges or get friends easier";

  Future getCurrentMissionsData() async {
    currentMissionsData = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .getDocuments();
    notifyListeners();
  }

  Future <QuerySnapshot> getCurrentMissionsStepsData(String missionReference) async {
    QuerySnapshot stepsData = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions").document(missionReference).collection("Steps")
        .getDocuments();
    return stepsData;
  }

  void getLookForCommunity(bool value) {
    lookForCommunityMission = value;
    notifyListeners();
  }

  void getFirstMissionValue(bool value) {
    firstMission = value;
    notifyListeners();
  }

  void getLoadingPostMissionImage(bool value) {
    loadingPostMissionImage = value;
    notifyListeners();
  }

  void getExp(int expValue) {
    exp = expValue;
    notifyListeners();
  }

  int getExpValue() {
    int difference = deadline.difference(now).inDays;
    int numberOfStep = stepsList.length;
    !privacy
        ? difficulty == 1
            ? exp = (150 + (difference * 5) + (numberOfStep * 5))
            : difficulty == 2
                ? exp = (275 + (difference * 10) + (numberOfStep * 15))
                : exp = (400 + (difference * 15) + (numberOfStep * 20))
        : difficulty == 1
            ? exp = (125 + (difference * 10) + (numberOfStep * 5))
            : difficulty == 2
                ? exp = (275 + (difference * 15) + (numberOfStep * 15))
                : exp = (400 + (difference * 20) + (numberOfStep * 25));
    notifyListeners();
    return exp;
  }

  void getNewMissionMessage(bool value) {
    newMissionMessage = value;
    notifyListeners();
  }

  void getIsCommunity(bool value) {
    isCommunity = value;
    notifyListeners();
  }

  void getDeadline(DateTime deadLine) {
    deadline = deadLine;
    notifyListeners();
  }

  void getCommunityDeadline(DateTime deadLine) {
    communityDeadline = deadLine;
    notifyListeners();
  }

  void getCommunityTitle(String title) {
    communityTitle = title;
    notifyListeners();
  }

  void getCommunityDescription(String subtitle) {
    communityDescription = subtitle;
    notifyListeners();
  }

  void getCommunityExp(int value) {
    communityExp = value;
    notifyListeners();
  }

  void getCommunityBadgeLink(String value) {
    badgeLink = value;
    notifyListeners();
  }

  void getMissionPicture(String value) {
    missionPicture = value;
    notifyListeners();
  }

  void getCategoryIcon(IconData icon, Color iconColor) {
    categoryIcon = icon;
    categoryIconColor = iconColor;
    notifyListeners();
  }

  void getCategorySubtitle(String value) {
    categorySubtitle = value;
    notifyListeners();
  }

  void getMissionMessage(String value) {
    missionMessage = value;
    notifyListeners();
  }

  void getUserMissionText(String value) {
    userText = value;
    notifyListeners();
  }

  void getPrivacyMission(bool value) {
    privacy = value;
    notifyListeners();
  }

  void getDifficultyMission(int value) {
    difficulty = value;
    notifyListeners();
  }

  void getTextMission(String value) {
    textMission = value;
    notifyListeners();
  }

  void getExpMission(int value) {
    exp = value;
    notifyListeners();
  }

  void getReference(String value) {
    reference = value;
    notifyListeners();
  }

  void getCategoryMission(String value) {
    categoryTitle = value;
    notifyListeners();
  }

  void getStepText(String value) {
    stepText = value;
    notifyListeners();
  }

  void addStep() {
    stepsList.add(Step(text: stepText, index: stepsList.length + 1));
    notifyListeners();
  }

  void removeStep(int index) {
    stepsList.removeAt(index);
    notifyListeners();
  }

  void readAllMissionMessage(String chatReference) async {
    var messages = await _fs
        .collection("Missions")
        .document(chatReference)
        .collection("Chat")
        .getDocuments();
    for (var message in messages.documents) {
      if (message.data["email"] != currentUserEmail) {
        await message.reference.updateData({
          "read": true,
        });
      }

      newMissionMessage = false;
      notifyListeners();
    }
  }
}

class Step {
  Step({@required this.text, @required this.index});
  String text;
  final int index;
}
