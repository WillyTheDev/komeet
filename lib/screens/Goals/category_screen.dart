import 'package:Komeet/provider/MissionsData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static String id = "category_screen";
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listOfCategory = [
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
        title: "Food",
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFFE1E8E7)),
          ),
          ListView(
            children: listOfCategory,
          )
        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    @required this.iconColor,
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Provider.of<MissionData>(context).getCategoryMission(title);
          Provider.of<MissionData>(context).getCategoryIcon(icon, iconColor);
          Provider.of<MissionData>(context).getCategorySubtitle(subtitle);
        },
        child: Container(
          height: data.size.height / 8,
          width: data.size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset.fromDirection(-20, 0),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    size: 50.0,
                    color: iconColor,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: data.size.width / 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: data.size.width / 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
