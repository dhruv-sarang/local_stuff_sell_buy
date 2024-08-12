class Category {
  String name;

  Category({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] as String,
    );
  }
}
