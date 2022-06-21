import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/presentation/pages/settings.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bim_visualizer_flutter/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
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
                  style: TextStyle(fontSize: 24.0, color: primaryColor)
                ),
                elevation: 0,
                actions: <Widget>[
                  SizedBox(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.refresh, size: 30.0, color: primaryColor),
                      onPressed: () {
                        if (connected) _galaxyBloc.add(GalaxyClose(client));
                        _galaxyBloc.add(GalaxyConnect(server, 22));
                      },
                    )
                  ),
                  SizedBox(
                    width: 100.0,
                    child: IconButton(
                      icon: const Icon(Icons.settings, size: 30.0, color: primaryColor),
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
                        Flushbar(
                          backgroundColor: errorColor,
                          title: "Something goes wrong",
                          isDismissible: true,
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          titleSize: 20.0,
                          message: state.error,
                          messageSize: 16.0,
                          duration: const Duration(seconds: 5),
                          flushbarPosition: FlushbarPosition.TOP
                        ).show(context);
                      } else if (state is GalaxyCloseSuccess) {
                        connected = false;
                      } else if (state is GalaxyExecuteSuccess) {
                        Flushbar(
                          backgroundColor: successColor,
                          title: "Success",
                          isDismissible: true,
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          titleSize: 20.0,
                          message: 'Command successfully executed',
                          messageSize: 16.0,
                          duration: const Duration(seconds: 5),
                          flushbarPosition: FlushbarPosition.TOP
                        ).show(context);
                      } else if (state is GalaxyExecuteFailure) {
                        Flushbar(
                          backgroundColor: errorColor,
                          title: "Something goes wrong",
                          isDismissible: true,
                          flushbarStyle: FlushbarStyle.GROUNDED,
                          titleSize: 20.0,
                          message: state.error,
                          messageSize: 16.0,
                          duration: const Duration(seconds: 5),
                          flushbarPosition: FlushbarPosition.TOP
                        ).show(context);
                      }
                    },
                    builder: (blocContext, state) {
                      return SizedBox(
                        height: 75.0,
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
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Chip(
                                        label: Text(
                                          connected ? 'Connected' : 'Disconnected',
                                          style: const TextStyle(fontSize: 18.0, color: primaryColor)
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
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'Hostname: ' + server.hostname!,
                                          style: const TextStyle(fontSize: 20.0, color: primaryColor)
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'Address: ' + server.ipAddress!,
                                          style: const TextStyle(fontSize: 16.0, color: primaryColor)
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
                                            icon: const Icon(Icons.open_in_browser, size: 30.0, color: primaryColor),
                                            onPressed: () {
                                              if (connected) {
                                                String command = 'bash projects/bim_visualizer_node/libs/open.sh';
                                                _galaxyBloc.add(GalaxyExecute(client, command));
                                              }
                                            }
                                          )
                                        ),
                                        SizedBox(
                                        width: 100.0,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.close, size: 30.0, color: primaryColor),
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
