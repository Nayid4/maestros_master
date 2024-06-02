class Users {
  final String nombres;
  final String apellidos;
  final String correo;
  final String foto;

  Users(
      {required this.nombres,
      required this.apellidos,
      required this.correo,
      required this.foto});

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      correo: data['correo'] ?? '',
      foto: data['foto'] ?? '',
    );
  }
}
