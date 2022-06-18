import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/presentation/pages/settings.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bim_visualizer_flutter/constants.dart';
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
                title: const Text(
                  'LG BIM Visualizer',
                  style: TextStyle(color: primaryColor)
                ),
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.refresh, color: primaryColor),
                    onPressed: () {
                      if (connected) client.close();
                      _galaxyBloc.add(GalaxyConnect(server, 22));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: primaryColor),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Connection failed, please check the server preferences'),
                            backgroundColor: errorColor,
                          )
                        );
                      }
                    },
                    builder: (blocContext, state) {
                      return Card(
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
                              if (connected) client.close();
                              server = state.server;
                              _galaxyBloc.add(GalaxyConnect(server, 22));
                            }
                          },
                          builder: (context, state) {
                            return ListTile(
                              leading: Chip(
                                label: Text(
                                  connected ? 'Connected' : 'Disconnected',
                                  style: const TextStyle(color: primaryColor)
                                ),
                                backgroundColor: connected ? successColor : errorColor
                              ),
                              title: Text(
                                'Hostname: ' + server.hostname!,
                                style: const TextStyle(color: primaryColor)
                              ),
                              subtitle: Text(
                                'Address: ' + server.ipAddress!,
                                style: const TextStyle(color: primaryColor)
                              )
                            );
                          },
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
