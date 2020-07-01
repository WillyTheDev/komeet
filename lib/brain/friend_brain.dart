import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:random_string/random_string.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _fs = Firestore.instance;

class FriendBrain {
  var pbd = ProfilBrainData();

  Future askFriends(String friendName) async {
    print("Send FRIENDS Request");
    String userName = await pbd.getUserName(currentUserEmail);
    String friendEmail = await pbd.getEmail(friendName);
    String profilPicture = await pbd.getProfilePicture(currentUserEmail);
    print(friendName);
    await _fs
        .collection("Users")
        .document(friendEmail)
        .collection("FriendsRequest")
        .document(userName)
        .setData({
      "profilPicture": profilPicture,
      "friendName": userName,
      "friendEmail": currentUserEmail,
    });
  }

  Future rejectFriends(String friendName) async {
    print("ADD FRIENDS");
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("FriendsRequest")
        .document(friendName)
        .delete();
  }

  void acceptFriends(String friendName, String profilPicture, String friendEmail) async {
    print("ACCEPT FRIENDS : $friendName");
    var reference = randomAlphaNumeric(20);
    String userName = await pbd.getUserName(currentUserEmail);
    String userProfilPicture = await pbd.getProfilePicture(currentUserEmail);
    int userFriends = await pbd.getUserFriendsNumber(currentUserEmail);
    print("GETUSERFRIENDSNUMBER FOR MYSELF");
    int friendFriends = await pbd.getUserFriendsNumber(friendEmail);
    print("GETUSERFRIENDSNUMBER FOR FRIENDS");
    print("ADD FRIENDS");
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("FriendsRequest")
        .document(friendName)
        .delete();
    await _fs
        .collection("Users")
        .document(friendEmail)
        .collection("Friends")
        .document(userName)
        .setData({
      "profilPicture": userProfilPicture,
      "friendName": userName,
      "friendEmail": currentUserEmail,
      "chatReference": reference,
    });
    await _fs
        .collection("Users")
        .document(currentUserEmail)
        .collection("Friends")
        .document(friendName)
        .setData({
      "profilPicture": profilPicture,
      "friendName": friendName,
      "friendEmail": friendEmail,
      "chatReference": reference,
    });
    _fs.collection("PrivateChat").document(reference).setData({
      "users": [userName, friendName]
    });
    _fs.collection("Users").document(currentUserEmail).updateData({
      "friends": userFriends + 1,
    });
    _fs.collection("Users").document(friendEmail).updateData({
      "friends": friendFriends + 1,
    });
  }
}
