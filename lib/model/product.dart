class Product {
  String? id;
  String? gId;
  String? gName;
  String name;
  String description;
  int price;
  String selectedCategory;
  String imageUrl;
  int createdAt;

  Product(
      {this.id,
      this.gId,
      this.gName,
      required this.name,
      required this.description,
      required this.price,
      required this.selectedCategory,
      required this.imageUrl,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'gId': this.gId,
      'gName': this.gName,
      'name': this.name,
      'description': this.description,
      'price': this.price,
      'selectedCategory': this.selectedCategory,
      'imageUrl': this.imageUrl,
      'createdAt': this.createdAt,
    };
  }

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      id: map['id'] as String,
      gId: map['gId'] as String,
      gName: map['gName'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as int,
      selectedCategory: map['selectedCategory'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}
