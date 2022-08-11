import 'package:bim_visualizer_flutter/presentation/widgets/logos.dart';
import 'package:bim_visualizer_flutter/presentation/pages/home.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child:  Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                  width: screenSize.width / 3,
                ),
              ]
            ),
            const Logos()
          ]
        ),
      ),
      backgroundColor: primaryColor,
      splashIconSize: 550,
      nextScreen: const Home(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(milliseconds: 400)
    );
  }
}