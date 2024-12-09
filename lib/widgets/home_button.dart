import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_fonts.dart';

enum ButtonType { elevated, outlined }

class HomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final BorderSide? borderSide;
  final ButtonType buttonType;

  const HomeButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.borderSide,
    this.buttonType = ButtonType.elevated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: buttonType == ButtonType.elevated
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: borderSide,
              ),
              child: Text(
                text,
                style: AppTextStyles.buttonText.copyWith(color: textColor),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: borderSide,
              ),
              child: Text(
                text,
                style: AppTextStyles.buttonText.copyWith(color: textColor),
              ),
            ),
    );
  }
}
