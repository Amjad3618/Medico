class UserrModel {
  String? profilepic;
  String? name;
  String? email;
  String? password;
  String? userUid;

  // Constructor
  UserrModel(
      {this.name, this.email, this.password, this.userUid, this.profilepic});

  // fromJson factory method
  factory UserrModel.fromJson(Map<String, dynamic> json) {
    return UserrModel(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        userUid: json['userUid'],
        profilepic: json["profilepic"]);
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userUid': userUid,
      "profilepic": profilepic
    };
  }
}
