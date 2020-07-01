import 'dart:io';

import 'package:Komeet/provider/SearchAutoData.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();

class ProfilBrainData extends ChangeNotifier {
  ProfilBrainData() {
    if (currentUserEmail != null) {
      getUserName(currentUserEmail);
      getProfilePicture(currentUserEmail);
      getProfilInitialData();
      getMissionsCompletedList(currentUserEmail);
      getBadgeList(currentUserEmail);
    }
  }

  static Firestore _fs = Firestore.instance;
  List<ChatFriend> chatFriendsList = [];
  List<ResultProfil> friendsList = [];
  List<FeedMissions> missionsCompletedList = [];
  List<Badge> userBadgeList = [];
  DocumentSnapshot profilData;

  Map avatar = {};
  String avatarType = "male";
  int bodyColor = 2;
  int hairStyle = 1;
  int hairColor = 4;
  int avatarColorBackground = 1;
  int clotheColor = 1;

  int newFriendsRequest = 0;
  int newMissionsRequest = 0;

  FirebaseUser loggedInUser;
  String currentFriend;
  String privateMessage;
  String userName;
  String profilPicture;
  String email;
  int myRank;
  bool isLoadingImage = false;
  bool isFriend = false;
  bool friendRequestAlreadySend = false;
  String privateChatReference;
  bool newRequest = false;
  bool newPrivateMessage = false;
  String goalText;
  bool haveFriends;

  Future getNewFriendsRequest() async {
    QuerySnapshot friendsRequest = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("FriendsRequest")
        .getDocuments();
    newFriendsRequest = friendsRequest.documents.length;
    notifyListeners();
  }

  Future getNewMissionsRequest() async {
    QuerySnapshot missionsRequest = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("MissionsRequest")
        .getDocuments();
    newMissionsRequest = missionsRequest.documents.length;
    notifyListeners();
  }

  Future getProfilInitialData() async {
    profilData = await _fs.collection("Users").document(currentUserEmail).get();
    print(profilData.data["Avatar"]);
    notifyListeners();
  }

  void getAvatarType(String value) {
    avatarType = value;
    notifyListeners();
  }

  void getMyRank(int value) {
    myRank = value;
    notifyListeners();
  }

  void getAvatarColorBackground(int value) {
    avatarColorBackground = value;
    notifyListeners();
  }

  void getBodyColor(int value) {
    bodyColor = value;
    notifyListeners();
  }

  void getClotheColor(int value) {
    clotheColor = value;
    notifyListeners();
  }

  void getHairStyle(int value) {
    hairStyle = value;
    notifyListeners();
  }

  void getHairColor(int value) {
    hairColor = value;
    notifyListeners();
  }

  void getGoalText(String value) {
    goalText = value;
    notifyListeners();
  }

  Future defineAvatar(String avatarType, int bodyColor, int hairStyle,
      int hairColor, int avatarColorBackground, int clotheColor) async {
    Map avatar = {
      "avatarType": avatarType,
      "bodyColor": bodyColor,
      "hairStyle": hairStyle,
      "hairColor": hairColor,
      "clotheColor": clotheColor,
      "backgroundColor": avatarColorBackground
    };
    await _fs.collection("Users").document(currentUserEmail).updateData({
      "Avatar": avatar,
      "profilPicture": null,
    });
  }

  Future getImage(username) async {
    isLoadingImage = true;
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    uploadImage(image, username);
  }

  Future getImageInChat(String username, String friendName) async {
    isLoadingImage = true;
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    uploadImageInChat(image, username, friendName);
  }

  Future<bool> checkPremiumStatus(String email) async {
    var user = await _fs.collection("Users").document(email).get();
    if (user.data["premium"] > 0) {
      print("Account without ad !");
      return true;
    } else {
      print("Account free with ad !");
      return false;
    }
  }

  Future<int> getCurrentMissionLengthToString(String email) async {
    var missions = await _fs
        .collection("Users")
        .document(email)
        .collection("Missions")
        .getDocuments();
    return missions.documents.length;
  }

