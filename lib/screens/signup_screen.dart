import 'package:driver_app/methods/auth_methods.dart';
import 'package:driver_app/screens/driver_car_reg_screen.dart';
import 'package:driver_app/screens/login_Screen.dart';
import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/dimensions.dart';
import 'package:driver_app/widgets/auth_buttons.dart';
import 'package:driver_app/widgets/custom_text_form_field.dart';
import 'package:driver_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const String idScreen = 'signupScreen';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final RegExp emailRegExp = RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""");
  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _phoneTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  bool passToggle = true;


  @override
  void dispose() {
    super.dispose();
    _usernameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _phoneTextEditingController.dispose();
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
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: const AssetImage('images/logo.png'),
                  width: MediaQuery.of(context).size.width*0.6,
                  height: MediaQuery.of(context).size.height*0.3,
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Text('Register as Driver',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width*headingOneSize,
                fontFamily: 'Brand Bold'
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                key:_registerFormKey ,
                  child: Column(
                    children: [
                      CustomTextFormField(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textEditingController: _usernameTextEditingController,
                          validate: (value) {
                            if(value!.isEmpty){
                              return 'Enter username';
                            }
                            else if(value.length < 3){
                              return 'Username should be at least 4 characters';
                            }
                            return null;
                          },),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      CustomTextFormField(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textEditingController: _emailTextEditingController,
                          validate: (value) {
                            if(value!.isEmpty){
                              return 'Enter your email';
                            }
                            else if(!emailRegExp.hasMatch(value)){
                              return 'Enter valid email';
                            }
                            return null;
                          },),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      CustomTextFormField(
                          labelText: 'Phone',
                          hintText: 'Enter your phone number',
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          textEditingController: _phoneTextEditingController,
                          validate: (value) {
                            if(value!.isEmpty){
                              return 'Enter phone number';
                            }
                            else if(value.trim().length < 11){
                              return 'Format phone number as 03001234567';
                            }
                            return null;
                          },),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      CustomTextFormField(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          obscureText: passToggle,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textEditingController: _passwordTextEditingController,
                          validate: (value) {
                            if(value!.isEmpty){
                              return 'Enter password';
                            }
                            else if(value.length < 5){
                              return 'Password should be at least 6 characters';
                            }
                            return null;
                          },
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passToggle = !passToggle;
                            });
                          },
                          child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      AuthButton(
                          onPressed: () async{
                            if(_registerFormKey.currentState!.validate()){
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const ProgressDialog(dialogText: 'Signing up, please wait...'),);
                              String status = await AuthMethods().signupUser(
                                  username: _usernameTextEditingController.text.trim(),
                                  email: _emailTextEditingController.text.trim(),
                                  phone: _phoneTextEditingController.text.trim(),
                                  password: _passwordTextEditingController.text.trim());
                              if(status == 'success'){
                                _usernameTextEditingController.clear();
                                _emailTextEditingController.clear();
                                _phoneTextEditingController.clear();
                                _passwordTextEditingController.clear();
                                // ignore: use_build_context_synchronously
                                Navigator.pushNamedAndRemoveUntil(context, DriverCarRegScreen.idScreen, (route) => false);
                              }
                              else{
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
                              }
                            }
                          },
                          buttonTitle: 'Sign up')
                    ],
                  )),
            ),
            TextButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: const Text('Already have an account? Login here',
                  style: TextStyle(
                    color: authTextButtonColor
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
