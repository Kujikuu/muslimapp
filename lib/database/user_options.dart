import 'package:shared_preferences/shared_preferences.dart';

class UserOptions {
  final int id;
  final bool mute;

  UserOptions({this.id, this.mute});

  factory UserOptions.fromMap(Map<String, dynamic> json) =>
      UserOptions(id: json["id"], mute: json["mute"]);

  Map<String, dynamic> toMap() => {"id": id, "mute": mute};

  Future<bool> savePrefs(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return prefs.commit();
  }

  Future<String> loadPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }
}
