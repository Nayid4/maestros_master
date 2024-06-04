import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:maestros_master/domain/models/estudiante.dart';

class PeticionesEstudiantes {
  static final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<QuerySnapshot<Map<String, dynamic>>> cargarEstudiantes(
      idclass) async {
    var querySnapshot = await _db
        .collection('estudiantes')
        .where('idclass', isEqualTo: idclass)
        .get();

    return querySnapshot;
  }

  /*static Future<String> guardarEstudiantes(Estudiante e) async {
    try {
      await _db.collection('estudiantes').add({
        'nombres': e.nombre,
        'apellidos': e.apellidos,
        'idclass': e.classID,
        'id': e.id
      });
      return "Estudiante guardado";
    } catch (e) {
      return "No se pudo guardar";
    }
  }

  static Future<String> editarEstudiantes(Estudiante e) async {
    try {
      _db.collection('estudiantes').doc(e.id).update({
        'nombres': e.nombre,
        'apellidos': e.apellidos,
        'idclass': e.classID,
        'id': e.id
      });

      return "Estudiante actualizado";
    } catch (e) {
      return "No se pudo editar el Estudiante";
    }
  }

  static Future<String> eliminarEstudiantes(id) async {
    try {
      _db.collection('estudiantes').doc(id).delete();
      return "Estudiante eliminado";
    } catch (e) {
      return "No se pudo eliminar el estudiante";
    }
  }*/
}
