class User {
  final String email;
  final String password;
  final String username;
  final String uid;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() =>
      {"uid": uid, "email": email, "username": username};
}
