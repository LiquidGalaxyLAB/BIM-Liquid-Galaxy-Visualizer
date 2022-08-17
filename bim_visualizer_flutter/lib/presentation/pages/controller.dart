import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Controller extends StatefulWidget {
  const Controller({ Key? key, required this.galaxyBloc, required this.client, required this.server }) : super(key: key);

  final GalaxyBloc galaxyBloc;
  final SSHClient client;
  final Server server;

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String _url = 'https://bimlgvisualizer-server.loca.lt/galaxy?screen=0';
    return WebviewScaffold(
      url: _url,
      withJavascript: true,
      withZoom: false,
      hidden: false,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text(
          'Controller',
          style: TextStyle(fontSize: titleSize, color: primaryColor)
        ),
        leading: IconButton(
          color: primaryColor,
          icon: const Icon(Icons.close, size: iconSize),
          onPressed: () {
            String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close.sh ' + widget.server.password!;
            widget.galaxyBloc.add(GalaxyExecute(widget.client, command, true));
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          SizedBox(
            child: TextButton.icon(
              icon: const Icon(Icons.open_in_new, size: iconSize, color: primaryColor),
              label: const Text('OPEN LOGOS', style: TextStyle(color: primaryColor)),
              onPressed: () {
                String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'open_logos.sh ' + widget.server.password!;
                widget.galaxyBloc.add(GalaxyExecute(widget.client, command, false));
              },
            )
          ),
          SizedBox(
            child: TextButton.icon(
              icon: const Icon(Icons.remove, size: iconSize, color: primaryColor),
              label: const Text('CLEAN LOGOS', style: TextStyle(color: primaryColor)),
              onPressed: () {
                String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close_logos.sh ' + widget.server.password!;
                widget.galaxyBloc.add(GalaxyExecute(widget.client, command, false));
              },
            )
          ),
        ]
      ),
    );
  }
}