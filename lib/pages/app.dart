import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:maestros_master/configs/theme.dart';
import 'package:maestros_master/domain/models/materias.dart';
import 'package:maestros_master/pages/asistence/view_asistence.dart';
import 'package:maestros_master/pages/auth/login/login_get.dart';
import 'package:maestros_master/pages/auth/register/register_get.dart';
import 'package:maestros_master/pages/Schedule/ViewHorario.dart';
//import 'package:maestros_master/pages/maters/view_edit_materia.dart';
import 'package:maestros_master/pages/maters/edit_materia/edit_materia.dart';
import 'package:maestros_master/pages/maters/view_materias.dart';
import 'package:maestros_master/pages/actividades.dart';
import 'package:maestros_master/pages/home/home.dart';
import 'package:maestros_master/pages/students/view_students/view_student.dart';
//import 'package:maestros_master/pages/maters/view_add_materias.dart';
import 'package:maestros_master/pages/maters/add_materia/add_materia.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
//ViewaddMaterias

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "maestros",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [Locale('es'), Locale('Es')],
      locale: const Locale('es'),
      theme: Apptheme().theme(),
      home: FutureBuilder(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostrar una pantalla de carga mientras se verifica el estado de autenticación
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              // Usuario autenticado, redirigir a la pantalla de inicio de la aplicación
              return const Home();
            } else {
              // No hay usuario autenticado, redirigir a la pantalla de inicio de sesión
              return const LoginGet();
            }
          }
        },
      ),
      routes: {
        "/login": (context) => const LoginGet(),
        "/home": (context) => const Home(),
        "/materias": (context) => const ViewMaterias(),
        "/materiasAdd": (context) => const AddMateria(),
        "/editar-materia": (context) => EditMateria(materia: ModalRoute.of(context)!.settings.arguments as Materia),
        "/actividades": (context) => const Actividades(),
        "/horario": (context) => ViewHorario(),
        "/estudiantes": (context) => const ListStudent(),
        "/asistencia": (context) => const ViewAsistence(),
        "/registrarse": (context) => const RegisterGet()
      },
    );
  }
}