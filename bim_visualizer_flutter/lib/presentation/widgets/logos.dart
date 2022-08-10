import 'package:flutter/material.dart';

class Logos extends StatelessWidget {
  const Logos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100 * 0.05, vertical: 30),
              child: SizedBox(
                child:  Image.asset(
                  'assets/images/lg.png',
                  fit: BoxFit.contain,
                ),
                width: screenSize.width / 6,
              ),
            ),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Center(
                child: Image.asset(
                  'assets/images/gsoc.png',
                  fit: BoxFit.contain,
                ),
              ),
              width: screenSize.width / 6,
            ),
            SizedBox(
              child: Center(
                child: Image.asset(
                  'assets/images/lgeu.png',
                  fit: BoxFit.contain,
                ),
              ),
              width: screenSize.width / 6,
            ),
            SizedBox(
              child: Center(
                child: Image.asset(
                  'assets/images/lglab.png',
                  fit: BoxFit.contain,
                ),
              ),
              width: screenSize.width / 6,
            ),
            SizedBox(
              child: Center(
                child: Image.asset(
                  'assets/images/tic.png',
                  fit: BoxFit.contain,
                ),
              ),
              width: screenSize.width / 6,
            ),
            SizedBox(
              child: Center(
                child: Image.asset(
                  'assets/images/pcital.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              width: screenSize.width / 6,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100 * 0.05, vertical: 30),
              child: SizedBox(
                child:  Image.asset(
                  'assets/images/facens.png',
                  fit: BoxFit.contain,
                ),
                width: screenSize.width / 5,
              ),
            ),
          ],
        )
      ],
    );
  }
}