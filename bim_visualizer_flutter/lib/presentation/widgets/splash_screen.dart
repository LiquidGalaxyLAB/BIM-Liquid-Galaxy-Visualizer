import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bim_visualizer_flutter/presentation/widgets/on_boarding.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/logos.png', width: 1200.0, height: 1200.0),
      splashIconSize: 1200.0,
      backgroundColor: primaryColor,
      nextScreen: const OnBoarding(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(milliseconds: 400)
    );
  }
}