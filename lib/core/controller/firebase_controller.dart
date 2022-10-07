import 'package:chat_application/core/controller/database_controller.dart';
import 'package:chat_application/core/elements/custom_progressbar.dart';
import 'package:chat_application/core/models/user_model.dart';
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

  String? VerificationId;

  User? user;

  final databaseController = Get.put(DatabaseController());

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

  Future register(String email, password, UserModel userdata) async{

    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      user = FirebaseAuth.instance.currentUser;
      constance.Debug('user id => ${user!.uid}');
      UserModel userModel = UserModel(
          id: user!.uid,
          username: userdata.username,
          email: userdata.email,
          phonenumber: userdata.phonenumber,
          password: userdata.password,
          image: userdata.image
      );
      if(user!.uid.isNotEmpty){
        databaseController.users.doc(user!.uid).set(userModel.toMap());
      }
    } catch (firebaseAuthException) {
      constance.Debug(firebaseAuthException.toString());
    }

  }

  Future phone_authentication(String phonenumber) async{

    await auth.verifyPhoneNumber(
      phoneNumber: phonenumber,
        verificationCompleted: (PhoneAuthCredential credential) async{
          constance.Debug('Verification Complete ${credential.smsCode}');

          Get.toNamed(Routes.OTP);
        },
        verificationFailed: (FirebaseAuthException e) {
          if(e.code == 'invalid-phone-number'){
            constance.Debug('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {

          // PhoneAuthCredential credential  = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          // await auth.signInWithCredential(credential);
          constance.Debug("Verification Id = $verificationId");
          constance.Debug('code sent');
          this.VerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId){}
    );

  }

  Future verifyOTP(String otp) async{

    constance.Debug('Otp ==> ${otp}');

    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: VerificationId!,
        smsCode: otp
    );

    User? user = FirebaseAuth.instance.currentUser;

    if(phoneAuthCredential.smsCode != null){
      try {

        UserCredential userCredential = await user!.linkWithCredential(phoneAuthCredential);

        Get.offAllNamed(Routes.LOGIN);
        // constance.Debug(userCredential.credential!.token.toString());
      } on FirebaseAuthException catch (e) {
        if(e.code == 'provider-already-linked'){
          constance.Debug('Error ==> ${e}');
        }
      }
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