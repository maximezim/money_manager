class Account {
  final String name;
  Account({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  factory Account.fromJson(Map<String, dynamic> json) =>
      Account(name: json['name']);
}
