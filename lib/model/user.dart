class Users {
  final String userId;
  final String userName;
  final String email;
  final String bio;
  final String? foto;

  Users({
    required this.userId,
    required this.userName,
    required this.email,
    required this.bio,
    required this.foto,
  });

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['userId'],
      userName: map['userName'],
      email: map['email'],
      bio: map['map'],
      foto: map['foto'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'bio': bio,
      'foto': foto,
    };
  }
}
