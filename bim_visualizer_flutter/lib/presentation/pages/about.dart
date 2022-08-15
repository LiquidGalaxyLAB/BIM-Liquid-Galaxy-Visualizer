import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:bim_visualizer_flutter/presentation/widgets/logos.dart';
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              //   child: Text(
              //     'BIM Liquid Galaxy Visualizer',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 30,
              //       color: Colors.grey.shade700
              //     ),
              //   ),
              // ),
              const Text(
                'Author: Vinícius Cavalcanti\n\nMentors: Karine Pistili & Marc Capdevila\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
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
              const Text(
                '\nOur partners',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const Logos(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'BIM Liquid Galaxy Visualizer is a tool developed\nfor the Google Summer Of Code 2022 alongside the Liquid Galaxy organization.\n\nThe idea behind this tool is to visualize BIM 3D models and their metadata\non the liquid galaxy rig system using an android device.\n\nUsers can open their own uploaded 3D models alongside with their metadata or use the demo models. When a model is opened into the galaxy a controller is showed with some transform movements (rotation, translation and scale)',
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}