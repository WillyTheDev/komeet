import 'package:Komeet/component/buttons.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:Komeet/provider/profilBrainData.dart';

class RegisterBrain {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fs = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseUser loggedInUser;

  Future<void> createUser(String email, String password, String confirmPassword,
      BuildContext test) async {
    print("createUserFunctionLaunched !");
    if (password != confirmPassword) {
      showDialog(
          context: test,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Oh oh.."),
              content: Text("Passwords are not the same"),
            );
          });
      return null;
    } else {
      print("creatUser with $email, $password");
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseUser user = await _auth.currentUser();
        await user.sendEmailVerification();
        await _fs.collection("Users").document(email).setData({
          "email": email,
          "userName": "Undefined",
          "rank": 1,
          "friends": 0,
          "missionCompleted": 0,
          "currentMission": 0,
          "premium": 0,
          "tutorialIsOver": false,
          "userExp": 0,
          "Avatar": {},
        });
        _fcm.subscribeToTopic("CommunityMissions");
        Provider.of<ProfilBrainData>(test).getMyRank(1);
        Navigator.pushNamed(test, LoadingScreen.id);
      } catch (e) {
        showDialog(
            context: test,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Oh oh.."),
                content: Text("An Account with this email Already exist"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black54),
                    ),
                  )
                ],
              );
            });
      }
      return null;
    }
  }

  Future<void> logInUser(
      String email, String password, BuildContext test) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      if (e.toString().contains("USER")) {
        showDialog(
            context: test,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Oupsie..."),
                content: Text(email.contains("gmail")
                    ? "Try Connecting with the Google Button"
                    : "There is No User associated with this email: $email"),
                actions: <Widget>[
                  email.contains("gmail")
                      ? Center(
                          child: ButtonGoogleSignIn(
                              buttonText: "Connect with Google"))
                      : FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: Colors.black54),
                          ),
                        ),
                ],
              );
            });
      }
      if (e.toString().contains("PASSWORD")) {
        showDialog(
            context: test,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Oupsie..."),
                content: Text(email.contains("gmail")
                    ? "Try Connecting with the Google Button"
                    : "Wrong Password, the password seems to be incorrect with this email : $email"),
                actions: <Widget>[
                  email.contains("gmail")
                      ? Center(
                          child: ButtonGoogleSignIn(
                              buttonText: "Connect with Google"))
                      : GestureDetector(
                          onTap: () async {
                            await _auth.sendPasswordResetEmail(email: email);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: Colors.blueAccent),
                          ),
                        ),
                  email.contains("gmail")
                      ? Container()
                      : FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: Colors.black54),
                          ),
                        )
                ],
              );
            });
      }
    }
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(test, LoadingScreen.id);
    }
  }

  Future<void> googleRegister(BuildContext test) async {
    print("GOOGLE SIGN IN");
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    print("GOOGLE SIGN IN email = ${googleUser.email}");
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _auth.signInWithCredential(credential);
    final FirebaseUser fireUser =
        (await _auth.signInWithCredential(credential)).user;
    var users = await _fs.collection("Users").getDocuments();
    for (var user in users.documents) {
      if (googleUser.email == user.data["email"]) {
        print("GOOGLE SIGN IN ALREADY EXIST !");
        Navigator.pushNamed(test, LoadingScreen.id);
        return;
      }
    }
    fireUser.sendEmailVerification();
    _fs.collection("Users").document(fireUser.email).setData({
      "email": googleUser.email,
      "userName": "Undefined",
      "rank": 1,
      "friends": 0,
      "premium": 0,
      "missionCompleted": 0,
      "userExp": 0,
      "currentMission": 0,
      "tutorialIsOver": false,
      "Avatar": {},
    });
    _fcm.subscribeToTopic("CommunityMissions");
    Provider.of<ProfilBrainData>(test, listen: false).getMyRank(1);
    Navigator.pushNamed(test, LoadingScreen.id);
  }
}
