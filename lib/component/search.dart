import 'package:Komeet/brain/mission_brain.dart';
import 'package:Komeet/component/background_gradient.dart';
import 'package:Komeet/provider/SearchAutoData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool searchMission = false;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: oldColorGradient,
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
              ),
              onSubmitted: (value) {
                Provider.of<SearchAutoData>(context, listen: false).getSearch(value);
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.50),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Search"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<SearchAutoData>(context, listen: false)
                            .getSection("Users");
                        setState(() {
                          searchMission = false;
                        });
                      },
                      child: Icon(
                        Icons.people,
                        size: 30.0,
                        color: searchMission ? Color(0xFF000428) : Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          Provider.of<SearchAutoData>(context, listen: false)
                              .getSection("Missions");
                          setState(() {
                            searchMission = true;
                          });
                        },
                        child: Icon(
                          Icons.flag,
                          size: 35.0,
                          color: !searchMission
                              ? Colors.blueAccent.shade100
                              : Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            searchMission
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: data.size.height / 7.5,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: CategoryList().listOfCategory.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 8.0),
                            child: Provider.of<SearchAutoData>(context)
                                        .searchCategory ==
                                    CategoryList().listOfCategory[index].title
                                ? InkWell(
                                    onTap: () {
                                      Provider.of<SearchAutoData>(context, listen: false)
                                          .getSearchCategory(CategoryList()
                                              .listOfCategory[index]
                                              .title);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54,
                                              blurRadius: 10.0,
                                              offset: Offset(5, 5),
                                            ),
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 8.0),
                                        child: Icon(
                                          CategoryList()
                                              .listOfCategory[index]
                                              .icon,
                                          color: CategoryList()
                                              .listOfCategory[index]
                                              .iconColor,
                                          size: 55.0,
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Provider.of<SearchAutoData>(context, listen: false)
                                          .getSearchCategory(CategoryList()
                                              .listOfCategory[index]
                                              .title);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          CategoryList()
                                              .listOfCategory[index]
                                              .icon,
                                          color: CategoryList()
                                              .listOfCategory[index]
                                              .iconColor,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

