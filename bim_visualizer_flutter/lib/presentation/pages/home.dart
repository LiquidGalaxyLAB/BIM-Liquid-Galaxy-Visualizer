import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/presentation/pages/settings.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/utils/ui/snackbar.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Server server = Server.defaultValues();
  late PreferencesBloc _preferencesBloc;
  late GalaxyBloc _galaxyBloc;
  late bool connected = false;
  late SSHClient client;

  @override
  void dispose() {
    client.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initBlocs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _preferencesBloc.add(PreferencesGet());
          return MultiBlocProvider(
            providers: [
              BlocProvider<PreferencesBloc>(
                create: (context) => _preferencesBloc,
              ),
              BlocProvider<GalaxyBloc>(
                create: (context) => _galaxyBloc,
              ),
            ],
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: secondaryColor,
                title:  const Text(
                  'LG BIM Visualizer',
                  style: TextStyle(fontSize: titleSize, color: primaryColor)
                ),
                elevation: 0,
                actions: <Widget>[
                  SizedBox(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.refresh, size: iconSize, color: primaryColor),
                      onPressed: () {
                        if (connected) _galaxyBloc.add(GalaxyClose(client));
                        _galaxyBloc.add(GalaxyConnect(server, 22));
                      },
                    )
                  ),
                  SizedBox(
                    width: biggerLeftSpacing,
                    child: IconButton(
                      icon: const Icon(Icons.settings, size: iconSize, color: primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(
                              preferencesBloc: _preferencesBloc,
                              server: server
                            )
                          )
                        );
                      },
                    )
                  ),
                ],
              ),
              body: Column(
                children: <Widget>[
                  BlocConsumer<GalaxyBloc, GalaxyState>(
                    listener: (blocContext, state) {
                      if (state is GalaxyConnectSuccess) {
                        connected = true;
                        client = state.client;
                      } else if (state is GalaxyConnectFailure) {
                        connected = false;
                        String title = 'Something goes wrong';
                        CustomSnackbar.show(context: context,
                          title: title,
                          message: state.error,
                          error: true
                        );
                      } else if (state is GalaxyCloseSuccess) {
                        connected = false;
                      } else if (state is GalaxyExecuteSuccess) {
                        String title = 'Success';
                        String message = 'Command successfully executed';
                        CustomSnackbar.show(context: context,
                          title: title,
                          message: message
                        );
                      } else if (state is GalaxyExecuteFailure) {
                        String title = 'Something goes wrong';
                        CustomSnackbar.show(context: context,
                          title: title,
                          message: state.error,
                          error: true
                        );
                      }
                    },
                    builder: (blocContext, state) {
                      return SizedBox(
                        height: sectionSize,
                        child: Card(
                          color: secondaryColor,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)
                          ),
                          child: BlocConsumer<PreferencesBloc, PreferencesState>(
                            listener: (context, state) {
                              if (state is PreferencesUpdateSuccess || state is PreferencesClearSuccess) {
                                _preferencesBloc.add(PreferencesGet());
                              } else if (state is PreferencesGetSuccess) {
                                if (connected) _galaxyBloc.add(GalaxyClose(client));
                                server = state.server;
                                _galaxyBloc.add(GalaxyConnect(server, 22));
                              }
                            },
                            builder: (context, state) {
                              return Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: smallLeftSpacing),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Chip(
                                        label: Text(
                                          connected ? 'Connected' : 'Disconnected',
                                          style: const TextStyle(fontSize: chipSize, color: primaryColor)
                                        ),
                                        backgroundColor: connected ? successColor : errorColor
                                      )
                                    )
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: smallLeftSpacing),
                                        child: Text(
                                          'Hostname: ' + server.hostname!,
                                          style: const TextStyle(fontSize: smallTitleSize, color: primaryColor)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: smallLeftSpacing),
                                        child: Text(
                                          'Address: ' + server.ipAddress!,
                                          style: const TextStyle(fontSize: smallSubtitleSize, color: primaryColor)
                                        )
                                      ),
                                    ]
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.open_in_browser, size: iconSize, color: primaryColor),
                                            onPressed: () {
                                              if (connected) {
                                                String command = 'bash projects/bim_visualizer_node/libs/open.sh';
                                                _galaxyBloc.add(GalaxyExecute(client, command));
                                              }
                                            }
                                          )
                                        ),
                                        SizedBox(
                                        width: biggerLeftSpacing,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.close, size: iconSize, color: primaryColor),
                                          onPressed: () {
                                            if (connected) {
                                              String command = 'bash projects/bim_visualizer_node/libs/close.sh';
                                              _galaxyBloc.add(GalaxyExecute(client, command));
                                            }
                                          }
                                        )),
                                      ]
                                    )
                                  )
                                ]
                              );
                            },
                          )
                        )
                      );
                    }
                  ),
                ]
              )
            )
          ); 
        }
        return const SizedBox.shrink();
      }
    );
  }

  Future<bool> initBlocs() async {
    // initialize preferences bloc
    final prefs = await SharedPreferences.getInstance();
    final prefsRepo = PreferencesRepository(prefs);
    _preferencesBloc = PreferencesBloc(prefsRepo);

    // initialize galaxy bloc
    final galaxyRepo = GalaxyRepository();
    _galaxyBloc = GalaxyBloc(galaxyRepo);

    return true;
  }
}