import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/component/mission.dart';
import 'package:Komeet/component/profil.dart';
import 'package:Komeet/component/search.dart';
import 'package:Komeet/provider/SearchAutoData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static String id = "search_screen";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    var _pr = Provider.of<SearchAutoData>(context);
    print("result profil = ${_pr.resultProfilList.length}");
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SearchWidget(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return _pr.section == "Users"
                        ? _pr.resultProfilList.length == 0 ?
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: data.size.width / 3.5, vertical: 8.0),
                      child: Center(
                        child: RaisedButton(
                            onPressed: (){
                          Provider.of<SearchAutoData>(context, listen: false)
                              .getSection("Users");
                        },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text("Search", style: TextStyle(
                              fontSize: 26.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500)),
                              Icon(Icons.search, color: Colors.blueGrey,)
                            ],
                          ),
                        ),
                      ),
                    )

                        : _pr.resultProfilList[index].isFriend
                            ? ChatProfil(
                                chatReference:
                                    _pr.resultProfilList[index].chatReference,
                                username: _pr.resultProfilList[index].username,
                                profilPicture:
                                    _pr.resultProfilList[index].profilPicture,
                              )
                            : SearchedProfile(
                                username: _pr.resultProfilList[index].username,
                                profilPicture:
                                    _pr.resultProfilList[index].profilPicture,
                                userRank: _pr.resultProfilList[index].userRank,
                                searchUserEmail:
                                    _pr.resultProfilList[index].userEmail,
                              )
                        : SearchedMission(
                            isRequest: false,
                            missionText:
                                _pr.resultMissionList[index].missionText,
                            missionAdmin:
                                _pr.resultMissionList[index].missionAdmin,
                            missionCategory:
                                _pr.resultMissionList[index].missionCategory,
                            deadline: _pr.resultMissionList[index].deadline,
                            missionExp: _pr.resultMissionList[index].missionExp,
                            missionDifficulty:
                                _pr.resultMissionList[index].missionDifficulty,
                            missionReference:
                                _pr.resultMissionList[index].missionReference,
                            usersSubscribed:
                                _pr.resultMissionList[index].userSubscribed);
                  },
                  itemCount: _pr.section == "Users"
                      ? _pr.resultProfilList.length == 0 ?
                      1 : _pr.resultProfilList.length
                      : _pr.resultMissionList.length,
                ),
              ),
              SizedBox(
                height: data.size.height / 10,
              )
            ],
          ),
        ],
      ),
    );
  }
}
