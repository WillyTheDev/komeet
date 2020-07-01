import 'dart:math';

class Battle {
  Map spaceShip1 = {
    "armor": 30,
    "mobility": 30,
    "damage": 30,
    "accuracy": 30,
    "firerate": 30,
    "health": 80,
  };

  Map randomEasyPirateSpaceShip = {
    "spaceShip": Random().nextInt(3) + 1,
    "spaceShipVersion": Random().nextInt(2) + 1,
    "spaceShipColor": Random().nextInt(3) + 1,
    "armor": 10 + Random().nextInt(30),
    "mobility": 10 + Random().nextInt(30),
    "damage": 10 + Random().nextInt(30),
    "accuracy": 10 + Random().nextInt(30),
    "firerate": 10 + Random().nextInt(30),
    "health": 70 + Random().nextInt(20),
  };

  Map randomMediumPirateSpaceShip = {
    "spaceShip": Random().nextInt(3) + 1,
    "spaceShipVersion": Random().nextInt(3) + 1,
    "spaceShipColor": Random().nextInt(3) + 1,
    "armor": 25 + Random().nextInt(30),
    "mobility": 25 + Random().nextInt(30),
    "damage": 25 + Random().nextInt(30),
    "accuracy": 25 + Random().nextInt(30),
    "firerate": 25 + Random().nextInt(30),
    "health": 80 + Random().nextInt(30),
  };

  Map randomHardPirateSpaceShip = {
    "spaceShip": Random().nextInt(3) + 1,
    "spaceShipVersion": Random().nextInt(4) + 1,
    "spaceShipColor": Random().nextInt(3) + 1,
    "armor": 40 + Random().nextInt(60),
    "mobility": 40 + Random().nextInt(60),
    "damage": 40 + Random().nextInt(60),
    "accuracy": 40 + Random().nextInt(60),
    "firerate": 40 + Random().nextInt(60),
    "health": 120 + Random().nextInt(40),
  };

  Map spaceShip2 = {
    "armor": 20,
    "mobility": 20,
    "damage": 20,
    "accuracy": 20,
    "firerate": 20,
    "health": 80
  };

  Map spaceShip3 = {
    "armor": 20,
    "mobility": 20,
    "damage": 20,
    "accuracy": 20,
    "firerate": 20,
    "health": 80
  };
}
