enum UserRole {
  admin,
  faculty,
  staff,
  student,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final List<String> assignedZones;
  final bool isActive;
  final DateTime lastActive;
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.assignedZones,
    required this.isActive,
    required this.lastActive,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.student,
      ),
      assignedZones: List<String>.from(json['assignedZones'] as List),
      isActive: json['isActive'] as bool,
      lastActive: DateTime.parse(json['lastActive'] as String),
      profilePicture: json['profilePicture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'assignedZones': assignedZones,
      'isActive': isActive,
      'lastActive': lastActive.toIso8601String(),
      'profilePicture': profilePicture,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    List<String>? assignedZones,
    bool? isActive,
    DateTime? lastActive,
    String? profilePicture,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      assignedZones: assignedZones ?? this.assignedZones,
      isActive: isActive ?? this.isActive,
      lastActive: lastActive ?? this.lastActive,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
