import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/preference/pref_utils.dart';
import 'package:local_stuff_sell_buy/routing/app_route.dart';
import 'package:local_stuff_sell_buy/theme/app_theme.dart';
import 'constant/app_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDOfswZoyFmBnc9T8n94ACOP7HQl12Utzo",
      appId: "1:593469651990:android:47f50a02426acc0d080937",
      messagingSenderId: "593469651990",
      projectId: "local-stuff-buy-and-sell",
      storageBucket: "local-stuff-buy-and-sell.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppConstant.splashView,
      theme: AppTheme(context),
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
