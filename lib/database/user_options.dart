class UserOptions {
  final int id;
  final bool mute;

  UserOptions({this.id, this.mute});

  factory UserOptions.fromMap(Map<String, dynamic> json) =>
      UserOptions(id: json["id"], mute: json["mute"]);

  Map<String, dynamic> toMap() => {"id": id, "mute": mute};
}
