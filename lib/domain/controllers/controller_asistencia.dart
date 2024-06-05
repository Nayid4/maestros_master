import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/asistencia.dart';

class AsistenciaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var asistencias = <Asistencia>[].obs;

  // Método para obtener asistencias de Firestore
  Future<List<Asistencia>> fetchAsistencias(String idMateria) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('asistencias')
          .where('idMateria', isEqualTo: idMateria)
          .get();

      List<Asistencia> fetchedAsistencias = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Asistencia.fromMap(data);
      }).toList();

      asistencias.assignAll(fetchedAsistencias);
      return fetchedAsistencias;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las asistencias: $e');
      return [];
    }
  }

  // Método para agregar una asistencia a Firestore
  Future<void> addAsistencia(Asistencia asistencia) async {
    try {
      await _firestore.collection('asistencias').doc(asistencia.idAsistencia).set(asistencia.toMap());
      asistencias.add(asistencia);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar la asistencia: $e');
    }
  }

  // Método para actualizar una asistencia en Firestore
  Future<void> updateAsistencia(Asistencia asistencia) async {
    try {
      //print('idasistencia-1 ${asistencia.idAsistencia}');
      await _firestore.collection('asistencias').doc(asistencia.idAsistencia).update(asistencia.toMap());
      int index = asistencias.indexWhere((a) => a.idAsistencia == asistencia.idAsistencia);
      if (index != -1) {
        asistencias[index] = asistencia;
        //print('idasistencia ${index}');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la asistencia: $e');
    }
  }

  // Método para eliminar una asistencia de Firestore
  Future<void> deleteAsistencia(String idAsistencia) async {
    try {
      await _firestore.collection('asistencias').doc(idAsistencia).delete();
      asistencias.removeWhere((a) => a.idAsistencia == idAsistencia);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la asistencia: $e');
    }
  }

  // Método para actualizar el estado de asistencia de un estudiante
  Future<void> updateEstadoEstudiante(String idAsistencia, String idEstado, String nuevoEstado) async {
    try {
      //print('idsistencia-1 ${idAsistencia}');
      //print('idestado ${idEstado}');
      //print('estado ${nuevoEstado}');
      int asistenciaIndex = asistencias.indexWhere((a) => a.idAsistencia == idAsistencia);
      if (asistenciaIndex != -1) {
        //print('idsistencia ${asistenciaIndex}');
        Asistencia asistencia = asistencias[asistenciaIndex];
        int estadoIndex = asistencia.estadoEstudiantes.indexWhere((e) => e.idEstado == idEstado);
        if (estadoIndex != -1) {
          //print('idestado ${estadoIndex}');
          asistencia.estadoEstudiantes[estadoIndex].estado = nuevoEstado;
          await _firestore.collection('asistencias').doc(idAsistencia).update({
            'estadoEstudiantes': asistencia.estadoEstudiantes.map((e) => e.toMap()).toList(),
          });
          // Actualizar la lista observable
          asistencias[asistenciaIndex] = Asistencia(
            idAsistencia: asistencia.idAsistencia,
            idMateria: asistencia.idMateria,
            fecha: asistencia.fecha,
            estadoEstudiantes: List.from(asistencia.estadoEstudiantes),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el estado del estudiante: $e');
    }
  }
}
