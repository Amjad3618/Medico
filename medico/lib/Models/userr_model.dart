class UserrModel {
  String? name;
  String? email;
  String? password;
  String? userUid;
  String? imageUrl;

  UserrModel({
    this.name,
    this.email,
    this.password,
    this.userUid,
    this.imageUrl,
  });

  factory UserrModel.fromJson(Map<String, dynamic> json) {
    return UserrModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userUid: json['userUid'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userUid': userUid,
      'imageUrl': imageUrl,
    };
  }
}
