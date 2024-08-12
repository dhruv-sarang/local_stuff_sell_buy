class CurrentUserData {
  String? id;
  String name;
  String email;
  String imageUrl;
  String mobileNo;
  String pinCode;
  String address;
  int createdAt;

  CurrentUserData(
      {this.id,
      required this.name,
      required this.email,
      required this.imageUrl,
      required this.mobileNo,
      required this.pinCode,
      required this.address,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'mobileNo': this.mobileNo,
      'pinCode': this.pinCode,
      'address': this.address,
      'createdAt': this.createdAt,
    };
  }

  factory CurrentUserData.fromMap(Map<dynamic, dynamic> map) {
    return CurrentUserData(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      imageUrl: map['imageUrl'] as String,
      mobileNo: map['mobileNo'] as String,
      pinCode: map['pinCode'] as String,
      address: map['address'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}
