import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/presentation/pages/server_form.dart';
import 'package:bim_visualizer_flutter/utils/ui/snackbar.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key? key,
    required this.preferencesBloc,
    required this.connected,
    this.client,
    required this.server }) : super(key: key);

  final PreferencesBloc preferencesBloc;
  final Server server;
  final SSHClient? client;
  final bool connected;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late GalaxyBloc _galaxyBloc;
  late bool isConnected;
  SSHClient? client;

  @override
  void initState() {
    isConnected = widget.connected;
    if (widget.client != null) client = widget.client!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: FutureBuilder(
      future: initBlocs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BlocProvider(
            create: (context) => _galaxyBloc,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  color: primaryColor,
                  icon: const Icon(Icons.arrow_back, size: iconSize),
                  onPressed: () => {
                    Navigator.of(context).pop({ 'connected': isConnected })
                  },
                ),
                backgroundColor: secondaryColor,
                title: const Text('Settings', style: TextStyle(fontSize: titleSize)),
              ),
              body: BlocListener<GalaxyBloc, GalaxyState>(
                listener: (context, state) {
                  if (state is GalaxyConnectSuccess) {
                    isConnected = true;
                    client = state.client;
                    String title = 'Success';
                    String message = 'Connection successfully established';
                    CustomSnackbar(context: context, title: title, message: message);
                  } else if (state is GalaxyConnectFailure) {
                    isConnected = false;
                    String title = 'Something went wrong';
                    CustomSnackbar(context: context, title: title, message: state.error, error: true);
                  } else if (state is GalaxyExecuteSuccess) {
                    String title = 'Success';
                    String message = 'Command successfully executed';
                    CustomSnackbar(context: context, title: title, message: message);
                  }
                },
                child: SettingsList(
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
                          title: const Text('Reconnect'),
                          value: const Text('Galaxy reconnect'),
                          onPressed: (context) {
                            if (client != null) {
                              _galaxyBloc.add(GalaxyClose(client!));
                              _galaxyBloc.add(GalaxyConnect(widget.server, 22));
                            } else {
                              _galaxyBloc.add(GalaxyConnect(widget.server, 22));
                            }
                          },
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(Icons.energy_savings_leaf_outlined),
                          title: const Text('Reboot'),
                          value: const Text('Galaxy reboot'),
                          onPressed: isConnected ? (context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Reboot"),
                                  content: const Text("Do you really want to execute this task ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close".toUpperCase(), style: const TextStyle(fontSize: 16.0, color: secondaryColor)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                    TextButton(
                                      child: Text("Execute".toUpperCase(), style: const TextStyle(fontSize: 16.0, color: secondaryColor)),
                                      onPressed: () {
                                        String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'reboot.sh ' + widget.server.password!;
                                        _galaxyBloc.add(GalaxyExecute(client!, command, true));
                                        Navigator.of(context).pop();
                                      }
                                    )
                                  ]
                                );
                              }
                            );
                          } : (context) { 
                            String title = 'Something went wrong';
                            String message = 'Need to be connected with the galaxy';
                            CustomSnackbar(context: context, title: title, message: message, error: true);
                          },
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(Icons.power_off),
                          title: const Text('Shutdown'),
                          value: const Text('Galaxy shutdown'),
                          onPressed: isConnected ? (context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Shutdown"),
                                  content: const Text("Do you really want to execute this task ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close".toUpperCase(), style: const TextStyle(fontSize: 16.0, color: secondaryColor)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                    TextButton(
                                      child: Text("Execute".toUpperCase(), style: const TextStyle(fontSize: 16.0, color: secondaryColor)),
                                      onPressed: () {
                                        String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'shutdown.sh ' + widget.server.password!;
                                        _galaxyBloc.add(GalaxyExecute(client!, command, true));
                                        Navigator.of(context).pop();
                                      }
                                    )
                                  ]
                                );
                              }
                            );
                          } : (context) { 
                            String title = 'Something went wrong';
                            String message = 'Need to be connected with the galaxy';
                            CustomSnackbar(context: context, title: title, message: message, error: true);
                          },
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(Icons.rocket_launch),
                          title: const Text('Relaunch'),
                          value: const Text('Galaxy relaunch'),
                          onPressed: isConnected ? (context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Relaunch"),
                                  content: const Text("Do you really want to execute this task ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Close".toUpperCase(), style: const TextStyle(fontSize: 16.0, color: secondaryColor)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                    ),
                                    TextButton(
                                      child: Text("Execute".toUpperCase(), style: const TextStyle(fontSize: 16.0, color: secondaryColor)),
                                      onPressed: () {
                                        String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'relaunch.sh ' + widget.server.password!;
                                        _galaxyBloc.add(GalaxyExecute(client!, command, true));
                                        Navigator.of(context).pop();
                                      }
                                    )
                                  ]
                                );
                              }
                            );
                          } : (context) { 
                            String title = 'Something went wrong';
                            String message = 'Need to be connected with the galaxy';
                            CustomSnackbar(context: context, title: title, message: message, error: true);
                          },
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(Icons.open_in_full),
                          title: const Text('Open logos'),
                          value: const Text('Open partners logos'),
                          onPressed: isConnected ? (context) {
                            String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'open_logos.sh ' + widget.server.password!;
                            _galaxyBloc.add(GalaxyExecute(client!, command, true));
                          } : (context) {
                            String title = 'Something went wrong';
                            String message = 'Need to be connected with the galaxy';
                            CustomSnackbar(context: context, title: title, message: message, error: true);
                          },
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(Icons.close),
                          title: const Text('Clean logos'),
                          value: const Text('Clean partners logos'),
                          onPressed: isConnected ? (context) {
                            String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close_logos.sh ' + widget.server.password!;
                            _galaxyBloc.add(GalaxyExecute(client!, command, true));
                          } : (context) { 
                            String title = 'Something went wrong';
                            String message = 'Need to be connected with the galaxy';
                            CustomSnackbar(context: context, title: title, message: message, error: true);
                          },
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(Icons.cleaning_services),
                          title: const Text('Clean visualization'),
                          value: const Text('Clean LG chromium sessions'),
                          onPressed: isConnected ? (context) {
                            String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close.sh ' + widget.server.password!;
                            _galaxyBloc.add(GalaxyExecute(client!, command, true));
                          } : (context) {
                            String title = 'Something went wrong';
                            String message = 'Need to be connected with the galaxy';
                            CustomSnackbar(context: context, title: title, message: message, error: true);
                          },
                        ),
                      ],
                    )
                  ],
                )
              ),
            )
          );
        }
        return const SizedBox.shrink();
      })
    );
  }

    Future<bool> initBlocs() async {
    // initialize galaxy bloc
    final galaxyRepo = GalaxyRepository();
    _galaxyBloc = GalaxyBloc(galaxyRepo);

    return true;
  }
}