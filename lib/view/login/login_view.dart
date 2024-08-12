import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../constant/app_constant.dart';
import '../../service/firebase_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 180,
                child: Image.asset(
                  'assets/images/localStuff.png',
                ),
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.grey.shade100), // Set your desired color
                  ),
                  onPressed: () {
                    _loginWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        child: Image.asset('assets/images/google.png'),
                      ),
                      Text(
                        'LOGIN WITH GOOGLE',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) return;

      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseService.signInWithCredential(credential);

      print('User UID: ${userCredential.user?.uid}');
      print('User Email: ${userCredential.user?.email}');
      print('User Display Name: ${userCredential.user?.displayName}');
      print('User Photo URL: ${userCredential.user?.photoURL}');

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstant.homeView,
        (route) => false,
      );
    } catch (error) {
      print('Login with Google Error: $error');
    }
  }
}
