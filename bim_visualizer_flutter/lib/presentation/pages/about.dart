import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title:  const Text(
          'About',
          style: TextStyle(fontSize: titleSize, color: primaryColor)
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100 * 0.05, vertical: 30),
                    child: SizedBox(
                      child:  Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                      width: screenSize.width / 3,
                    ),
                  ),
                ]
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(
                      text: 'Author: Vinícius Cavalcanti\nMentors: Karine Pistili & Marc Capdevila\nLleida Liquid Galaxy LAB Support: ',
                      style: TextStyle(fontSize: 17),
                    ),
                    TextSpan(
                      text: 'Pau Francino\n',
                      style: const TextStyle(color: Colors.blue, fontSize: 17),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        final url = Uri.parse('mailto: paufrancino99@gmail.com');
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          throw 'Could not launch $url';
                        }
                      }
                    ),
                  ]
                )
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Email\t\t',
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        final url = Uri.parse('mailto: hnrquevini@gmail.com');
                        if (!await launchUrl(url)) {
                          throw 'Could not launch $url';
                        }
                      }
                    ),
                    TextSpan(
                      text: 'GitHub\t\t',
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        final url = Uri.parse('https://github.com/hvini');
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          throw 'Could not launch $url';
                        }
                      }
                    ),
                    TextSpan(
                      text: 'Repository\t\t',
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        final url = Uri.parse('https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer');
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          throw 'Could not launch $url';
                        }
                      }
                    ),
                    TextSpan(
                      text: 'Organization',
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        final url = Uri.parse('https://www.liquidgalaxy.eu/');
                        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                          throw 'Could not launch $url';
                        }
                      }
                    ),
                  ]
                )
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  '\nOur partners',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logos2.png',
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                    children: [
                      const TextSpan(
                        text: 'BIM Liquid Galaxy Visualizer is a tool developed\nfor the Google Summer Of Code 2022 alongside the Liquid Galaxy organization.\n\nThe idea behind this tool is to visualize BIM 3D models on the\nLiquid Galaxy rig system using an android device.\n\nUsers can open their own uploaded 3D models or use the demo models. When a model is opened\ninto the galaxy a controller is showed with some transform movements (rotation, translation and scale).\n\nThe house demo model can be found on the revit samples and\nthe truck at the ',
                      ),
                      TextSpan(
                        text: 'bimobject platform',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () async {
                          final url = Uri.parse('https://www.bimobject.com/pt-br/bimobject-th-x-thai-obayashi/product/BIMobjectTHxThaiObayashi_SmallTruckLoaderCrane');
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        }
                      )
                    ]
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      child:  Image.asset(
                        'assets/images/unity.png',
                        fit: BoxFit.contain,
                      ),
                      width: screenSize.width / 6,
                    ),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}