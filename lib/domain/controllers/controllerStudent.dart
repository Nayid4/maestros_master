import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/models/estudiante.dart';
import 'package:maestros_master/peticiones/PeticionesEstudiante.dart';

class StudentController extends GetxController {
  RxList<Estudiante> listaEstudiante = RxList<Estudiante>([]);
  RxString mensaje = "".obs;
  RxString idclass = "".obs;

  Future<void> guardarEstudiantes(nombre, apellidos, cedula) async {
    Estudiante e = Estudiante(
        nombre: nombre,
        apellidos: apellidos,
        id: cedula,
        classID: idclass.value);
    mensaje.value = await PeticionesEstudiantes.guardarEstudiantes(e);

    cargarEstudiantes();
  }

  Future<void> cargarEstudiantes() async {
    if (idclass.value.isNotEmpty) {
      List<Estudiante> lista = [];
      QuerySnapshot query =
          await PeticionesEstudiantes.cargarEstudiantes(idclass.value);

      Estudiante e;
      Object? datos;
      for (var doc in query.docs) {
        datos = doc.data();

      /*e = Estudiante(
            nombre: datos['nombres'],
            apellidos: datos['apellidos'],
            id: doc.id,
            classID: datos['idclass']);
        lista.add(e);*/
      }
      listaEstudiante.value = lista;
      mensaje.value = "Estudiantes cargados";
    } else {
      mensaje.value = "compruebe su conexion";
    }
  }

  Future<void> eliminarEstudiante(id) async {
    mensaje.value = await PeticionesEstudiantes.eliminarEstudiantes(id);
    cargarEstudiantes();
  }

  Future<void> editarEstudiante(Estudiante e) async {
    mensaje.value = await PeticionesEstudiantes.editarEstudiantes(e);
    cargarEstudiantes();
  }
}
