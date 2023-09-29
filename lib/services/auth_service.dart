import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
//begin interactive sign in process
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtaiin auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //creat a new credential for user

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    //lets sign in
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
    }, SetOptions(merge: true));
    return userCredential;
  }
}
