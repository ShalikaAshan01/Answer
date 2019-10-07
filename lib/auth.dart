import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String firstname, String surname);
  Future<String> currentUser();
  Future<void> signOut();
  Stream<String> get onAuthStateChanged;
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => user?.uid);
  }

  Future<String> signInWithEmailAndPassword(
      final String email, String password) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user.uid;
  }

  Future<String> createUserWithEmailAndPassword(final String email,
      String password, String firstname, String surname) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    Firestore.instance
        .collection('users')
        .document(user.user.uid)
        .setData({'firstname': firstname, 'surname': surname, 'email': email});
    return user.user.uid;
  }

  Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
