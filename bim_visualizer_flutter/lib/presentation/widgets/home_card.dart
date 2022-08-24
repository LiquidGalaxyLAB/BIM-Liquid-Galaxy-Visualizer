import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({ Key? key, required this.bim, required this.connected, required this.galaxyBloc, required this.client }) : super(key: key);

  final Bim bim;
  final bool connected;
  final GalaxyBloc galaxyBloc;
  final SSHClient client;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            trailing: TextButton(
              child: const Text(
                'VIEW',
                style: TextStyle(color: primaryColor)
              ),
              style: ButtonStyle(
                side: MaterialStateProperty.all(const BorderSide(width: 2, color: secondaryColor)),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
              ),
              onPressed: () {
                if (widget.connected) {
                  String target = dotenv.env['SERVER_TMP_PATH']! + 'current';
                  widget.galaxyBloc.add(GalaxyCreateLink(widget.client, widget.bim.key!, target));
                }
              },
            ),
            leading: Image.asset('assets/images/3d-cube.png', height: 50.0, width: 50.0),
            title: Text(widget.bim.name!, style: const TextStyle(fontSize: 18.0)),
            //subtitle: const Text('Jun 11th 2022', style: TextStyle(fontSize: 16.0))
          ),
        ]
      )
    );
  }
}