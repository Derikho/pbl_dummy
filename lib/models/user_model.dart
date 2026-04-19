enum UserRole { pencariKos, pemilikKos, none }

class UserModel {
  final String id;
  final String nama;
  final String email;
  final UserRole role;
  final bool isLoggedIn;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.isLoggedIn = false,
  });

  factory UserModel.guest() {
    return UserModel(
      id: '',
      nama: '',
      email: '',
      role: UserRole.none,
      isLoggedIn: false,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: _parseRole(json['role'] ?? ''),
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }

  static UserRole _parseRole(String role) {
    switch (role) {
      case 'pencariKos':
        return UserRole.pencariKos;
      case 'pemilikKos':
        return UserRole.pemilikKos;
      default:
        return UserRole.none;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'role': role.toString(),
      'isLoggedIn': isLoggedIn,
    };
  }
}