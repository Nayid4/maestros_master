import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maestros_master/domain/controllers/controllerAsistencia.dart';
import 'package:maestros_master/domain/controllers/controllerDate.dart';
import 'package:maestros_master/domain/controllers/controllerHorario.dart';
import 'package:maestros_master/domain/controllers/controllerMaterias.dart';
import 'package:maestros_master/domain/controllers/controllerStudent.dart';
import 'package:maestros_master/domain/controllers/controllerUsers.dart';
import 'package:maestros_master/domain/controllers/login_controller.dart';
import 'package:maestros_master/pages/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maestros_master/provider/login_provider.dart';
import 'package:maestros_master/provider/register_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(LoginProvider()); // Primero inicializa LoginProvider
  Get.put(RegisterProvider()); // Luego inicializa RegisterProvider

  Get.put(UsersController());
  Get.put(MateriasController());
  Get.put(DateController());
  Get.put(HorarioController());
  Get.put(StudentController());
  Get.put(AsistenciaController());
  Get.put(LoginController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        // Añadir otros providers aquí si es necesario
      ],
      child: const App(),
    ),
  );
}

//añadir options si quieres hacer el debug usando el navegador
//en caso de hacer el building directamente en el dispositio eliminar el object option

/*
 
*/