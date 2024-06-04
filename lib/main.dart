import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'domain/controllers/controller_materias.dart';
import 'domain/controllers/login_controller.dart';
import 'provider/login_provider.dart';
import 'provider/register_provider.dart';
import 'pages/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialización de proveedores y controladores
  Get.put(MateriasController());
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

// Añadir options si quieres hacer el debug usando el navegador
// En caso de hacer el building directamente en el dispositivo eliminar el object option
