class Usuarios {
  final int? id;
  final String email;
  final String password;
  final String rol; 

  Usuarios({
    this.id,
    required this.email,
    required this.password,
    required this.rol,
  });

  factory Usuarios.fromMap(Map<String, dynamic> map) {
    return Usuarios(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      rol: map['rol'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password, 'rol': rol};
  }
}
