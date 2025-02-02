class Category {
  final String name;
  Category({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(name: json['name']);
}
