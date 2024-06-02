import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maestros_master/domain/models/Materias.dart';

import '../domain/models/listaAsistencia.dart';

class PeticionesAsistencia {
  static final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> GuardarAsistencia(List<Asistencia> l, Grupo g) async {
    try {
      DateTime fecha = DateTime.now();
      _db.collection('Asistencia').add({
        'nombreGrupo': g.nombre,
        'idGrupo': g.id,
        'fecha': fecha,
        'estudiantes': convertirAMap(l),
      });
      return "";
    } catch (e) {
      return "";
    }
  }

  static List<Map<String, dynamic>> convertirAMap(List<Asistencia> asistencia) {
    return asistencia.map((a) {
      return {
        'nombre': a.e.nombre,
        'apellido': a.e.apellidos,
        'asistio': a.asistio,
        'excusa': a.excusa,
      };
    }).toList();
  }
}
