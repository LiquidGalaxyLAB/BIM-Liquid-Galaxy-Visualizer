import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/presentation/pages/settings.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bim_visualizer_flutter/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Server server;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PreferencesBloc>(
      future: buildBloc(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          snapshot.data!.add(PreferencesGet());
          return BlocProvider(
            create: (context) => snapshot.data!,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: secondaryColor,
                title: const Text('LG BIM Visualizer'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      snapshot.data!.add(PreferencesClear());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(
                            preferencesBloc: snapshot.data!,
                            server: server
                          )
                        )
                      );
                    },
                  ),
                ],
              ),
              body: BlocConsumer<PreferencesBloc, PreferencesState>(
                listener: (context, state) {
                  if (state is PreferencesUpdateSuccess || state is PreferencesClearSuccess) {
                    snapshot.data!.add(PreferencesGet());
                  }
                },
                builder: (context, state) {
                  if (state is PreferencesGetSuccess) {
                    server = state.server;
                    return  Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: Column(
                        children: <Widget>[
                          Text('hostname: ' + state.server.hostname!),
                          Text('IP Address: ' + state.server.ipAddress!),
                          Text('password: ' + state.server.password!)
                        ]
                        )
                      )
                    );
                  }

                  return const SizedBox.shrink();
                },
              )
            )
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<PreferencesBloc> buildBloc() async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PreferencesRepository(prefs);
    return PreferencesBloc(repo);
  }
}
