import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5362731494742530~7566620324";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5362731494742530~6908144779";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5362731494742530~7566620324";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5362731494742530/8029654755";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5362731494742530/1356435199";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5362731494742530/7646511370";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5362731494742530/6225618493";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5362731494742530/8768021350";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
