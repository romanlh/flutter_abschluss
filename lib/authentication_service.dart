import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      //TODO Get User Info here

      return "Signed in";
    } on FirebaseAuthException catch (e) {
      var em = e.message;
      print("em = $em");
      return e.message;
    }
  }

  Future<String> signUp(
      {String email, String password, String username}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> newDisplayName(String newDisplayName) async {
    _firebaseAuth.currentUser.updateProfile(displayName: newDisplayName);
    await _firebaseAuth.currentUser.reload();
    print("Username updated to $newDisplayName");
  }
}
