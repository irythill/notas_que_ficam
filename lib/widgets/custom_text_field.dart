import 'package:flutter/material.dart';
import '../styles/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color fillColor;
  final Icon? prefixIcon;
  final Color? iconColor;
  // final Color? focusedBorderColor;

  const CustomTextField({
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.fillColor =
        AppColors.fillColor, // Cor de fundo padrão com transparência
    this.prefixIcon,
    this.iconColor,
    // this.focusedBorderColor = AppColors.primaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(color: iconColor),
                child: prefixIcon!,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
