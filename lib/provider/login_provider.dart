import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { notAuthenticated, checking, authenticated }

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus authStatus = AuthStatus.notAuthenticated;
  User? currentUser;
  Map<String, dynamic>? userInfo;
  bool _isObscured = true; // Nuevo

  // Getter para obtener el estado de visibilidad de la contraseña
  bool get isObscured => _isObscured;

  Future<void> loginUser({
    required String correo,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      authStatus = AuthStatus.checking;
      notifyListeners();

      final String correoLowerCase = correo.toLowerCase();
      final QuerySnapshot resultEmail = await _firestore
          .collection('user')
          .where('email', isEqualTo: correoLowerCase)
          .limit(1)
          .get();

      if (resultEmail.docs.isNotEmpty) {
        final String email = resultEmail.docs.first.get('email');
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        currentUser = userCredential.user;
        await _loadUserInfo();

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        onSuccess();
        return;
      }

      onError('No se encontró el email ingresado.');
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        onError('Correo o contraseña incorrecta.');
      } else {
        onError(e.toString());
      }
    } catch (e) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();

      onError(e.toString());
    }
  }

  Future<void> _loadUserInfo() async {
    if (currentUser == null) return;

    final DocumentSnapshot userDoc = await _firestore
        .collection('user')
        .doc(currentUser!.uid)
        .get();
    if (userDoc.exists) {
      userInfo = userDoc.data() as Map<String, dynamic>;
    } else {
      userInfo = null;
    }
  }

  Future<bool> checkUserAuthentication() async {
    authStatus = AuthStatus.checking;
    notifyListeners();

    final user = _auth.currentUser;

    if (user != null) {
      authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  // Método para alternar la visibilidad de la contraseña
  void toggleObscured() {
    _isObscured = !_isObscured;
    notifyListeners();
  }
}
