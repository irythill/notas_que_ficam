import 'package:flutter/material.dart';
import '../styles/app_fonts.dart';

class TitleAndDescription extends StatelessWidget {
  final String title;
  final String description;

  const TitleAndDescription({
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 140), // Espaço acima do título
        Text(
          title,
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300, // Define a largura do texto descritivo
          child: Text(
            description,
            style: AppTextStyles.bodyLarge,
            softWrap: true, // Garante quebra de linha
          ),
        ),
      ],
    );
  }
}
