import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/presentation/pages/home.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({ Key? key }) : super(key: key);

  final PageDecoration pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.black
    ),
    bodyTextStyle: TextStyle(
      fontSize: 20.0,
      color:Colors.black
    ),
    pageColor: primaryColor,
    imagePadding: EdgeInsets.symmetric(vertical: 10.0)
  );

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: 'Connect with\nthe Liquid Galaxy'.toUpperCase(),
        body: 'On the connection page, located on\nthe settings, type the IP address and password\nof the main device to establish a connection',
        image: Center(
          child:  Image.asset(
            'assets/images/onboarding/connect-lg.png',
            width: 450.0
          )
        ),
        decoration: pageDecoration
      ),
      PageViewModel(
        title: 'Execute tasks on the\nconnected RIG'.toUpperCase(),
        body: 'From the settings run tasks like: reboot, power off,\nopen and close partners logos and others',
        image: Center(
          child:  Image.asset(
            'assets/images/onboarding/tasks.png',
            width: 450.0
          )
        ),
        decoration: pageDecoration
      ),
      PageViewModel(
        title: 'Add your own models\nand metadatas'.toUpperCase(),
        body: 'Take a look at the project wiki (link to the repository\ncan be found on the about page), to learn how\nto generate the bundle of your own models\nand how to export your metadatas',
        image: Center(
          child:  Image.asset(
            'assets/images/onboarding/add-model.png',
            width: 450.0
          )
        ),
        decoration: pageDecoration
      ),
      PageViewModel(
        title: 'Open a model in the\nLiquid Galaxy'.toUpperCase(),
        body: 'On the home page, open the details of\nyour uploaded model or from a demo one\nand then, from the details page, open the model\nin the Liquid Galaxy',
        image: Center(
          child:  Image.asset(
            'assets/images/onboarding/open-model.png',
            width: 450.0
          )
        ),
        decoration: pageDecoration
      ),
      PageViewModel(
        title: 'Transform\nthe opened model'.toUpperCase(),
        body: 'With the controller,\nmove, scale or rotate the model',
        image: Center(
          child:  Image.asset(
            'assets/images/onboarding/controller.png',
            width: 450.0
          )
        ),
        decoration: pageDecoration
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        showSkipButton: true,
        skip: Text(
          'Skip'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black
          )
        ),
        next: Text(
          'Next'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            
          )
        ),
        done: Text(
          'Done'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            
          )
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).progressIndicatorTheme.color,
          color: Colors.black26,
          activeColors: [secondaryColor, secondaryColor, secondaryColor, secondaryColor, secondaryColor],
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
          )
        ),
        onSkip: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Home()
            )
          );
        },
        onDone: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const Home();
              }
            )
          );
        },
        pages: getPages()
      )
    );
  }
}