import 'package:driver_app/utils/colors.dart';
import 'package:driver_app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final Widget suffixIcon;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;
  final String? Function(String?)? validate;

  const CustomTextFormField({Key? key,
    required this.labelText,
    required this.hintText,
    required this.textInputType,
    this.obscureText = false,
    this.suffixIcon = const SizedBox(),
    required this.textInputAction,
    required this.textEditingController,
    required this.validate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      obscureText: obscureText,
      controller: textEditingController,
      decoration: InputDecoration(
        fillColor: textFieldBgColor,
        filled: true,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width*textFieldLabelSize,
          color: textFieldLabelColor
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: textFieldHintColor,
          fontSize: MediaQuery.of(context).size.width*textFieldHintSize
        ),
        errorMaxLines: 2,
        suffixIcon: suffixIcon,
      ),
      textInputAction: textInputAction,
      validator: validate,
    );
  }
}
