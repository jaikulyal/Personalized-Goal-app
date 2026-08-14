class AuthUser {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String authProvider;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.authProvider,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      authProvider: json['authProvider'] as String,
    );
  }
}

class AuthResponse {
  final AuthUser user;
  final String accessToken;

  const AuthResponse({required this.user, required this.accessToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
    );
  }
}
