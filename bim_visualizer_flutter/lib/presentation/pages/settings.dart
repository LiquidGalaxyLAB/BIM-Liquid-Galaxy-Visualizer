import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/presentation/pages/server_form.dart';
import 'package:bim_visualizer_flutter/utils/ui/snackbar.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key,
    required this.preferencesBloc,
    required this.galaxyBloc,
    required this.connected,
    this.client,
    required this.server }) : super(key: key);

  final PreferencesBloc preferencesBloc;
  final GalaxyBloc galaxyBloc;
  final Server server;
  final SSHClient? client;
  final bool connected;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: primaryColor,
            icon: const Icon(Icons.arrow_back, size: iconSize),
            onPressed: () => {
              Navigator.pop(context)
            },
          ),
          backgroundColor: secondaryColor,
          title: const Text('Settings', style: TextStyle(fontSize: titleSize)),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Connection'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.desktop_mac),
                  title: const Text('LG connection'),
                  value: const Text('Master rig informations'),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServerForm(
                          preferencesBloc: widget.preferencesBloc,
                          server: widget.server
                        )
                      ),
                    );
                  },
                )
              ],
            ),
            SettingsSection(
              title: const Text('Tasks'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.restart_alt),
                  title: const Text('Reboot'),
                  value: const Text('Galaxy reboot'),
                  onPressed: widget.connected ? (context) {
                    String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'reboot.sh ' + widget.server.password!;
                    widget.galaxyBloc.add(GalaxyExecute(widget.client!, command));
                  } : (context) { 
                    String title = 'Something went wrong';
                    CustomSnackbar.show(context: context,
                      title: title,
                      message: 'Need to be connected with the galaxy',
                      error: true
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.power_off),
                  title: const Text('Shutdown'),
                  value: const Text('Galaxy shutdown'),
                  onPressed: widget.connected ? (context) {
                    String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'shutdown.sh ' + widget.server.password!;
                    widget.galaxyBloc.add(GalaxyExecute(widget.client!, command));
                  } : (context) { 
                    String title = 'Something went wrong';
                    CustomSnackbar.show(context: context,
                      title: title,
                      message: 'Need to be connected with the galaxy',
                      error: true
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.turn_right),
                  title: const Text('Turn'),
                  value: const Text('Turn galaxy displays to right'),
                  onPressed: widget.connected ? (context) {
                    String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'turn.sh right ' + widget.server.password!;
                    widget.galaxyBloc.add(GalaxyExecute(widget.client!, command));
                  } : (context) { 
                    String title = 'Something went wrong';
                    CustomSnackbar.show(context: context,
                      title: title,
                      message: 'Need to be connected with the galaxy',
                      error: true
                    );
                  },
                )
              ],
            )
          ],
        )
      ),
    );
  }
}