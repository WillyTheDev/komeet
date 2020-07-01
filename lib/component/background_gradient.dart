import 'package:flutter/material.dart';

BoxDecoration kgradientBackground = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Colors.blueAccent, Color(0xFF004e92)]));

BoxDecoration kGradientReverseBackground = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF004e92), Colors.blueAccent]));

Color kBlueLaserColor = Color(0xFF3DAED8);

Color kBackgroundColor = Color(0xFFF2F2F2);

Color kCTA = Colors.blueAccent;

LinearGradient mainColorGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF22DFD4), Color(0xFF0041A3)]);
LinearGradient mainColorGradientReverse = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF0041A3), Color(0xFF22DFD4)]);
LinearGradient passValidColorGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.lightGreenAccent, Colors.green.shade900]);

LinearGradient oldColorGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.blueAccent, Color(0xFF004e92)]);

LinearGradient oldReverseColorGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF004e92), Colors.blueAccent]);

LinearGradient upgradeShipGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.yellow.shade700, Colors.orangeAccent.shade700]);

LinearGradient battlePassGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  stops: [0.1, 0.4, 0.6, 0.9],
  colors: [
    Color(0xFFE71138),
    Color(0xFF252542),
    Color(0xFF252542),
    Color(0xFF252542)
  ],
);

RadialGradient premiumGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.75,
    colors: [Color(0xFF004e92), Color(0xFF252542)]);

RadialGradient freeGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.75,
    colors: [Colors.white, Colors.grey.shade400]);

LinearGradient hangarGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF007979), Color(0xFF252542)]);

class Avatar extends StatelessWidget {
  Avatar({
    @required this.bodyType,
    @required this.bodyColor,
    @required this.hairColor,
    @required this.hairStyle,
    @required this.background,
    @required this.clotheColor,
  });
  final String bodyType;
  final int bodyColor;
  final int hairStyle;
  final int hairColor;
  final int background;
  final int clotheColor;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Container(
      height: data.size.height / 7,
      decoration: BoxDecoration(
          color: background != null
              ? background == 1
                  ? Colors.blue
                  : background == 2
                      ? Colors.green
                      : background == 3
                          ? Colors.red
                          : background == 4
                              ? Colors.amber
                              : background == 5
                                  ? Colors.pinkAccent
                                  : background == 6
                                      ? Colors.teal
                                      : background == 7
                                          ? Colors.yellowAccent
                                          : background == 8
                                              ? Colors.greenAccent
                                              : background == 9
                                                  ? Colors.white
                                                  : Colors.black54
              : Colors.green,
          shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image(
              image: AssetImage(
                  "lib/images/avatar/body/${bodyType == null ? "male" : bodyType}_${bodyColor == null ? 2 : bodyColor}.png"),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image(
              image: AssetImage(
                  "lib/images/avatar/clothe/${bodyType == null ? "male" : bodyType}_clothe_${clotheColor == null ? 1 : clotheColor}.png"),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image(
              image: AssetImage(
                  "lib/images/avatar/hairCut/${bodyType == null ? "male" : bodyType}_HairCut_${hairStyle == null ? 2 : hairStyle}_${hairColor == null ? 2 : hairColor}.png"),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image(
              image: AssetImage(
                  "lib/images/avatar/background/avatar_background.png"),
            ),
          )
        ],
      ),
    );
  }
}
