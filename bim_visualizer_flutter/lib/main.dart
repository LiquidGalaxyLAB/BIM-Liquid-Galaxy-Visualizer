import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bim_visualizer_flutter/presentation/pages/home.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/presentation/widgets/logos.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  // load dotenv
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: primaryColor
        ),
        home: const SplashScreen()
      )
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const SingleChildScrollView(
        child: Logos(),
      ),
      backgroundColor: primaryColor,
      splashIconSize: 350,
      nextScreen: const Home(),
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(milliseconds: 400)
    );
  }
}