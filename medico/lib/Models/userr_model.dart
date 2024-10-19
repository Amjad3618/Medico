class UserrModel {
  String? name;
  String? email;
  String? password;
  String? userUid;

  // Constructor
  UserrModel({this.name, this.email, this.password, this.userUid});

  // fromJson factory method
  factory UserrModel.fromJson(Map<String, dynamic> json) {
    return UserrModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userUid: json['userUid'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userUid': userUid,
    };
  }
}