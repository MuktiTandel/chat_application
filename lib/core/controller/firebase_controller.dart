import 'package:chat_application/core/elements/custom_progressbar.dart';
import 'package:chat_application/core/routes/app_routes.dart';
import 'package:chat_application/core/utils/constance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseController extends GetxController {

  FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn();

  static FirebaseController instance = Get.find();

  late Rx<User?> firebaseUser;

  late Rx<GoogleSignInAccount?> googleSignInAccount;
  
  Constance constance = Constance();

  ProgressDialog progressDialog = ProgressDialog();

  @override
  void onReady() {
    super.onReady();

    firebaseUser = Rx<User?>(auth.currentUser);

    googleSignInAccount = Rx<GoogleSignInAccount?>(googleSignIn.currentUser);

    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, (callback) => null);

    googleSignInAccount.bindStream(googleSignIn.onCurrentUserChanged);
    ever(googleSignInAccount, (callback) => null);

  }

  setInitialScreen(User? user){

    if(user != null){
      Get.offAllNamed(Routes.HOME);
    }else{
      Get.offAllNamed(Routes.LOGIN);
    }

  }

  setInitailScreenGoogle(GoogleSignInAccount? googleSignInAccount){

    constance.Debug(googleSignInAccount.toString());

    if(googleSignInAccount != null){
      Get.offAllNamed(Routes.HOME);
    }else {
      Get.offAllNamed(Routes.LOGIN);
    }

  }

  void signInWithGoogle() async{

    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if(googleSignInAccount != null){

        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken
        );

        await auth.signInWithCredential(credential)
          .catchError((onErr) => constance.Debug(onErr));

        Get.offAllNamed(Routes.HOME);

      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      constance.Debug(e.toString());
    }

  }

  void signInWithFacebook() async{

    try {
      final result = await FacebookAuth.instance.login();

      if(result != null){

        final AuthCredential authCredential = FacebookAuthProvider.credential(result.accessToken!.token);

        await auth.signInWithCredential(authCredential);

        Get.offAllNamed(Routes.HOME);
      }

    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      constance.Debug(e.toString());
    }
  }

  void register(String email, password) async{

    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(Routes.OTP);
    } catch (firebaseAuthException) {
      constance.Debug(firebaseAuthException.toString());
    }

  }

  void login(String email,password) async{

    try {
      progressDialog.show();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(Routes.HOME);
      progressDialog.hide();
    } catch (e) {
      constance.Debug(e.toString());
    }

  }

  void signOut() async {
    await auth.signOut();
  }

}