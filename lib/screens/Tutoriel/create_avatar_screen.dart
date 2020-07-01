import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/profilBrainData.dart';
import 'package:Komeet/screens/Tutoriel/choose_profile_picture.dart';
import 'package:Komeet/screens/Tutoriel/complete_profil_screen.dart';
import 'package:Komeet/screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _fs = Firestore.instance;

class CreateAvatarScreen extends StatefulWidget {
  static String id = "create_avatar_screen";
  @override
  _CreateAvatarScreenState createState() => _CreateAvatarScreenState();
}

class _CreateAvatarScreenState extends State<CreateAvatarScreen> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<ProfilBrainData>(context);
    _pr.getUserRank(currentUserEmail);
    return WillPopScope(
      onWillPop: () async {
        _pr.avatar != null
            ? Navigator.pop(context)
            : SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: _pr.avatar != null ? true : false,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: oldColorGradient),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              Text(
                "Create Avatar",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: data.size.height / 10,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: _pr.avatarType == "male"
                                  ? Colors.blue
                                  : Color(0xFFE1E1E1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10.0,
                                  offset: Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: Color(0XFFFFFFFF),
                                  blurRadius: 7.0,
                                  offset: Offset(-5, -5),
                                )
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                _pr.getAvatarType("male");
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Text(
                                    "Type 1",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: data.size.height / 30,
                                        color: _pr.avatarType == "male"
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.65)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: _pr.avatarType == "female"
                                  ? Colors.blue
                                  : Color(0xFFE1E1E1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10.0,
                                  offset: Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: Color(0XFFFFFFFF),
                                  blurRadius: 7.0,
                                  offset: Offset(-5, -5),
                                )
                              ],
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  _pr.getAvatarType("female");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Text(
                                    "Type 2",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: data.size.height / 30,
                                        color: _pr.avatarType == "female"
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.65)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: _pr.avatarType == "pirate"
                                  ? Colors.blue
                                  : Color(0xFFE1E1E1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10.0,
                                  offset: Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: Color(0XFFFFFFFF),
                                  blurRadius: 7.0,
                                  offset: Offset(-5, -5),
                                )
                              ],
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  _pr.getUserRank(currentUserEmail);
                                  _pr.getAvatarType("pirate");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Text(
                                    "Pirate",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: data.size.height / 30,
                                        color: _pr.avatarType == "pirate"
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.65)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: _pr.avatarType == "booble"
                                  ? Colors.blue
                                  : Color(0xFFE1E1E1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 10.0,
                                  offset: Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: Color(0XFFFFFFFF),
                                  blurRadius: 7.0,
                                  offset: Offset(-5, -5),
                                )
                              ],
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  _pr.getAvatarType("booble");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Text(
                                    "Booble",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: data.size.height / 30,
                                        color: _pr.avatarType == "booble"
                                            ? Colors.white
                                            : Colors.black.withOpacity(0.65)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          if (_pr.hairStyle == 1) {
                          } else {
                            int value = _pr.hairStyle;
                            _pr.getHairStyle(value - 1);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30.0,
                        ),
                      ),
                      Center(
                        child: Container(
                          height: data.size.height / 3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE1E1E1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey,
                                blurRadius: 7.0,
                                offset: Offset(7, 7),
                              ),
                              BoxShadow(
                                color: Color(0XFFFFFFFF),
                                blurRadius: 7.0,
                                offset: Offset(-7, -7),
                              )
                            ],
                          ),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(data.size.height),
                              child: Avatar(
                                clotheColor: _pr.clotheColor,
                                background: _pr.avatarColorBackground,
                                bodyType: _pr.avatarType,
                                bodyColor: _pr.bodyColor,
                                hairColor: _pr.hairColor,
                                hairStyle: _pr.hairStyle,
                              )),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_pr.hairStyle == 5) {
                          } else {
                            int value = _pr.hairStyle;
                            _pr.getHairStyle(value + 1);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Skin Color",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 22.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ColorSkinButton(
                          data: data,
                          skinValue: 1,
                          colorSkin: _pr.avatarType == "booble"
                              ? Color(0xFFFEEA82)
                              : Color(0xFFFBC8AB),
                        ),
                        ColorSkinButton(
                          data: data,
                          skinValue: 2,
                          colorSkin: _pr.avatarType == "booble"
                              ? Color(0xFF77E4EB)
                              : Color(0xFFE8A37C),
                        ),
                        ColorSkinButton(
                          data: data,
                          skinValue: 3,
                          colorSkin: _pr.avatarType == "booble"
                              ? Color(0xFFF58B8B)
                              : Color(0xFFC6794D),
                        ),
                        ColorSkinButton(
                          data: data,
                          skinValue: 4,
                          colorSkin: _pr.avatarType == "booble"
                              ? Color(0xFF5FDF7B)
                              : Color(0xFF874621),
                        ),
                        ColorSkinButton(
                          data: data,
                          skinValue: 5,
                          colorSkin: _pr.avatarType == "booble"
                              ? Color(0xFFE6ABFB)
                              : Color(0xFF4F2914),
                        ),
                      ],
                    ),
                  ),
                  _pr.avatarType == "booble"
                      ? Container()
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hair color",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 22.0),
                          ),
                        ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _pr.avatarType == "booble"
                            ? SizedBox(
                                height: data.size.height / 11,
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ColorHairButton(
                                      hairValue: 1,
                                      data: data,
                                      colorHair: Color(0xFFC4C4C4)),
                                  ColorHairButton(
                                      hairValue: 2,
                                      data: data,
                                      colorHair: Color(0xFFD98142)),
                                  ColorHairButton(
                                      hairValue: 3,
                                      data: data,
                                      colorHair: Color(0xFFD9A542)),
                                  ColorHairButton(
                                      hairValue: 4,
                                      data: data,
                                      colorHair: Color(0xFF964213)),
                                  ColorHairButton(
                                      hairValue: 5,
                                      data: data,
                                      colorHair: Color(0xFF2C2C2C)),
                                ],
                              ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Clothe Color",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 22.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ColorClotheButton(
                                clotheValue: 1,
                                data: data,
                                colorHair: Colors.white),
                            ColorClotheButton(
                                clotheValue: 2,
                                data: data,
                                colorHair: Color(0xFF8F8F8F)),
                            ColorClotheButton(
                                clotheValue: 3,
                                data: data,
                                colorHair: Color(0xFF54A6B1)),
                            Visibility(
                              visible: _pr.myRank >= 22,
                              child: ColorClotheButton(
                                  clotheValue: 4,
                                  data: data,
                                  colorHair: Color(0xFF2665C2)),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 38,
                              child: ColorClotheButton(
                                  clotheValue: 5,
                                  data: data,
                                  colorHair: Color(0xFFDCA926)),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 47,
                              child: ColorClotheButton(
                                  clotheValue: 6,
                                  data: data,
                                  colorHair: Color(0xFFD81B1B)),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 59,
                              child: ColorClotheButton(
                                  clotheValue: 7,
                                  data: data,
                                  colorHair: Color(0xFFDB52AA)),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 81,
                              child: ColorClotheButton(
                                  clotheValue: 8,
                                  data: data,
                                  colorHair: Color(0xFF88DD34)),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Background Color",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 22.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ColorBackgroundButton(
                                value: 1,
                                data: data,
                                colorBackground: Colors.blue),
                            ColorBackgroundButton(
                                value: 2,
                                data: data,
                                colorBackground: Colors.green),
                            ColorBackgroundButton(
                                value: 3,
                                data: data,
                                colorBackground: Colors.red),
                            ColorBackgroundButton(
                                value: 4,
                                data: data,
                                colorBackground: Colors.amber),
                            Visibility(
                              visible: _pr.myRank >= 2,
                              child: ColorBackgroundButton(
                                  value: 9,
                                  data: data,
                                  colorBackground: Colors.white),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 10,
                              child: ColorBackgroundButton(
                                  value: 5,
                                  data: data,
                                  colorBackground: Colors.pinkAccent),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 15,
                              child: ColorBackgroundButton(
                                  value: 7,
                                  data: data,
                                  colorBackground: Colors.yellowAccent),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 29,
                              child: ColorBackgroundButton(
                                  value: 8,
                                  data: data,
                                  colorBackground: Colors.greenAccent),
                            ),
                            Visibility(
                              visible: _pr.myRank >= 50,
                              child: ColorBackgroundButton(
                                  value: 6,
                                  data: data,
                                  colorBackground: Colors.teal),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          elevation: 10.0,
                          onPressed: () async {
                            if (_pr.avatarType == "pirate" && _pr.myRank < 45) {
                              print("not a pirate");
                              return;
                            } else if (_pr.avatarType == "booble" &&
                                _pr.myRank < 25) {
                              print("not a booble");
                              return;
                            } else {
                              await ProfilBrainData().defineAvatar(
                                  _pr.avatarType,
                                  _pr.bodyColor,
                                  _pr.hairStyle,
                                  _pr.hairColor,
                                  _pr.avatarColorBackground,
                                  _pr.clotheColor);
                              DocumentSnapshot userData = await _fs
                                  .collection("Users")
                                  .document(currentUserEmail)
                                  .get();
                              if (userData.data["tutorialIsOver"] == true) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushNamed(
                                    context, ChooseProfilPicture.id);
                              }
                            }
                          },
                          color: _pr.avatarType == "pirate" && _pr.myRank < 45
                              ? Colors.grey
                              : _pr.avatarType == "booble" && _pr.myRank < 25
                                  ? Colors.grey
                                  : Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _pr.avatarType == "pirate" && _pr.myRank < 45
                                  ? "Unlock at Level 45"
                                  : _pr.avatarType == "booble" &&
                                          _pr.myRank < 25
                                      ? "Unlock at Level 25"
                                      : "Confirm Avatar",
                              style: TextStyle(
                                  fontSize: 22.0, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorSkinButton extends StatelessWidget {
  const ColorSkinButton({
    @required this.skinValue,
    @required this.data,
    @required this.colorSkin,
  });
  final Color colorSkin;
  final int skinValue;
  final MediaQueryData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ProfilBrainData>(context).getBodyColor(skinValue);
      },
      child: Container(
        height: data.size.height / 25,
        width: data.size.height / 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 4.0,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: Color(0XFFFFFFFF),
              blurRadius: 4.0,
              offset: Offset(-3, -3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: colorSkin, borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}

class ColorBackgroundButton extends StatelessWidget {
  const ColorBackgroundButton({
    @required this.value,
    @required this.data,
    @required this.colorBackground,
  });
  final Color colorBackground;
  final int value;
  final MediaQueryData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ProfilBrainData>(context).getAvatarColorBackground(value);
      },
      child: Container(
        height: data.size.height / 25,
        width: data.size.height / 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 4.0,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: Color(0XFFFFFFFF),
              blurRadius: 4.0,
              offset: Offset(-3, -3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}

class ColorHairButton extends StatelessWidget {
  const ColorHairButton({
    @required this.hairValue,
    @required this.data,
    @required this.colorHair,
  });
  final Color colorHair;
  final int hairValue;
  final MediaQueryData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ProfilBrainData>(context).getHairColor(hairValue);
      },
      child: Container(
        height: data.size.height / 25,
        width: data.size.height / 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 4.0,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: Color(0XFFFFFFFF),
              blurRadius: 4.0,
              offset: Offset(-3, -3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: colorHair, borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}

class ColorClotheButton extends StatelessWidget {
  const ColorClotheButton({
    @required this.clotheValue,
    @required this.data,
    @required this.colorHair,
  });
  final Color colorHair;
  final int clotheValue;
  final MediaQueryData data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<ProfilBrainData>(context).getClotheColor(clotheValue);
      },
      child: Container(
        height: data.size.height / 25,
        width: data.size.height / 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 4.0,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: Color(0XFFFFFFFF),
              blurRadius: 4.0,
              offset: Offset(-3, -3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: colorHair, borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    );
  }
}
