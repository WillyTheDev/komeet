import 'package:flare_flutter/flare_controls.dart';

class AstronautController extends FlareControls {
  String breathing = "breathing";
  String waveAnimation = "wave";
  String likeAnimation = "Untitled";
  bool doWave = false;

  void wave() {
    play(waveAnimation);
  }
}
