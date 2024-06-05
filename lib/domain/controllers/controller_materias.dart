import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/models/dias.dart';
import 'package:maestros_master/domain/models/estudiante.dart';

class MateriasController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista de materias observables
  var materias = <Materia>[].obs;

  // Usuario actual
  late String currentUserId;


  // Método para establecer el ID del usuario actual
  void setCurrentUserId(String userId) {
    currentUserId = userId;
  }

  // Método para obtener materias de Firestore
  Future<List<Materia>> fetchMaterias(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('materias')
          .where('idUsuario', isEqualTo: userId)
          .get();

      List<Materia> fetchedMaterias = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        List<Dia> dias = (data['dias'] as List).map((dia) {
          return Dia.fromMap(dia as Map<String, dynamic>);
        }).toList();
        List<Estudiante> estudiantes = (data['estudiantes'] as List).map((estudiante) {
          return Estudiante.fromMap(estudiante as Map<String, dynamic>);
        }).toList();

        return Materia(
          idMateria: doc.id,
          nombre: data['nombre'],
          idUsuario: data['idUsuario'],
          dias: dias,
          estudiantes: estudiantes,
        );
      }).toList();

      materias.assignAll(fetchedMaterias);
      return fetchedMaterias;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las materias: $e');
      return [];
    }
  }

  // Método para agregar una materia a Firestore
  Future<void> addMateria(Materia materia) async {
    try {
      await _firestore.collection('materias').doc(materia.idMateria).set({
        'nombre': materia.nombre,
        'idUsuario': materia.idUsuario,
        'dias': materia.dias.map((dia) => dia.toMap()).toList(),
        'estudiantes': materia.estudiantes.map((estudiante) => estudiante.toMap()).toList(),
      });

      materias.add(materia);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar la materia: $e');
    }
  }

  // Método para eliminar una materia de Firestore
  Future<void> deleteMateria(String idMateria) async {
    try {
      await _firestore.collection('materias').doc(idMateria).delete();
      materias.removeWhere((materia) => materia.idMateria == idMateria);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la materia: $e');
    }
  }

  // Método para actualizar una materia en Firestore
  Future<void> updateMateria(Materia materia) async {
    try {
      await _firestore.collection('materias').doc(materia.idMateria).update({
        'nombre': materia.nombre,
        'idUsuario': materia.idUsuario,
        'dias': materia.dias.map((dia) => dia.toMap()).toList(),
        'estudiantes': materia.estudiantes.map((estudiante) => estudiante.toMap()).toList(),
      });

      int index = materias.indexWhere((m) => m.idMateria == materia.idMateria);
      if (index != -1) {
        materias[index] = materia;
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la materia: $e');
    }
  }

  // Método para agregar un estudiante a una materia
  Future<bool> addEstudianteToMateria(String idMateria, Estudiante estudiante) async {
    try {
      int materiaIndex = materias.indexWhere((m) => m.idMateria == idMateria);
      if (materiaIndex != -1) {
        String existingCedula = estudiante.cedula;
        bool cedulaExists = materias[materiaIndex].estudiantes.any((est) => est.cedula == existingCedula);
        if (cedulaExists) {
          Get.snackbar('Error', 'La cédula ya existe');
          return false;
        }
        
        materias[materiaIndex].estudiantes.add(estudiante);

        await _firestore.collection('materias').doc(idMateria).update({
          'estudiantes': materias[materiaIndex].estudiantes.map((est) => est.toMap()).toList(),
        });

        materias.refresh();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar el estudiante: $e');
      return false;
    }
  }



  // Método para obtener estudiantes de una materia
  List<Estudiante> getEstudiantesFromMateria(String idMateria) {
    int materiaIndex = materias.indexWhere((m) => m.idMateria == idMateria);
    if (materiaIndex != -1) {
      return materias[materiaIndex].estudiantes;
    }
    return [];
  }

  // Método para consultar un estudiante de una materia
  Estudiante? getEstudianteFromMateria(String idMateria, String cedula) {
    int materiaIndex = materias.indexWhere((m) => m.idMateria == idMateria);
    if (materiaIndex != -1) {
      try {
        return materias[materiaIndex].estudiantes.firstWhere((est) => est.cedula == cedula);
      } catch (e) {
        return null; // Retorna null si no se encuentra el estudiante
      }
    }
    return null;
  }


  // Método para eliminar un estudiante de una materia
  Future<void> removeEstudianteFromMateria(String idMateria, String idEstudiante) async {
    try {
      int materiaIndex = materias.indexWhere((m) => m.idMateria == idMateria);
      if (materiaIndex != -1) {
        materias[materiaIndex].estudiantes.removeWhere((est) => est.idEstudiante == idEstudiante);

        await _firestore.collection('materias').doc(idMateria).update({
          'estudiantes': materias[materiaIndex].estudiantes.map((est) => est.toMap()).toList(),
        });

        materias.refresh();
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el estudiante: $e');
    }
  }

  Future<void> updateEstudiante(String idMateria, Estudiante updatedEstudiante) async {
    try {
      int materiaIndex = materias.indexWhere((m) => m.idMateria == idMateria);
      if (materiaIndex != -1) {
        int estudianteIndex = materias[materiaIndex].estudiantes.indexWhere((est) => est.idEstudiante == updatedEstudiante.idEstudiante);
        if (estudianteIndex != -1) {
          materias[materiaIndex].estudiantes[estudianteIndex] = updatedEstudiante;

          await _firestore.collection('materias').doc(idMateria).update({
            'estudiantes': materias[materiaIndex].estudiantes.map((est) => est.toMap()).toList(),
          });

          materias.refresh();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el estudiante: $e');
    }
  }

}
