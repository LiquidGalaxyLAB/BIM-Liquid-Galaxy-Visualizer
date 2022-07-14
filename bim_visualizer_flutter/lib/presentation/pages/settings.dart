import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/presentation/pages/server_form.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key, required this.preferencesBloc, required this.server }) : super(key: key);

  final PreferencesBloc preferencesBloc;
  final Server server;

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
              title: const Text('Galaxy'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.list),
                  title: const Text('Connection'),
                  value: const Text('Galaxy informations'),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServerForm(
                          preferencesBloc: widget.preferencesBloc,
                          server: widget.server
                        )
                      )
                    );
                  },
                ),
                // SettingsTile.navigation(
                //   leading: const Icon(Icons.install_desktop),
                //   title: const Text('Install'),
                //   value: const Text('Server installation'),
                //   onPressed: (context) {
                //     //
                //   }
                // ),
              ],
            ),
          ],
        )
      ),
    );
  }
}