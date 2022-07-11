import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class Meta extends StatefulWidget {
  const Meta({Key? key, required this.galaxyBloc, required this.client}) : super(key: key);

  final GalaxyBloc galaxyBloc;
  final SSHClient client;

  @override
  State<Meta> createState() => _MetaState();
}

class _MetaState extends State<Meta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: primaryColor,
          icon: const Icon(Icons.arrow_back, size: iconSize),
          onPressed: () {
            String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close.sh';
            widget.galaxyBloc.add(GalaxyExecute(widget.client, command));
            Navigator.pop(context);
          },
        ),
        backgroundColor: secondaryColor,
        title: const Text(
          'Meta',
          style: TextStyle(fontSize: titleSize, color: primaryColor)
        ),
        actions: <Widget>[
          SizedBox(
            width: biggerLeftSpacing,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close, size: iconSize, color: primaryColor),
              onPressed: () {
                String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close.sh';
                widget.galaxyBloc.add(GalaxyExecute(widget.client, command));
                Navigator.pop(context);
              }
            )
          )
        ]
      ),
      body: Center(
        child: Text('Meta'),
      ),
    );
  }
}