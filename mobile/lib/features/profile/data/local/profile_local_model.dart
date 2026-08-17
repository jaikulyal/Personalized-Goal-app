class ProfileLocalModel {
  final String id;
  final String name;
  final String email;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileLocalModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  ProfileLocalModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearPhoto = false,
  }) {
    return ProfileLocalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoPath': photoPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProfileLocalModel.fromMap(Map<String, dynamic> map) {
    return ProfileLocalModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoPath: map['photoPath'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
