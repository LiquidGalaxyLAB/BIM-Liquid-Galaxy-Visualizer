import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/node_api_repository.dart';
import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/presentation/widgets/bottom_sheet.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/bim/bim_bloc.dart';
import 'package:bim_visualizer_flutter/presentation/widgets/empty_home.dart';
import 'package:bim_visualizer_flutter/presentation/widgets/home_card.dart';
import 'package:bim_visualizer_flutter/presentation/pages/settings.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/presentation/pages/about.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:bim_visualizer_flutter/utils/ui/snackbar.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'meta.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Server server = Server.defaultValues();
  late PreferencesBloc _preferencesBloc;
  late GalaxyBloc _galaxyBloc;
  late BimBloc _bimBloc;
  late bool connected = false;
  late SSHClient client;
  late TabController _tabController;
  late List<Bim> bim;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
              BlocProvider<BimBloc>(
                create: (context) => _bimBloc,
              )
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
                    child: TextButton.icon(
                      icon: const Icon(Icons.refresh, size: iconSize, color: primaryColor),
                      label: const Text('LG RECONNECT', style: TextStyle(color: primaryColor)),
                      onPressed: () {
                        if (connected) _galaxyBloc.add(GalaxyClose(client));
                        _galaxyBloc.add(GalaxyConnect(server, 22));
                      },
                    )
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, size: iconSize, color: primaryColor),
                    onPressed: () {
                      if (connected) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(
                              preferencesBloc: _preferencesBloc,
                              galaxyBloc: _galaxyBloc,
                              connected: connected,
                              client: client,
                              server: server
                            )
                          )
                        ).whenComplete(() => _galaxyBloc.add(GalaxyConnect(server, 22)));
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(
                              preferencesBloc: _preferencesBloc,
                              galaxyBloc: _galaxyBloc,
                              connected: connected,
                              server: server
                            )
                          )
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: biggerLeftSpacing,
                    child: IconButton(
                      icon: const Icon(Icons.info, size: iconSize, color: primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const About()
                          )
                        );
                      },
                    )
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: secondaryColor,
                child: const Icon(Icons.add, color: primaryColor),
                onPressed: () async {
                  final result = await showModalBottomSheet<dynamic>(
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) {
                      return const ModelBottomSheet();
                    }
                  );

                  if (result != null) _bimBloc.add(BimUpload(result['name'], File(result['filePath'])));
                }
              ),
              body: Column(
                children: <Widget>[
                  BlocConsumer<GalaxyBloc, GalaxyState>(
                    listener: (blocContext, state) {
                      if (state is GalaxyConnectSuccess) {
                        connected = true;
                        client = state.client;
                        _bimBloc.add(BimGet());
                      } else if (state is GalaxyConnectFailure) {
                        connected = false;
                        String title = 'Something went wrong';
                        CustomSnackbar(context: context, title: title, message: state.error, error: true);
                      } else if (state is GalaxyCloseSuccess) {
                        connected = false;
                      } else if (state is GalaxyExecuteSuccess) {
                        if (state.showAlert) {
                          String title = 'Success';
                          String message = 'Command successfully executed';
                          CustomSnackbar(context: context, title: title, message: message);
                        }
                      } else if (state is GalaxyExecuteFailure) {
                        String title = 'Something went wrong';
                        CustomSnackbar(context: context, title: title, message: state.error, error: true);
                      } else if (state is GalaxyCreateLinkSuccess) {
                        Bim data = bim.firstWhere((bim) => bim.key == state.key);
                        // navigate to meta page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Meta(
                              galaxyBloc: _galaxyBloc,
                              client: client,
                              server: server,
                              bim: data
                            )
                          )
                        ).whenComplete(() => _bimBloc.add(BimGet()));
                      } else if (state is GalaxyCreateLinkFailure) {
                        String title = 'Something went wrong';
                        String message = 'Could not find the model';
                        CustomSnackbar(context: context, title: title, message: message, error: true);
                      }
                    },
                    builder: (blocContext, state) {
                      return Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
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
                                        )
                                      ]
                                    );
                                  },
                                )
                              )
                            ),
                            SizedBox(
                              height: sectionSize,
                              child: Card(
                                color: secondaryColor,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  indicatorWeight: 5.0,
                                  indicatorColor: accentColor,
                                  tabs: const [
                                    Tab(text: 'DEMOS'),
                                    Tab(text: 'UPLOADED')
                                  ]
                                )
                              )
                            ),
                            Expanded(
                              child: BlocConsumer<BimBloc, BimState>(
                                listener: (context, state) {
                                  if (state is BimUploadSuccess) {
                                    _bimBloc.add(BimGet());
                                  } else if (state is BimGetSuccess) {
                                    bim = state.bim;
                                  }
                                },
                                builder: (context, state) {
                                  if (state is BimUploadInProgress) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (state is BimGetSuccess) {
                                    if (state.bim.where((bim) => bim.isDemo == false).isEmpty) {
                                      return TabBarView(
                                        controller: _tabController,
                                        children: <Widget>[
                                          GridView.count(
                                            crossAxisCount: 2,
                                            childAspectRatio: (3 / 1),
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            padding: const EdgeInsets.all(10.0),
                                            children: state.bim.where((bim) => bim.isDemo == true).map((data) => 
                                              HomeCard(
                                                bim: data,
                                                connected: connected,
                                                galaxyBloc: _galaxyBloc,
                                                client: client,
                                              )
                                            ).toList()
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const <Widget>[
                                              Text(
                                                'Tap the plus button to\nupload your first model',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18)
                                              ),
                                            ]
                                          )
                                        ]
                                      );
                                    } else {
                                      return TabBarView(
                                        controller: _tabController,
                                        children: <Widget>[
                                          GridView.count(
                                            crossAxisCount: 2,
                                            childAspectRatio: (3 / 1),
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            padding: const EdgeInsets.all(10.0),
                                            children: state.bim.where((bim) => bim.isDemo == true).map((data) => 
                                              HomeCard(
                                                bim: data,
                                                connected: connected,
                                                galaxyBloc: _galaxyBloc,
                                                client: client,
                                              )
                                            ).toList()
                                          ),
                                          GridView.count(
                                            crossAxisCount: 2,
                                            childAspectRatio: (3 / 1),
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            padding: const EdgeInsets.all(10.0),
                                            children: state.bim.where((bim) => bim.isDemo == false).map((data) => 
                                              HomeCard(
                                                bim: data,
                                                connected: connected,
                                                galaxyBloc: _galaxyBloc,
                                                client: client,
                                              )
                                            ).toList()
                                          )
                                        ]
                                      );
                                    }
                                  } else if (state is BimGetFailure) {
                                    return TabBarView(
                                      controller: _tabController,
                                      children: const <Widget>[
                                        EmptyHome(),
                                        EmptyHome()
                                      ]
                                    );
                                  }

                                  return const Center(child: CircularProgressIndicator());
                                }
                              )
                            )
                          ]
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

    final nodeAPIRepo = NodeAPIRepository();
    _bimBloc = BimBloc(nodeAPIRepo);

    return true;
  }
}