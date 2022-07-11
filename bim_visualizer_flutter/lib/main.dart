import 'package:bim_visualizer_flutter/presentation/pages/home.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

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
        home: const Home(),
      )
    );
  }
}