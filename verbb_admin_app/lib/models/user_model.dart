class UserModel {
  final String email;
  final String accessToken;

  UserModel({required this.email, required this.accessToken});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'],
      accessToken: data['access_token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'access_token': accessToken,
    };
  }
}
