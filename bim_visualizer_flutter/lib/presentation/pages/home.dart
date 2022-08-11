import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/preferences_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/node_api_repository.dart';
import 'package:bim_visualizer_flutter/data/repositories/galaxy_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/bim/bim_bloc.dart';
import 'package:bim_visualizer_flutter/presentation/pages/settings.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/presentation/pages/about.dart';
import 'package:bim_visualizer_flutter/data/models/meta_model.dart';
import 'package:bim_visualizer_flutter/utils/ui/snackbar.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
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
  late List<MetaModel> metas;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_switchTabIndex);
    super.initState();
  }

  void _switchTabIndex() {
    setState(() { });
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
                        );
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
              floatingActionButton: _tabController.index == 1 ? FloatingActionButton(
                backgroundColor: secondaryColor,
                child: const Icon(Icons.add, color: primaryColor),
                onPressed: () { }
              ) : null,
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
                        String title = 'Something went wrong';
                        CustomSnackbar.show(context: context,
                          title: title,
                          message: state.error,
                          error: true
                        );
                      } else if (state is GalaxyCreateLinkSuccess) {
                        // navigate to meta page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Meta(
                              galaxyBloc: _galaxyBloc,
                              client: client,
                              server: server,
                              meta: metas
                            )
                          )
                        );
                      } else if (state is GalaxyCreateLinkFailure) {
                        String title = 'Something went wrong';
                        CustomSnackbar.show(context: context,
                          title: title,
                          message: 'Could not find the model',
                          error: true
                        );
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
                                    Tab(text: 'Demos'),
                                    Tab(text: 'Uploaded')
                                  ]
                                )
                              )
                            ),
                            Expanded(
                              child: BlocConsumer<BimBloc, BimState>(
                                listener: (context, state) {
                                  if (state is BimUploadSuccess) {
                                    _bimBloc.add(BimGet());
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
                                              Card(
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
                                                          if (connected) {
                                                            metas = data.meta!;
                                                            String target = dotenv.env['SERVER_TMP_PATH']! + 'current';
                                                            _galaxyBloc.add(GalaxyCreateLink(client, data.key!, target));
                                                          }
                                                        },
                                                      ),
                                                      leading: const Icon(Icons.add_box_outlined, size: 72.0),
                                                      title: Text(data.name!, style: const TextStyle(fontSize: 18.0)),
                                                      subtitle: const Text('Jun 11th 2022', style: TextStyle(fontSize: 16.0))
                                                    ),
                                                  ]
                                                )
                                              )
                                            ).toList()
                                          ),
                                           Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              const Text(
                                                'Browse and choose the file\nyou want to upload',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 18)
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: ElevatedButton(
                                                  child: const Icon(Icons.add, color: primaryColor),
                                                  style: ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    padding: const EdgeInsets.all(20),
                                                    primary: accentColor, // <-- Button color
                                                    onPrimary: secondaryColor, // <-- Splash color
                                                  ),
                                                  onPressed: () async {
                                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                                    if (result != null) {
                                                      File file = File(result.files.single.path!);
                                                      _bimBloc.add(BimUpload('test', file));
                                                    }
                                                  }
                                                )
                                              )
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
                                              Card(
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
                                                          if (connected) {
                                                            metas = data.meta!;
                                                            String target = dotenv.env['SERVER_TMP_PATH']! + 'current';
                                                            _galaxyBloc.add(GalaxyCreateLink(client, data.key!, target));
                                                          }
                                                        },
                                                      ),
                                                      leading: const Icon(Icons.add_box_outlined, size: 72.0),
                                                      title: Text(data.name!, style: const TextStyle(fontSize: 18.0)),
                                                      subtitle: const Text('Jun 11th 2022', style: TextStyle(fontSize: 16.0))
                                                    ),
                                                  ]
                                                )
                                              )
                                            ).toList()
                                          ),
                                          GridView.builder(
                                            padding: const EdgeInsets.all(10.0),
                                            itemCount: state.bim.where((bim) => bim.isDemo == false).length,
                                            itemBuilder: (context, i) {
                                              final list = state.bim.where((bim) => bim.isDemo == false);
                                              final bim = list.elementAt(i);
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
                                                          if (connected) {
                                                            //metas = bim.meta!;
                                                            //String target = dotenv.env['SERVER_TMP_PATH']! + 'current';
                                                            //_galaxyBloc.add(GalaxyCreateLink(client, bim.key!, target));
                                                          }
                                                        },
                                                      ),
                                                      leading: const Icon(Icons.view_carousel_outlined , size: 72.0),
                                                      title: Text(bim.name!, style: const TextStyle(fontSize: 18.0)),
                                                      subtitle: const Text('Jun 11th 2022', style: TextStyle(fontSize: 16.0))
                                                    ),
                                                  ]
                                                )
                                              );
                                            },
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: (3 / 1),
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5,
                                            )
                                          )
                                        ]
                                      );
                                    }
                                  }

                                  return TabBarView(
                                    controller: _tabController,
                                    children: const <Widget>[
                                      Center(
                                        child: Text('Could not load models')
                                      ),
                                      Center(
                                        child: Text('Could not load models')
                                      )
                                    ]
                                  );
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