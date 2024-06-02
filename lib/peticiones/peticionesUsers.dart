import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:maestros_master/domain/controllers/controllerUsers.dart';

class PeticionesUser {
  static final fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UsersController _controller = UsersController();
  static Future<String> createUser(String email, String pass) async {
    try {
      final Credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      Map<String, dynamic> datos = {'email': email};
      _db.collection('user').add(datos);
    
      return "resgistro exitoso";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-passwork') {
        return ("the password provides is too weak");
      } else if (e.code == 'email-already-in-use') {
        return ("the account already exits for that email");
      }
    } catch (e) {
      return ("$e");
    }

    return "no paso nada";
  }

  static Future<UserCredential> iniciarSesion(String email, String pass) async {
    FirebaseAuth credential = FirebaseAuth.instance;
    return await credential.signInWithEmailAndPassword(
        email: email, password: pass);
  }

  static Future<void> consultarUsuario() async {}

  static void cerrarSesion() async {
    FirebaseAuth.instance.signOut();
  }

  static Future<void> consultarListaUsuarios() async {}
}
