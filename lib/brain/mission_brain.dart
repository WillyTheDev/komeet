import 'dart:io';
import 'dart:ui';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/MissionsData.dart' as M;
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Goals/category_screen.dart';
import 'package:Komeet/screens/Goals/create_community_mission.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:Komeet/screens/main/friend_profil_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import 'package:random_string/random_string.dart';

final Firestore _fs = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();

class MissionBrain {
  Future getImage(missionText) async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("upload image for $missionText");
    print("$_image");
    String fileName = basename(_image.path);
    print("filename = ${_image.path}");

    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    print("image set in  document");
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionText)
        .updateData({
      "missionPicture": url,
    });
    print("Upload over !");
  }

  IconData missionCategoryIcon(String category) {
    if (category == "Single Task") {
      return Icons.calendar_today;
    } else if (category == "Stay fit") {
      return Icons.directions_run;
    } else if (category == "Social") {
      return Icons.mode_comment;
    } else if (category == "Read") {
      return Icons.free_breakfast;
    } else if (category == "Discover & learn") {
      return Icons.laptop_chromebook;
    } else if (category == "Gift & present") {
      return Icons.card_giftcard;
    } else if (category == "Self Awareness") {
      return Icons.person;
    } else if (category == "Food") {
      return Icons.fastfood;
    } else if (category == "RelationShip") {
      return Icons.favorite;
    } else if (category == "Family") {
      return Icons.people;
    } else if (category == "Personnal Finance") {
      return Icons.euro_symbol;
    }
    return null;
  }

  Color missionCategoryIconColor(String category) {
    if (category == "Single Task") {
      return Colors.blue;
    } else if (category == "Stay fit") {
      return Colors.red;
    } else if (category == "Social") {
      return Colors.amber;
    } else if (category == "Read") {
      return Colors.brown;
    } else if (category == "Discover & learn") {
      return Colors.lightBlueAccent;
    } else if (category == "Gift & present") {
      return Colors.greenAccent;
    } else if (category == "Self Awareness") {
      return Colors.orange;
    } else if (category == "Food") {
      return Colors.deepPurple;
    } else if (category == "RelationShip") {
      return Colors.purpleAccent;
    } else if (category == "Family") {
      return Colors.yellow;
    } else if (category == "Personnal Finance") {
      return Colors.lightGreenAccent;
    }
    return null;
  }

  Future<int> getUserStepIndex(String missionText) async {
    DocumentSnapshot missionData = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionText)
        .get();
    return missionData.data["userStepIndex"];
  }

  Future<String> getMissionText(String reference) async {
    DocumentSnapshot missionData =
        await _fs.collection("Missions").document(reference).get();
    return missionData.data["missionText"];
  }

  Future sendMissionInvitation(
      String friendEmail, String missionReference, String missionText) async {
    String userName = await ProfilBrainData().getUserName(currentUserEmail);
    String profilePicture =
        await ProfilBrainData().getProfilePicture(currentUserEmail);
    _fs
        .collection("Users")
        .document(friendEmail)
        .collection("MissionsRequest")
        .document(missionText)
        .setData({
      "reference": missionReference,
      "userName": userName,
      "profilPicture": profilePicture,
      "email": currentUserEmail,
    });
  } //

  Future sendMissionMessage(
      String reference, String missionMessage, String userName) async {
    bool isCommunity;
    int rank = await ProfilBrainData().getUserRank(currentUserEmail);
    if (reference.length > 8) {
      isCommunity = false;
    } else {
      isCommunity = true;
    }
    print("SEND MESSAGE !$reference, $missionMessage ,$userName");
    _fs
        .collection(isCommunity ? "CommunityMissions" : "Missions")
        .document(reference)
        .collection("Chat")
        .document()
        .setData({
      "read": false,
      "text": missionMessage,
      "sender": userName,
      "image": "",
      "date": DateTime.now().millisecondsSinceEpoch,
      "reference": reference,
      "email": currentUserEmail,
      "rank": rank,
    });
  }

  Future<String> getBadgeLink(String reference) async {
    DocumentSnapshot missionData =
        await _fs.collection("CommunityMissions").document(reference).get();
    return missionData.data["missionReward"];
  }

  void rejectMissionRequest(String reference) async {
    print("Reject Mission Request");
    QuerySnapshot requests = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("MissionsRequest")
        .getDocuments();
    for (var request in requests.documents) {
      if (request.data["reference"] == reference) {
        print("document = ${request.reference.documentID}");
        request.reference.delete();
      }
    }
  }

  void removeMission(String reference, bool public, String missionText) async {
    bool isCommunity;
    if (reference.length > 8) {
      isCommunity = false;
    } else {
      isCommunity = true;
    }
    if (public) {
      if (isCommunity == true) {
        await _fs
            .collection("CommunityMissions")
            .document(reference)
            .updateData({
          "usersSubscribed": await MissionBrain()
                  .getMissionSubscribed(reference, isCommunity) -
              1,
        });
        _fs
            .collection("Users")
            .document(currentUserEmail)
            .collection("Missions")
            .document(missionText)
            .delete();
        _fcm.unsubscribeFromTopic(reference);
        return;
      }
      print("Removing MISSION");
      print("Removing MISSION1");
      print("Removing MISSION2");
      print("Removing MISSION3");
      print("Removing MISSION4");
      QuerySnapshot stepsList = await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .getDocuments();
      print("stepList = $stepsList");
      for (var step in stepsList.documents) {
        print("reference  of step = ${step.reference}");
        print("document id of step = ${step.documentID}");
        step.reference.delete();
      }
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .delete();
      _fcm.unsubscribeFromTopic(reference);
      _fs
          .collection("Missions")
          .document(reference)
          .collection("Subscribers")
          .document(currentUserEmail)
          .delete();
      _fs.collection("Missions").document(reference).updateData({
        "usersSubscribed":
            await MissionBrain().getMissionSubscribed(reference, isCommunity) -
                1
      });
      if (await MissionBrain().getMissionSubscribed(reference, isCommunity) ==
          0) {
        _fs.collection("Missions").document(reference).delete();
        await _fs
            .collection("Missions")
            .document(reference)
            .collection("Chat")
            .getDocuments()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.documents) {
            ds.reference.delete();
          }
        });
        await _fs.collection("Missions").document(reference).delete();
      }
    } else {
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .collection("Steps")
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          print("document reference = ${ds.reference}");
          ds.reference.delete();
        }
      });
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .delete();
    }
    _fcm.unsubscribeFromTopic(reference);
  }

  Future completeMission(
    String reference,
    String missionPicture,
    bool public,
    String userText,
    String missionText,
    int missionExp,
    String missionCategory,
    DateTime deadline,
    int missionDifficulty,
    DateTime dayOfCompleted,
  ) async {
    bool isCommunity;
    if (reference.length > 8) {
      isCommunity = false;
    } else {
      isCommunity = true;
    }
    _fcm.unsubscribeFromTopic(reference);
    if (public) {
      _fs.collection("Users").document(currentUserEmail).updateData({
        "CurrentMission": await ProfilBrainData()
                .getCurrentMissionLengthToString(currentUserEmail) -
            1,
        "userExp": await ProfilBrainData().getUserExp() + missionExp,
        "missionCompleted":
            await ProfilBrainData().getUserMissionCompleted() + 1
      });
      await _fs
          .collection(isCommunity ? "CommunityMissions" : "Missions")
          .document(reference)
          .updateData({
        "usersSubscribed":
            await MissionBrain().getMissionSubscribed(reference, isCommunity) -
                1
      });
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });

      if (isCommunity == true) {
        _fs
            .collection("Users")
            .document(currentUserEmail)
            .collection("Badges")
            .document(missionText)
            .setData({
          "imageLink": await getBadgeLink(reference),
          "description": missionText,
        });
      }

      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("MissionsCompleted")
          .document(missionText)
          .setData({
        "userName": await ProfilBrainData().getUserName(currentUserEmail),
        "rank": await ProfilBrainData().getUserRank(currentUserEmail),
        "profilPicture":
            await ProfilBrainData().getProfilePicture(currentUserEmail),
        "missionText": missionText,
        "missionCategory": missionCategory,
        "missionDeadline": deadline,
        "missionExp": missionExp,
        "missionDifficulty": missionDifficulty,
        "missionPicture": missionPicture,
        "userText": userText,
        "completedTime": dayOfCompleted,
        "reference": reference,
        "date": DateTime.now().millisecondsSinceEpoch,
      });
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .delete();
      _fs
          .collection("Missions")
          .document(reference)
          .collection("Subscribers")
          .document(currentUserEmail)
          .delete();
      if (await MissionBrain().getMissionSubscribed(reference, isCommunity) ==
          0) {
        var chatMessages = await _fs
            .collection("Missions")
            .document(reference)
            .collection("Chat")
            .getDocuments();
        for (var document in chatMessages.documents) {
          await document.reference.delete();
        }
        _fs.collection("Missions").document(reference).delete();
      }
    } else {
      int currentMission = await ProfilBrainData()
          .getCurrentMissionLengthToString(currentUserEmail);
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .collection("Steps")
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
      _fcm.unsubscribeFromTopic(reference);
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .delete();
      _fs.collection("Users").document(currentUserEmail).updateData({
        "userExp": await ProfilBrainData().getUserExp() + missionExp,
        "missionCompleted":
            await ProfilBrainData().getUserMissionCompleted() + 1,
        "currentMission": currentMission - 1
      });
    }
  }

  void addCommunityMissionToDatabase(
      String title,
      String subTitle,
      String reward,
      int exp,
      DateTime deadline,
      int difficulty,
      String category) async {
    String reference = randomAlphaNumeric(8);
    await _fs.collection("CommunityMissions").document(reference).setData({
      "missionTitle": title,
      "missionSubtitle": subTitle,
      "missionReward": reward,
      "missionAdmin": currentUserEmail,
      "missionDifficulty": difficulty,
      "missionCategory": category,
      "missionDeadline": deadline,
      "missionExp": exp,
      "date": DateTime.now().millisecondsSinceEpoch,
      "missionReference": reference,
      "usersSubscribed": 0,
    });
  }

  void addCommunityMission(String reference, String missionTitle) async {
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionTitle)
        .setData({
      "missionReference": reference,
    });
    await _fs
        .collection("CommunityMissions")
        .document(reference)
        .collection("Subscribers")
        .document(currentUserEmail)
        .setData({
      "userName": await ProfilBrainData().getUserName(currentUserEmail),
      "profilPicture":
          await ProfilBrainData().getProfilePicture(currentUserEmail),
    });
    await _fs.collection("CommunityMissions").document(reference).updateData({
      "usersSubscribed":
          await MissionBrain().getCommunityMissionSubscribed(reference) + 1,
    });
    _fs.collection("Users").document(currentUserEmail).updateData({
      "currentMission": await ProfilBrainData()
              .getCurrentMissionLengthToString(currentUserEmail) +
          1,
    });
  }

  void addMission(
    String missionText,
    String reference,
    String userName,
    String profilPicture,
  ) async {
    bool isCommunity;
    if (reference.length > 8) {
      isCommunity = false;
    } else {
      isCommunity = true;
    }
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionText)
        .setData({
      "missionReference": reference,
      "public": true,
      "date": DateTime.now().millisecondsSinceEpoch
    });
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionText)
        .collection("Steps")
        .document("actualIndex")
        .setData({
      "actualIndex": 0,
    });
    await _fs
        .collection("Missions")
        .document(reference)
        .collection("Subscribers")
        .document(currentUserEmail)
        .setData({
      "userName": userName,
      "profilPicture": profilPicture,
      "userStepIndex": 0,
    });
    _fcm.subscribeToTopic(reference);
    _fs.collection("Missions").document(reference).updateData({
      "currentMission": await ProfilBrainData()
              .getCurrentMissionLengthToString(currentUserEmail) +
          1,
      "usersSubscribed":
          await MissionBrain().getMissionSubscribed(reference, isCommunity) + 1,
    });
  }

  void restartStep(String missionText, String reference, bool public) async {
    print("$missionText, $reference $public");
    if (public == true) {
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document("actualIndex")
          .updateData({
        "actualIndex": 0,
      });
    } else {
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .collection("Steps")
          .document("actualIndex")
          .updateData({
        "actualIndex": 0,
      });
    }
  }

  void completeStep(String missionText, String reference, bool public) async {
    print("$missionText, $reference $public");
    int actualIndex;
    int userExp = await ProfilBrainData().getUserExp();
    if (public == true) {
      var stepData = await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document("actualIndex")
          .get();
      actualIndex = stepData.data["actualIndex"];
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document("actualIndex")
          .updateData({
        "actualIndex": actualIndex + 1,
      });
      _fs.collection("Users").document(currentUserEmail).updateData({
        "userExp": userExp + 50,
      });
    } else {
      var stepData = await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .collection("Steps")
          .document("actualIndex")
          .get();
      actualIndex = stepData.data["actualIndex"];
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .collection("Steps")
          .document("actualIndex")
          .updateData({
        "actualIndex": actualIndex + 1,
      });
    }
  }

  Future addStepToDatabase(List<M.Step> stepsList, String missionText) async {
    QuerySnapshot steps = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionText)
        .collection("Steps")
        .getDocuments();
    if (steps.documents.length == 1) {
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document("actualIndex")
          .updateData({
        "actualIndex": 0,
      });
    } else {
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document("actualIndex")
          .updateData({
        "actualIndex": steps.documents.length - 1,
      });
    }
    for (var step in stepsList) {
      int index = steps.documents.length + step.index - 1;
      await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document(index.toString())
          .setData({
        "stepName": step.text,
        "stepIndex": step.index,
      });
    }
  }

  Future addMissionToDatabase(
      String missionText,
      String missionCategory,
      List<M.Step> stepsList,
      int difficulty,
      bool public,
      String userName,
      DateTime deadline,
      int exp) async {
    String reference = randomAlphaNumeric(16);
    print("AddMissiontoDatabase!");
    print(public);
    _fcm.subscribeToTopic(reference);
    if (public == true) {
      await _fs.collection("Missions").document(reference).setData({
        "missionText": missionText,
        "missionAdmin": currentUserEmail,
        "missionDifficulty": difficulty,
        "missionCategory": missionCategory,
        "missionDeadline": deadline,
        "missionExp": exp,
        "missionReference": reference,
        "usersSubscribed": 1,
        "date": DateTime.now().millisecondsSinceEpoch,
        "outDated": false,
      });
      _fs.collection("Users").document(currentUserEmail).updateData({
        "currentMission": await ProfilBrainData()
                .getCurrentMissionLengthToString(currentUserEmail) +
            1,
      });
      await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .setData({
        "missionReference": reference,
        "public": true,
        "date": DateTime.now().millisecondsSinceEpoch
      });
      await _fs
          .collection("Missions")
          .document(reference)
          .collection("Subscribers")
          .document(currentUserEmail)
          .setData({
        "userName": userName,
        "profilPicture":
            await ProfilBrainData().getProfilePicture(currentUserEmail),
      });
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(missionText)
          .collection("Steps")
          .document("actualIndex")
          .setData({
        "actualIndex": 0,
      });
      for (var step in stepsList) {
        await _fs
            .collection("Users")
            .document(currentUserEmail)
            .collection("Missions")
            .document(missionText)
            .collection("Steps")
            .document(step.index.toString())
            .setData({
          "stepName": step.text,
          "stepIndex": step.index,
        });
      }
    } else {
      _fs.collection("Users").document(currentUserEmail).updateData({
        "currentMission": await ProfilBrainData()
                .getCurrentMissionLengthToString(currentUserEmail) +
            1,
      });
      await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .setData({
        "missionText": missionText,
        "missionAdmin": currentUserEmail,
        "missionDifficulty": difficulty,
        "missionCategory": missionCategory,
        "missionDeadline": deadline,
        "missionExp": exp,
        "missionReference": reference,
        "public": false,
        "date": DateTime.now().millisecondsSinceEpoch,
        "outDated": false,
      });
      _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Missions")
          .document(reference)
          .collection("Steps")
          .document("actualIndex")
          .setData({
        "actualIndex": 0,
      });
      for (var step in stepsList) {
        await _fs
            .collection("Users")
            .document(currentUserEmail)
            .collection("Missions")
            .document(reference)
            .collection("Steps")
            .document(step.index.toString())
            .setData({
          "stepName": step.text,
          "stepIndex": step.index,
        });
      }
    }
  }

  Future<int> getMissionSubscribed(String reference, bool isCommunity) async {
    QuerySnapshot missionData = await _fs
        .collection(isCommunity ? "CommunityMissions" : "Missions")
        .document(reference)
        .collection("Subscribers")
        .getDocuments();
    return missionData.documents.length;
  }

  Future<int> getCommunityMissionSubscribed(String reference) async {
    DocumentSnapshot missionData =
        await _fs.collection("CommunityMissions").document(reference).get();
    return missionData.data["usersSubscribed"];
  }

  Future<String> getMissionPicture(String missionText) async {
    DocumentSnapshot missionData = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Missions")
        .document(missionText)
        .get();
    return missionData["missionPicture"];
  }

  void adminKeyGenerate() {
    _fs.collection("AdminKey").document("Key").setData({
      "Key": randomAlphaNumeric(16),
    });
  }

  void checkAdminKeyValidity(String value, BuildContext context) async {
    var key = await _fs.collection("AdminKey").document("Key").get();
    if (value == key.data["Key"]) {
      Navigator.pushNamed(context, CreateCommunityMission.id);
    } else {
      print("Admin password incorrect !");
      return null;
    }
  }

  Future getImageInChat(
      String username, String friendName, String reference) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    uploadImageInChat(image, username, reference);
  }

  Future uploadImageInChat(
      File image, String userName, String missionReference) async {
    bool isCommunity;
    if (missionReference.length > 8) {
      isCommunity = false;
    } else {
      isCommunity = true;
    }
    print("upload image for $userName");
    String fileName = basename(image.path);
    int rank = await ProfilBrainData().getUserRank(currentUserEmail);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    _fs
        .collection(isCommunity ? "CommunityMissions" : "Missions")
        .document(missionReference)
        .collection("Chat")
        .document()
        .setData({
      "email": currentUserEmail,
      "read": false,
      "sender": userName,
      "text": "",
      "image": url,
      "date": DateTime.now().millisecondsSinceEpoch,
      "rank": rank,
    });
  }

  Future showMissionBubble(BuildContext context, String missionReference,
      String missionText, String missionCategory, bool isCommunity) async {
    final user = MediaQuery.of(context);
    print("Mission Bubble Open !");
    List<Widget> userSubscribed = [];
    var users = await _fs
        .collection(isCommunity ? "CommunityMissions" : "Missions")
        .document(missionReference)
        .collection("Subscribers")
        .getDocuments();
    for (var user in users.documents) {
      print("${user.documentID}");
      String userName;
      await user.data["userName"] == null
          ? userName = await user.data["username"]
          : userName = await user.data["userName"];
      print(userName);
      String profilPicture = user.data["profilPicture"];
      userSubscribed.add(Container(
        child: GestureDetector(
          onTap: () async {
            Provider.of<ProfilBrainData>(context).getEmail(userName);
            Provider.of<ProfilBrainData>(context).getMissionsCompletedList(
                await ProfilBrainData().getEmail(userName));
            Provider.of<ProfilBrainData>(context)
                .getBadgeList(await ProfilBrainData().getEmail(userName));
            Provider.of<ProfilBrainData>(context).isAlreadyFriend(userName);
            Navigator.pushNamed(context, FriendProfilScreen.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: profilPicture != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(profilPicture),
                        )
                      : StreamBuilder<DocumentSnapshot>(
                          stream: _fs
                              .collection("Users")
                              .document(user.documentID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                width: 35.0,
                                height: 35.0,
                                child: Avatar(
                                  clotheColor: 1,
                                  bodyType: "male",
                                  background: 2,
                                  bodyColor: 2,
                                  hairStyle: 3,
                                  hairColor: 2,
                                ),
                              );
                            }
                            var user = snapshot.data["Avatar"];
                            print(
                                "bodyType: ${user["avatarType"]} background: ${user["backgroundColor"]},");
                            return Container(
                              width: 35.0,
                              height: 35.0,
                              child: Avatar(
                                clotheColor: user["clotheColor"],
                                bodyType: user["avatarType"],
                                background: user["backgroundColor"],
                                bodyColor: user["bodyColor"],
                                hairStyle: user["hairStyle"],
                                hairColor: user["hairColor"],
                              ),
                            );
                          }),
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                      MissionBrain().missionCategoryIcon(missionCategory),
                      size: 30.0,
                      color: MissionBrain()
                          .missionCategoryIconColor(missionCategory)),
                ),
                Flexible(child: Text(missionText)),
              ],
            ),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: user.size.width / 1.4,
                    height: user.size.height / 2,
                    child: ListView(
                      children: userSubscribed,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future showMissionLike(
    BuildContext context,
    String userEmail,
    String missionText,
  ) async {
    final data = MediaQuery.of(context);
    print("Like Bubble Open !");
    List<Widget> usersLike = [];
    var users = await _fs
        .collection("Users")
        .document(userEmail)
        .collection("MissionsCompleted")
        .document(missionText)
        .collection("Like")
        .getDocuments();
    for (var user in users.documents) {
      print("${user.documentID}");
      String userName;
      await user.data["userName"] == null
          ? userName = await user.data["username"]
          : userName = await user.data["userName"];
      print(userName);
      String profilPicture = user.data["profilPicture"];
      usersLike.add(Container(
        child: GestureDetector(
          onTap: () async {
            Provider.of<ProfilBrainData>(context).getEmail(userName);
            Provider.of<ProfilBrainData>(context).getMissionsCompletedList(
                await ProfilBrainData().getEmail(userName));
            Provider.of<ProfilBrainData>(context)
                .getBadgeList(await ProfilBrainData().getEmail(userName));
            Provider.of<ProfilBrainData>(context).isAlreadyFriend(userName);
            Navigator.pushNamed(context, FriendProfilScreen.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profilPicture),
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.favorite, size: 30.0, color: Colors.red),
                ),
                Flexible(child: Text(missionText)),
              ],
            ),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: data.size.width / 1.4,
                    height: data.size.height / 2,
                    child: ListView(
                      children: usersLike,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  Future likeCompletedMission(String missionText, String userName) async {
    print("likeCompletedMission");
    String userEmail = await ProfilBrainData().getEmail(userName);
    print("likeCompletedMission email == $userEmail");
    var usersLikes = await _fs
        .collection("Users")
        .document(userEmail)
        .collection("MissionsCompleted")
        .document(missionText)
        .collection("Like")
        .getDocuments();
    if (usersLikes.documents.length == 0) {
      int rank = await ProfilBrainData().getUserRank(currentUserEmail);
      String myUserName = await ProfilBrainData().getUserName(currentUserEmail);
      String profilPicture =
          await ProfilBrainData().getProfilePicture(currentUserEmail);
      _fs
          .collection("Users")
          .document(userEmail)
          .collection("MissionsCompleted")
          .document(missionText)
          .collection("Like")
          .document(currentUserEmail)
          .setData({
        "email": currentUserEmail,
        "rank": rank,
        "userName": myUserName,
        "profilPicture": profilPicture,
      });
    }
    for (var user in usersLikes.documents) {
      if (user.data["email"] == currentUserEmail) {
        print("likeCompletedMission == AlreadyLike");
        _fs
            .collection("Users")
            .document(userEmail)
            .collection("MissionsCompleted")
            .document(missionText)
            .collection("Like")
            .document(currentUserEmail)
            .delete();
        return;
      } else {
        print("likeCompletedMission == NotLike");
        int rank = await ProfilBrainData().getUserRank(currentUserEmail);
        String myUserName =
            await ProfilBrainData().getUserName(currentUserEmail);
        _fs
            .collection("Users")
            .document(userEmail)
            .collection("MissionsCompleted")
            .document(missionText)
            .collection("Like")
            .document(currentUserEmail)
            .setData({
          "email": currentUserEmail,
          "rank": rank,
          "userName": myUserName,
        });
      }
    }
  }
}

class CategoryList {
  List<CategoryContainer> listOfCategory = [
    CategoryContainer(
      title: "All",
      subtitle: "Every Category",
      icon: Icons.all_inclusive,
      iconColor: Colors.purpleAccent,
    ),
    CategoryContainer(
      title: "Single Task",
      subtitle: "get works done !",
      icon: Icons.calendar_today,
      iconColor: Colors.blue,
    ),
    CategoryContainer(
      title: "Stay fit",
      subtitle: "feel Better, get Stronger",
      icon: Icons.directions_run,
      iconColor: Colors.red,
    ),
    CategoryContainer(
      title: "Social",
      subtitle: "Find new friends",
      icon: Icons.mode_comment,
      iconColor: Colors.amber,
    ),
    CategoryContainer(
      title: "Read",
      subtitle: "Lost yourself in books",
      icon: Icons.free_breakfast,
      iconColor: Colors.brown,
    ),
    CategoryContainer(
      title: "Discover & learn",
      subtitle: "Keep Learning things",
      icon: Icons.laptop_chromebook,
      iconColor: Colors.lightBlueAccent,
    ),
    CategoryContainer(
      title: "Gift & present",
      subtitle: "bring joy & happiness around you",
      icon: Icons.card_giftcard,
      iconColor: Colors.greenAccent,
    ),
    CategoryContainer(
      title: "Self Awareness",
      subtitle: "Be open-minded and look for new things",
      icon: Icons.person,
      iconColor: Colors.orange,
    ),
    CategoryContainer(
      title: "food",
      subtitle: "Eat better & get healthier",
      icon: Icons.fastfood,
      iconColor: Colors.deepPurple,
    ),
    CategoryContainer(
      title: "RelationShip",
      subtitle: "Improve your relationship",
      icon: Icons.favorite,
      iconColor: Colors.purpleAccent,
    ),
    CategoryContainer(
      title: "Family",
      subtitle: "Spend Times with your loves one",
      icon: Icons.people,
      iconColor: Colors.yellow,
    ),
    CategoryContainer(
      title: "Personnal Finance",
      subtitle: "Control your budget",
      icon: Icons.euro_symbol,
      iconColor: Colors.lightGreenAccent,
    ),
  ];
}
