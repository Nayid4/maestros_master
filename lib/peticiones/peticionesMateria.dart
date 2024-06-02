import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:maestros_master/domain/models/Materias.dart';
import 'package:maestros_master/domain/models/dias.dart';

class PeticionesMateria {
  static final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> guardarGrupo(Grupo grupo, uid) async {
    if (uid == null) {
      return "no inicio sesion";
    }
    try {
      var dias = convertirDiasAData(grupo.dias);
      await _db.collection('grupos').add({
        'idUser': uid,
        'nombre': grupo.nombre,
        'horario': dias,
      });
      return "Materia guardada";
    } on FirebaseException catch (e) {
      return e.code;
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> consultarMaterias(
      uid) async {
    var querySnapshot =
        await _db.collection('grupos').where('idUser', isEqualTo: uid).get();

    return querySnapshot;
  }

  static Future<String> actualizarGrupo(Grupo g, email) async {
    try {
      var dias = convertirDiasAData(g.dias);
      _db.collection('grupos').doc(g.id).update({
        'idUser': email,
        'nombre': g.nombre,
        'horario': dias,
      });
      return "Grupo modificado";
    } catch (e) {
      return "no se pudo mofificar";
    }
  }

  static Future<String> eliminargrupo(id) async {
    try {
      _db.collection("grupos").doc(id).delete();
      return "materia eliminada exitosamente";
    } catch (e) {
      return "no se pudo eliminar";
    }
  }

  static List<Map<String, dynamic>> convertirDiasAData(List<Dia> dias) {
    return dias.map((dia) {
      return {
        'nombre': dia.nombre,
        'horaInicio': "${dia.horaInicio.hour}:${dia.horaInicio.minute}",
        'horaFin': "${dia.horaFin.hour}:${dia.horaFin.minute}",
      };
    }).toList();
  }
}
