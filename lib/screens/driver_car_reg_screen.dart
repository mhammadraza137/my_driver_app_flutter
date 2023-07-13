import 'package:driver_app/methods/auth_methods.dart';
import 'package:driver_app/methods/database_methods.dart';
import 'package:driver_app/screens/driver_home_screen.dart';
import 'package:driver_app/utils/dimensions.dart';
import 'package:driver_app/widgets/auth_buttons.dart';
import 'package:driver_app/widgets/custom_text_form_field.dart';
import 'package:driver_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';

class DriverCarRegScreen extends StatefulWidget {
  static const String idScreen = 'driverCarRegScreen';
  const DriverCarRegScreen({Key? key}) : super(key: key);

  @override
  State<DriverCarRegScreen> createState() => _DriverCarRegScreenState();
}

class _DriverCarRegScreenState extends State<DriverCarRegScreen> {
  final GlobalKey<FormState> _carDetailsFormKey = GlobalKey<FormState>();
  final TextEditingController _carModelTextEditingController = TextEditingController();
  final TextEditingController _carNumberTextEditingController = TextEditingController();
  final TextEditingController  _carColorTextEditingController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _carModelTextEditingController.dispose();
    _carNumberTextEditingController.dispose();
    _carColorTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Text('Enter Car Details',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width*headingOneSize,
                fontFamily: 'Brand Bold'
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                  key: _carDetailsFormKey,
                  child: Column(
                children: [
                  CustomTextFormField(
                      labelText: 'Model',
                      hintText: 'Enter car model',
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textEditingController: _carModelTextEditingController ,
                      validate: (value) {
                        if(value!.trim().isEmpty){
                          return 'Enter car model';
                        }
                        return null;
                      },),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                  CustomTextFormField(
                      labelText: 'Number',
                      hintText: 'Enter car number',
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textEditingController: _carNumberTextEditingController,
                      validate: (value) {
                        if(value!.trim().isEmpty){
                          return 'Enter car number';
                        }
                        return null;
                      },),
                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                  CustomTextFormField(
                      labelText: 'Color',
                      hintText: 'Enter car color',
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textEditingController: _carColorTextEditingController,
                      validate: (value){
                        if(value!.trim().isEmpty){
                          return 'please enter  your car color';
                        }
                        return null;
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  AuthButton(
                      onPressed: () async{
                        if(_carDetailsFormKey.currentState!.validate()){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ProgressDialog(dialogText: 'Saving details...'),);
                          String status = await DatabaseMethods.saveCarDetails(
                              _carModelTextEditingController.text.trim(),
                              _carNumberTextEditingController.text.trim(),
                              _carColorTextEditingController.text.trim()
                          );
                          if(status == 'success'){
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(context, DriverHomeScreen.idScreen, (route) => false);
                          }
                          else{
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status)));
                          }
                        }
                      },
                      buttonTitle: 'Submit')
                ],
              )),
            ),
          ],
        ),
      )
    );
  }
}