  Future finishTutorial() async {
    _fs
        .collection("Users")
        .document(currentUserEmail)
        .updateData({"tutorialIsOver": true});
  }

  Future<String> getCurrentUserEmail() async {
    print("getCurrentuser launched  !");
    try {
      final user = await _auth.currentUser();
      final googleAccount = GoogleSignIn().currentUser;
      if (user != null) {
        currentUserEmail = user.email;
        return currentUserEmail;
      } else if (googleAccount != null) {
        currentUserEmail = googleAccount.email;
        print("google : $currentUserEmail");
        return currentUserEmail;
      } else {
        return "Undefined";
      }
    } catch (e) {
      print(e);
      return "Undefined";
    }
  }

  Future<String> getChatReference(String friendName) async {
    print("GET CHAT REFERENCE FOR $friendName");
    var chatData = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Friends")
        .document(friendName)
        .get();
    if (chatData.data["chatReference"] == null) {
      privateChatReference = "noChatReference";
      notifyListeners();
      return privateChatReference;
    }
    privateChatReference = chatData.data["chatReference"];
    notifyListeners();
    return privateChatReference;
  }

  void getMissionsCompletedList(String email) async {
    missionsCompletedList.clear();
    var documents = await _fs
        .collection("Users")
        .document(email)
        .collection("MissionsCompleted")
        .orderBy("completedTime", descending: true)
        .getDocuments();
    for (var missionCompleted in documents.documents) {
        final String missionText = missionCompleted.data["missionText"];
        final String missionReference = missionCompleted.data["reference"];
        final String missionCategory = missionCompleted.data["missionCategory"];
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
        missionsCompletedList.add(FeedMissions(
            userEmail: email,
            isCompleted: true,
            date: 0,
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
            missionDeadline: missionDeadline.toDate()));
        notifyListeners();

    }
  }

  void getPrivateMessage(String value) {
    privateMessage = value;
    notifyListeners();
  }

  void saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    print("REGISTER TOKEN");
    if (fcmToken != null) {
      await _fs
          .collection("Users")
          .document(currentUserEmail)
          .collection("Tokens")
          .document("token")
          .setData({
        "token": fcmToken,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<int> getUserExp() async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(currentUserEmail).get();
    return userData.data["userExp"];
  }

  Future<String> getProfilePicture(String email) async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(email).get();
    profilPicture = userData.data["profilPicture"];
    notifyListeners();
    return userData.data["profilPicture"];
  }

  Future<Map> getUserAvatar(String email) async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(email).get();
    avatar = userData.data["Avatar"];
    notifyListeners();
    return userData.data["Avatar"];
  }

