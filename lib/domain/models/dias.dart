class Dia {
  final String idDia;
  late final String nombreDia;
  late final DateTime horaInicio;
  late final DateTime horaFin;

  Dia({
    required this.idDia,
    required this.nombreDia,
    required this.horaInicio,
    required this.horaFin,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDia': idDia,
      'nombreDia': nombreDia,
      'horaInicio': horaInicio.toIso8601String(),
      'horaFin': horaFin.toIso8601String(),
    };
  }

  factory Dia.fromMap(Map<String, dynamic> map) {
    return Dia(
      idDia: map['idDia'],
      nombreDia: map['nombreDia'],
      horaInicio: DateTime.parse(map['horaInicio']),
      horaFin: DateTime.parse(map['horaFin']),
    );
  }
}
