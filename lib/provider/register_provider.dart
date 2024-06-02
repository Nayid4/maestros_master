import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String userCollection = 'user';

  bool _isObscured = true;
  bool get isObscured => _isObscured;

  void toggleObscured() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String token,
    required DateTime createdAt,
    required void Function(String) onError,
    required void Function() onSuccess, // Agregado onSuccess
  }) async {
    try {
      final String emailLowerCase = email.toLowerCase();
      final bool userExists = await _checkUserExist(emailLowerCase);

      if (userExists) {
        onError('El usuario ya existe');
        return;
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        onError('Error al obtener la información del usuario');
        return;
      }

      await _saveUserToFirestore(user, emailLowerCase, createdAt);
      onSuccess(); // Llama a onSuccess cuando el registro es exitoso
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e, onError);
    } catch (e) {
      onError('Error al registrar el usuario: ${e.toString()}');
    }
  }

  Future<bool> _checkUserExist(String email) async {
    final QuerySnapshot result = await _firestore
        .collection(userCollection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<void> _saveUserToFirestore(User user, String email, DateTime createdAt) async {
    final userDatos = {
      'id': user.uid,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };

    await _firestore.collection(userCollection).doc(user.uid).set(userDatos);
  }

  void _handleFirebaseAuthError(FirebaseAuthException e, void Function(String) onError) {
    switch (e.code) {
      case 'weak-password':
        onError('La contraseña es muy débil');
        break;
      case 'email-already-in-use':
        onError('El email ya está en uso');
        break;
      default:
        onError('Error: ${e.message}');
        break;
    }
  }
}
