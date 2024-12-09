import 'package:flutter/material.dart';

class HomeLogo extends StatelessWidget {
  final double width;
  final double height;
  final double topPadding;

  const HomeLogo({
    this.width = 250,
    this.height = 250,
    this.topPadding = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Image.asset(
        'assets/images/nqf_logo.png',
        width: width,
        height: height,
      ),
    );
  }
}
