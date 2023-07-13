import 'package:driver_app/screens/driver_car_reg_screen.dart';
import 'package:driver_app/screens/driver_home_screen.dart';
import 'package:driver_app/screens/login_Screen.dart';
import 'package:driver_app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Brand Regular'
      ),
      debugShowCheckedModeBanner: false,
      title: 'Driver App',
      home: const LoginScreen(),
      routes: {
        LoginScreen.idScreen : (context) => const LoginScreen(),
        SignUpScreen.idScreen : (context) => const SignUpScreen(),
        DriverCarRegScreen.idScreen : (context) => const DriverCarRegScreen(),
        DriverHomeScreen.idScreen : (context) => const DriverHomeScreen(),
      }
    );
  }
}
