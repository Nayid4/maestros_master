class Estudiante {
  String idEstudiante;
  String cedula;
  String nombre;
  String apellidos;

  Estudiante({
    required this.idEstudiante,
    required this.cedula,
    required this.nombre,
    required this.apellidos,
  });

  Map<String, dynamic> toMap() {
    return {
      'idEstudiante': idEstudiante,
      'cedula': cedula,
      'nombre': nombre,
      'apellidos': apellidos,
    };
  }

  factory Estudiante.fromMap(Map<String, dynamic> map) {
    return Estudiante(
      idEstudiante: map['idEstudiante'],
      cedula: map['cedula'],
      nombre: map['nombre'],
      apellidos: map['apellidos'],
    );
  }
}
