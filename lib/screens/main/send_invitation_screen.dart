import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendInvitationScreen extends StatefulWidget {
  static String id = "send_invitation_screen";
  @override
  _SendInvitationScreenState createState() => _SendInvitationScreenState();
}

class _SendInvitationScreenState extends State<SendInvitationScreen> {
  @override
  Widget build(BuildContext context) {
    var _pr = Provider.of<ProfilBrainData>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: oldColorGradient),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Friend's List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _pr.friendsList.length,
        itemBuilder: (context, index) {
          return SendMissionInvitationProfil(
            userEmail: _pr.friendsList[index].userEmail,
            username: _pr.friendsList[index].username,
            profilPicture: _pr.friendsList[index].profilPicture,
          );
        },
      ),
    );
  }
}
