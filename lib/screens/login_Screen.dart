import 'package:driver_app/methods/auth_methods.dart';
import 'package:driver_app/methods/database_methods.dart';
import 'package:driver_app/screens/driver_car_reg_screen.dart';
import 'package:driver_app/screens/driver_home_screen.dart';
import 'package:driver_app/screens/signup_screen.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/dimensions.dart';
import 'package:driver_app/widgets/auth_buttons.dart';
import 'package:driver_app/widgets/custom_text_form_field.dart';
import 'package:driver_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = 'loginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final RegExp emailRegExp = RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""");
  bool passToggle = true;

  @override
  void dispose() {
    super.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage('images/logo.png'),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              'Login as Driver',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * headingOneSize,
                  fontFamily: 'Brand Bold'),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _loginFormKey,
                  child: Column(
                children: [
                  CustomTextFormField(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textEditingController: _emailTextEditingController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      } else if (!emailRegExp.hasMatch(value)) {
                        return 'Enter correct email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  CustomTextFormField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    obscureText: passToggle,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textEditingController: _passwordTextEditingController,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      } else if (value.length < 6) {
                        return 'Password should not be less then 6 characters.';
                      }
                      return null;
                    },
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                        passToggle ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  AuthButton(onPressed: () async{
                    if(_loginFormKey.currentState!.validate()){
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const ProgressDialog(dialogText: 'Logging in, please wait...'),);
                      String status = await AuthMethods().loginUser(
                          email: _emailTextEditingController.text.trim(),
                          password: _passwordTextEditingController.text.trim());
                      if(status == 'success'){
                        _emailTextEditingController.clear();
                        _passwordTextEditingController.clear();
                        bool checkUserIsDriver = await DatabaseMethods.checkUserIsDriver();
                        if(checkUserIsDriver){
                          bool checkDriverVehicleData = await DatabaseMethods.checkDriverHasVehicleData();
                          if(checkDriverVehicleData){
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(context, DriverHomeScreen.idScreen, (route) => false);
                          }
                          else{
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(context, DriverCarRegScreen.idScreen, (route) => false);
                          }
                        }else{
                          FirebaseAuth.instance.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This user is not registered as driver')));
                        }
                      }else{
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
                      }
                    }
                  },
                      buttonTitle: 'Log In')
                ],
              )),
            ),
            TextButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, SignUpScreen.idScreen, (route) => false);
                },
                child: const Text('Do not have an account? Register here',
                  style: TextStyle(
                    color: authTextButtonColor
                  ),
                ),

            )
          ],
        ),
      ),
    );
  }
}
