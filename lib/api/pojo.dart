class Group {
  Group({
    required this.id,
    required this.coin,
    required this.creator,
    required this.coinHolder,
    required this.members,
  });

  String id;
  int coin;
  String creator;
  String coinHolder;
  List<String> members;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    coin: json["coin"],
    creator: json["creator"],
    coinHolder: json["coin_holder"],
    members: List<String>.from(json["members"].map((x) => x)),
  );

  @override
  String toString() {
    return 'Group{id: $id, coin: $coin, creator: $creator, coinHolder: $coinHolder, members: $members}';
  }
}