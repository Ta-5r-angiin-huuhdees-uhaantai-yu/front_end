class Imgs {
  static late String loader;
  static late String icon;

  static refresh() {
    loader = 'lib/assets/maya_loader.json';
    icon = 'lib/assets/app_icon.png';
  }
}

class Fnt {
  static String cSFProDisplay = 'SF Pro Display';
}

class Snd {
  static String enter = 'audio/enter.mp3';
  static String exit = 'audio/exit.mp3';
}

class Riv {
  static String emptyState = 'assets/rive/landing.riv';
  static String serviceUnavailable = 'assets/rive/tv_color.riv';
}