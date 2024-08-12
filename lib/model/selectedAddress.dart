class SelectedAddress{
  String? id;
  String email;
  int selectedOption;

  SelectedAddress({this.id,required this.email,required this.selectedOption});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'selectedOption': this.selectedOption,
    };
  }

  factory SelectedAddress.fromMap(Map<dynamic, dynamic> map) {
    return SelectedAddress(
      id: map['id'] as String,
      email: map['email'] as String,
      selectedOption: map['selectedOption'] as int,
    );
  }
}