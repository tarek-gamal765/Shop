import 'package:flutter/material.dart';
import 'package:shop/main.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: startWidget,
      backgroundColor: Colors.white,
      duration: 3,
      imageSrc: 'assets/images/app_icon.png',
      imageSize: 150,
    );
  }
}
