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
  bool _isObscured = true;

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
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        currentUser = userCredential.user;
        await _loadUserInfo();

        authStatus = AuthStatus.authenticated;
        notifyListeners();

        onSuccess();
      } else {
        _handleLoginError('No se encontró el email ingresado.', onError);
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          errorMsg = 'Correo o contraseña incorrecta.';
          break;
        default:
          errorMsg = e.message ?? 'Error desconocido';
      }
      _handleLoginError(errorMsg, onError);
    } catch (e) {
      _handleLoginError(e.toString(), onError);
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
      currentUser = user;
      await _loadUserInfo();
      authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  void toggleObscured() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  void _handleLoginError(String message, Function(String) onError) {
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
    onError(message);
  }

  // Nueva función para cerrar sesión
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      currentUser = null;
      userInfo = null;
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
    } catch (e) {
      // Manejar el error si es necesario
      print('Error al cerrar sesión: $e');
    }
  }
}
