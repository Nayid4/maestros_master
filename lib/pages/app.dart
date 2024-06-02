import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:maestros_master/configs/theme.dart';
import 'package:maestros_master/pages/auth/login/login_get.dart';
import 'package:maestros_master/pages/auth/register/register_get.dart';
import 'package:maestros_master/pages/Schedule/ViewHorario.dart';
import 'package:maestros_master/pages/maters/View_Grupos.dart';
import 'package:maestros_master/pages/actividades.dart';
import 'package:maestros_master/pages/home/home.dart';
import 'package:maestros_master/pages/students/View_List_Assistance.dart';
import 'package:maestros_master/pages/students/View_List_Studen.dart';
import 'package:maestros_master/pages/maters/View_Add_Materias.dart';
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
        "/materias": (context) => const View_grupos(),
        "/materiasAdd": (context) => const AddMaterias(),
        "/actividades": (context) => const Actividades(),
        "/horario": (context) => ViewHorario(),
        "/listas": (context) => const ListStudent(),
        "/listaAsistencia": (context) => const ListAssistanceStudent(),
        "/registrarse": (context) => const RegisterGet()
      },
    );
  }
}