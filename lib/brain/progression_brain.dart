import 'package:flutter/material.dart';

class Level {
  Color levelColor(int rank) {
    if (rank <= 1) {
      return Colors.grey;
    } else if (rank <= 2) {
      return Colors.blueGrey;
    } else if (rank <= 3) {
      return Colors.blueAccent;
    } else if (rank <= 4) {
      return Colors.lightBlue;
    } else if (rank <= 6) {
      return Colors.cyan;
    } else if (rank <= 8) {
      return Colors.cyanAccent;
    } else if (rank <= 10) {
      return Colors.tealAccent;
    } else if (rank <= 15) {
      return Colors.teal;
    } else if (rank <= 20) {
      return Colors.green;
    } else if (rank <= 25) {
      return Colors.lightGreen;
    } else if (rank <= 30) {
      return Colors.lime;
    } else if (rank <= 35) {
      return Colors.limeAccent;
    } else if (rank <= 40) {
      return Colors.yellowAccent;
    } else if (rank <= 45) {
      return Colors.yellow;
    } else if (rank <= 50) {
      return Colors.amberAccent;
    } else if (rank <= 55) {
      return Colors.amber;
    } else if (rank <= 60) {
      return Colors.orangeAccent;
    } else if (rank <= 65) {
      return Colors.orange;
    } else if (rank <= 70) {
      return Colors.deepOrangeAccent;
    } else if (rank <= 75) {
      return Colors.deepOrange;
    } else if (rank <= 80) {
      return Colors.redAccent;
    } else if (rank <= 85) {
      return Colors.red;
    } else if (rank <= 90) {
      return Colors.purpleAccent;
    } else if (rank <= 95) {
      return Colors.purple;
    } else if (rank <= 100) {
      return Colors.deepPurpleAccent;
    } else if (rank > 100) {
      return Colors.pink;
    }
    return Colors.brown;
  }
}

class SpacePass {
  List<Reward> spacePassList = [
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/background_5.png",
        freeText: "New Background Color"),
    Reward(
        freeImage: "lib/images/ship_not_available.png",
        freeText: "Your First Spaceship"),
    Reward(), // 5
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(), // 10
    Reward(
        freeImage: "lib/images/battlepass/background_2.png",
        freeText: "New Background Color"),
    Reward(),
    Reward(),
    Reward(),
    Reward(), // 15
    Reward(
        freeImage: "lib/images/battlepass/background_3.png",
        freeText: "New Background Color"),
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/evolution-1.png",
        freeText: "Ship Upgrade 1"), // 20
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/pirate_clothe_4.png",
        freeText: "New Shirt Color"),
    Reward(),
    Reward(), // 25
    Reward(freeImage: "lib/images/battlepass/bouble.png", freeText: "New Type"),
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/background_4.png",
        freeText: "New Background Color"), // 30
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/couleur01.png",
        freeText: "New Ship Color"),
    Reward(), // 35
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/pirate_clothe_5.png",
        freeText: "New Shirt Color"),
    Reward(), // 40
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/couleur06.png",
        freeText: "New Ship Color"),
    Reward(),
    Reward(), // 45
    Reward(freeImage: "lib/images/battlepass/pirate.png", freeText: "New Type"),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/pirate_clothe_6.png",
        freeText: "New Shirt Color"),
    Reward(),
    Reward(), // 50
    Reward(
        freeImage: "lib/images/battlepass/background_1.png",
        freeText: "New Background Color"),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/couleur02.png",
        freeText: "New Ship Color"),
    Reward(), // 55
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/pirate_clothe_7.png",
        freeText: "New Shirt Color"), // 60
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/evolution-2.png",
        freeText: "Ship Upgrade 2"), // 65
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(), // 70
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/couleur03.png",
        freeText: "New Ship Color"), // 75
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(), //80
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/pirate_clothe_8.png",
        freeText: "New Shirt Color"),
    Reward(),
    Reward(),
    Reward(), // 85
    Reward(),
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/couleur05.png",
        freeText: "New Ship Color"),
    Reward(),
    Reward(), // 90
    Reward(),
    Reward(),
    Reward(),
    Reward(),
    Reward(), // 95
    Reward(),
    Reward(
        freeImage: "lib/images/battlepass/couleur07.png",
        freeText: "New Ship Color"),
    Reward(),
    Reward(),
    Reward(), //100
    Reward(
        freeImage: "lib/images/battlepass/evolution-3.png",
        freeText: "Ship Upgrade 3"),
  ];
}

class Reward {
  Reward({this.freeImage, this.freeText, this.premiumText, this.premiumImage});
  String freeText;
  String freeImage;
  String premiumText;
  String premiumImage;
}
