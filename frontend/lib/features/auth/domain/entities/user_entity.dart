class UserEntity {
  final int id;
  final String email;
  final String token;

  UserEntity({
    required this.id,
    required this.email,
    required this.token,
  });


  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['user']['id'],
      email: json['user']['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'email': email,
      },
      'token': token,
    };
  }
}