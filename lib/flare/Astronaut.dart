import 'package:flutter/material.dart';
import 'astronaut_controller.dart';
import 'package:flare_flutter/flare_actor.dart';

AstronautController astronautController = AstronautController();

GestureDetector astronaut() {
  return GestureDetector(
    onTap: () {
      astronautController.wave();
    },
    child: FlareActor(
      "lib/assets/astronaut.flr",
      animation: "breathing",
      controller: astronautController,
      alignment: Alignment.topCenter,
      fit: BoxFit.cover,
    ),
  );
}

FlareActor loadingAstronaut() {
  return FlareActor(
    "lib/assets/loading.flr",
    animation: "Untitled",
    alignment: Alignment.center,
  );
}

FlareActor planet() {
  return FlareActor(
    "lib/assets/planet.flr",
    animation: "planet",
    alignment: Alignment.topCenter,
  );
}

FlareActor registerAstronaut() {
  return FlareActor(
    "lib/assets/register.flr",
    animation: "swim",
    alignment: Alignment.center,
    fit: BoxFit.fill,
  );
}

FlareActor speed() {
  return FlareActor(
    "lib/assets/speed.flr",
    animation: "Untitled",
    alignment: Alignment.center,
    fit: BoxFit.fill,
  );
}
