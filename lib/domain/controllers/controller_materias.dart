import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/domain/models/dias.dart';

class MateriasController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista de materias observables
  var materias = <Materia>[].obs;

  // Usuario actual
  late String currentUserId;

  @override
  void onInit() {
    super.onInit();
  }

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

        return Materia(
          idMateria: doc.id,
          nombre: data['nombre'],
          idUsuario: data['idUsuario'],
          dias: dias,
        );
      }).toList();

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
      });

      int index = materias.indexWhere((m) => m.idMateria == materia.idMateria);
      if (index != -1) {
        materias[index] = materia;
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar la materia: $e');
    }
  }
}