  Future<int> getUserMissionCompleted() async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(currentUserEmail).get();
    return userData.data["missionCompleted"];
  }

  Future<String> getUserName(String email) async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(email).get();
    userName = userData.data["userName"];
    notifyListeners();
    return userName;
  }

  Future isAlreadyFriend(String userName) async {
    QuerySnapshot friends = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Friends")
        .getDocuments();
    for (var friend in friends.documents) {
      if (userName == friend.data["friendName"]) {
        print("$userName IS ALREADY A FRIEND");
        isFriend = true;
        notifyListeners();
        return;
      } else {
        isFriend = false;
        print("$userName IS NOT A FRIEND");
        notifyListeners();
      }
    }
  }

  void checkFriendRequestAlreadySend(bool value) {
    friendRequestAlreadySend = value;
    notifyListeners();
  }

  Future<String> getEmail(String userName) async {
    QuerySnapshot userData = await _fs.collection("Users").getDocuments();
    for (var user in userData.documents) {
      if (user.data["userName"] == userName) {
        email = user.data["email"];
        notifyListeners();
        return email;
      }
    }
    print("$userName no User");
    return "NoUsername";
  }

  Future<int> getUserRank(String email) async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(email).get();
    myRank = userData.data["rank"];
    notifyListeners();
    return userData.data["rank"];
  }

  Future<int> getUserFriendsNumber(String email) async {
    DocumentSnapshot userData =
        await _fs.collection("Users").document(email).get();
    return userData.data["friends"];
  }

  void sendPrivateMessage(String receiver) async {
    int rank = await getUserRank(currentUserEmail);
    _fs
        .collection("PrivateChat")
        .document(privateChatReference)
        .collection("Chat")
        .document()
        .setData({
      "text": privateMessage,
      "sender": userName,
      "image": "",
      "date": DateTime.now().millisecondsSinceEpoch,
      "reference": privateChatReference,
      "email": currentUserEmail,
      "read": false,
      "rank": rank,
    });
    notifyListeners();
  }

  Future<bool> checkFriendsList() async {
    var friends = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Friends")
        .getDocuments();
    print("friends: ${friends.documents.length}");
    if (friends.documents.length > 0) {
      haveFriends = true;
      print("have friends");
      notifyListeners();
      return true;
    } else {
      print("don't have friends");
      haveFriends = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkFriendsRequest() async {
    print("CheckFriendsRequest");
    var friendsRequest = await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("FriendsRequest")
        .getDocuments();
    print(friendsRequest.documents.length);
    if (friendsRequest.documents.length > 0) {
      newRequest = true;
      notifyListeners();
      return true;
    } else {
      newRequest = false;
      notifyListeners();
      return false;
    }
  }

  Future checkNewPrivateMission() async {
    String userName = await getUserName(currentUserEmail);
    print("CHECKING FOR NEW PRIVATE MESSAGE...");
    var chatRooms = await _fs.collection("PrivateChat").getDocuments();
    for (var chatRoom in chatRooms.documents) {
      if (chatRoom.data["users"][0] == userName ||
          chatRoom.data["users"][1] == userName) {
        print("PRIVATE MESSAGE ROOM FOUND...");
        var messages = await _fs
            .collection("PrivateChat")
            .document(chatRoom.documentID)
            .collection("Chat")
            .getDocuments();
        for (var message in messages.documents) {
          if (message.data["email"] != currentUserEmail) {
            if (message.data["read"] == false) {
              print("NEW PRIVATE MESSAGE FOUND...");
              newPrivateMessage = true;
              notifyListeners();
              return;
            }
          }
        }
        print("NO NEW PRIVATE MESSAGE FOUND...");
        newPrivateMessage = false;
        notifyListeners();
        return;
      }
    }
  }

  void getCurrentFriends(String friendName) {
    currentFriend = friendName;
    notifyListeners();
  }

  void resetCurrentFriends() {
    currentFriend = null;
    notifyListeners();
  }

  Future uploadImage(File image, String username) async {
    print("upload image for $username");
    String fileName = basename(image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    print("image set in $currentUserEmail document");
    _fs.collection("Users").document(currentUserEmail).updateData({
      "profilPicture": url,
    });
    isLoadingImage = false;
    notifyListeners();
    getProfilePicture(currentUserEmail);
  }

  Future uploadImageInChat(
      File image, String userName, String friendName) async {
    getChatReference(friendName);
    print("upload image for $userName");
    int rank = await getUserRank(currentUserEmail);
    String fileName = basename(image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var url = await taskSnapshot.ref.getDownloadURL();
    print(url);
    print("image set in $currentUserEmail document");
    _fs
        .collection("PrivateChat")
        .document(privateChatReference)
        .collection("Chat")
        .document()
        .setData({
      "email": currentUserEmail,
      "sender": userName,
      "text": "",
      "image": url,
      "date": DateTime.now().millisecondsSinceEpoch,
      "read": false,
      "rank": rank,
    });
    isLoadingImage = false;
    notifyListeners();
  }

  Future listOfChatFriend() async {
    chatFriendsList.clear();
    print("Searching for friends...");
    await for (var snapshot in _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Friends")
        .snapshots()) {
      for (var user in snapshot.documents) {
        String chatFriendUserName = user.data["friendName"];
        String chatFriendProfilPicture = user.data["profilPicture"];
        String chatReference =
            await ProfilBrainData().getChatReference(chatFriendUserName);
        chatFriendsList.add(ChatFriend(
            chatReference: chatReference,
            username: chatFriendUserName,
            profilPicture: chatFriendProfilPicture));
        print("Chat Friend Added !");
        print("$chatFriendUserName");
        print("$chatReference");
        print("${chatFriendsList.length}");
        notifyListeners();
      }
      return;
    }
  }

  Future getListOfFriends(String friendEmail) async {
    friendsList.clear();
    print("Searching friends for $friendEmail");
    QuerySnapshot friendsData = await _fs
        .collection("Users")
        .document(friendEmail)
        .collection("Friends").getDocuments();
    print("$friendEmail has this many friends : ${friendsData.documents.length}");
      for (var user in friendsData.documents) {
        String friendUserName = user.data["friendName"];
        String friendProfilPicture = user.data["profilPicture"];
        String friendEmail = await user.data["friendEmail"];
        int friendRank = await getUserRank(friendEmail);
        bool isFriend = await SearchAutoData().isItFriend(friendUserName);
        friendsList.add(ResultProfil(
            chatReference: "",
            profilPicture: friendProfilPicture,
            username: friendUserName,
            userRank: friendRank.toString(),
            userEmail: friendEmail,
            isFriend: isFriend));
        print("Chat Friend Added !");
        print("$friendUserName");
        print("${friendsList.length}");
        notifyListeners();
      }
      notifyListeners();
      return;
  }

  void getBadgeList(String email) async {
    userBadgeList.clear();
    await for (var snapshot in _fs
        .collection("Users")
        .document(email)
        .collection("Badges")
        .snapshots())
      for (var user in snapshot.documents) {
        String badgeImage = await user.data["imageLink"];
        String badgeDescription = await user.data["description"];
        userBadgeList
            .add(Badge(url: badgeImage, description: badgeDescription));
        notifyListeners();
      }
    notifyListeners();
  }

  void readAllPrivateMessage(String chatReference) async {
    var messages = await _fs
        .collection("PrivateChat")
        .document(chatReference)
        .collection("Chat")
        .getDocuments();
    for (var message in messages.documents) {
      message.reference.updateData({
        "read": true,
      });
      newPrivateMessage = false;
      notifyListeners();
    }
  }

  void getNewPrivateMessage(bool value) {
    newPrivateMessage = value;
    notifyListeners();
  }
}

class Badge {
  String url;
  String description;
  Badge({@required this.url, @required this.description});
}

class ChatFriend {
  String profilPicture;
  String username;
  String chatReference;
  ChatFriend(
      {@required this.profilPicture,
      @required this.username,
      @required this.chatReference});
}

class ResultProfil {
  final String chatReference;
  final String profilPicture;
  final String username;
  final String userRank;
  final String userEmail;
  bool isFriend;
  ResultProfil(
      {@required this.profilPicture,
      @required this.username,
      @required this.userRank,
      @required this.isFriend,
      @required this.userEmail,
      @required this.chatReference});
}

class FeedMissions {
  FeedMissions(
      {@required this.missionText,
      @required this.missionCategory,
      @required this.userName,
      @required this.profilPicture,
      @required this.rank,
      @required this.userText,
      @required this.missionPicture,
      @required this.missionDifficulty,
      @required this.missionExp,
      @required this.missionDeadline,
      @required this.missionReference,
      @required this.isCompleted,
      @required this.userEmail,
      @required this.date});
  final String missionText;
  final String missionCategory;
  final int missionDifficulty;
  final double missionExp;
  final String missionPicture;
  final DateTime missionDeadline;
  final String profilPicture;
  final String rank;
  final String userName;
  final String userText;
  final String userEmail;
  final String missionReference;
  final bool isCompleted;
  final int date;
}
