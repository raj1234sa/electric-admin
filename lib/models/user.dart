import 'dart:convert';

class User {
  String username;
  String emailId;
  String phoneNumber;
  String userId;
  bool isVerified;
  String password;

  User({
    this.username,
    this.emailId,
    this.userId,
    this.phoneNumber,
    this.isVerified,
    this.password,
  });

  User.fromMap(Map<String, dynamic> json)
      : username = json['username'],
        emailId = json['emailId'],
        userId = json['userId'],
        phoneNumber = json['phoneNumber'],
        password = json['password'],
        isVerified = json['isVerified'];

  Map<String, dynamic> toMap() => {
        'username': username,
        'emailId': emailId,
        'userId': userId,
        'isVerified': isVerified,
        'phoneNumber': phoneNumber,
        'password': password,
      };

  String toJson() {
    return json.encode(this);
  }

  factory User.fromJson(String str) {
    User user = User.fromMap(json.decode(str));
    return user;
  }
}
