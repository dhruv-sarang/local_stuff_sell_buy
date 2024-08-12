import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_constant.dart';
import '../../preference/pref_utils.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    var user = FirebaseAuth.instance.currentUser;

    Timer(const Duration(seconds: 3), () async {
      if (!PrefUtils.getOnBoardingStatus()) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppConstant.introView, (route) => false);
      } else if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppConstant.homeView, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppConstant.loginView, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 180,
          child: Opacity(
            opacity: 0.6,
            child: Container(
              height: 180,
              child: Image.asset(
                'assets/images/localStuff.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
