

import 'package:farmerconnect/global/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e){
      if (e.code =='email-already-in-use') {
        showToast(message: 'Bu e-posta adresi zaten kullanılıyor.');
      } else{
        showToast(message: 'Bir Hata oluştu: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e){
      print("Bir hata oluştu");
    }
    return null;
  }



}







