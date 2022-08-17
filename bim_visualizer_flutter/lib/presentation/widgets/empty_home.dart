import 'package:flutter/material.dart';

class EmptyHome extends StatelessWidget {
  const EmptyHome({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 150.0,
              height: 150.0,
              child:  Image.asset(
                'assets/images/no-data.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Text(
            'No models found.\nEnsure that the server is up and running',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          )
        ]
      )
    );
  }
}