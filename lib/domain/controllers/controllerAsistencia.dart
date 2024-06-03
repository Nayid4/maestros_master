import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controller_materias.dart';
import 'package:maestros_master/domain/controllers/controllerStudent.dart';
import 'package:maestros_master/domain/models/listaAsistencia.dart';

import '../../peticiones/PeticionesAsistencia.dart';

class AsistenciaController extends GetxController {
  RxList<Asistencia> lista = RxList<Asistencia>([]);
  RxList<bool> asistio = RxList([]);
  RxList<bool> excusa = RxList([]);
  MateriasController mc = Get.find();
  StudentController ec = Get.find();
  RxString mensaje = "".obs;

  /*Future<void> guardarAsistencia(index) async {
    mensaje.value = await PeticionesAsistencia.GuardarAsistencia(
        lista, mc.MateriaFirebase[index]);
  }*/

  void cargarAsistencia() {
    for (var i = 0; i < ec.listaEstudiante.length; i++) {
      asistio.add(false);
      excusa.add(false);
    }
  }

  void cambiarAsistencia(int index, bool presente) {
    asistio[index] = presente;
    asistio.refresh();
  }

  void cambiarExcusa(int index, bool presente) {
    excusa[index] = presente;
    excusa.refresh();
  }
}
