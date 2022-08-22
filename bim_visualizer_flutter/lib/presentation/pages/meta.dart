import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/repositories/node_api_repository.dart';
import 'package:bim_visualizer_flutter/business_logic/bloc/bim/bim_bloc.dart';
import 'package:bim_visualizer_flutter/presentation/pages/controller.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/data/models/meta_model.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Meta extends StatefulWidget {
  const Meta({ Key? key, required this.galaxyBloc, required this.client, required this.server, required this.bim }) : super(key: key);

  final GalaxyBloc galaxyBloc;
  final SSHClient client;
  final Server server;
  final Bim bim;

  @override
  State<Meta> createState() => _MetaState();
}

class _MetaState extends State<Meta> {
  late BimBloc _bimBloc;
  late Bim data;

  @override
  void initState() {
    data = widget.bim;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initBlocs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<BimBloc>(
                create: (context) => _bimBloc,
              )
            ],
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: secondaryColor,
                title: const Text(
                  'Meta',
                  style: TextStyle(fontSize: titleSize, color: primaryColor)
                ),
                actions: <Widget>[
                  SizedBox(
                    child: TextButton.icon(
                      icon: const Icon(Icons.cleaning_services, size: iconSize, color: primaryColor),
                      label: const Text('CLEAN VISUALIZATION', style: TextStyle(color: primaryColor)),
                      onPressed: () {
                        final String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close.sh ' + widget.server.password!;
                        widget.galaxyBloc.add(GalaxyExecute(widget.client, command, true));
                      },
                    )
                  ),
                  SizedBox(
                    child: TextButton.icon(
                      icon: const Icon(Icons.open_in_browser, size: iconSize, color: primaryColor),
                      label: const Text('OPEN ON LG', style: TextStyle(color: primaryColor)),
                      onPressed: () {
                        final String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'open.sh ' + widget.server.password!;
                        widget.galaxyBloc.add(GalaxyExecute(widget.client, command, false));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Controller(
                              galaxyBloc: widget.galaxyBloc,
                              client: widget.client,
                              server: widget.server
                            )
                          )
                        );
                      },
                    )
                  ),
                ]
              ),
              body: BlocConsumer<BimBloc, BimState>(
                listener: (context, state) {
                  if (state is BimUpdateMetaSuccess) {
                    data = state.bim;
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(bodyPadding),
                    child: data.meta!.isNotEmpty ? GroupedListView<MetaModel, String>(
                      elements: data.meta!,
                      groupBy: (element) => element.family!,
                      groupComparator: (value1, value2) => value2.compareTo(value1),
                      itemComparator: (item1, item2) => item1.elementID!.compareTo(item2.elementID!),
                      order: GroupedListOrder.DESC,
                      groupSeparatorBuilder: (String value) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Family: ' + value,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      itemBuilder: (c, element) {
                        return Card(
                          elevation: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            trailing: const Icon(Icons.arrow_forward),
                            title: Text(
                              'Element ID: ' + element.elementID.toString(),
                              style: const TextStyle(fontSize: 16)
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) {
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    minChildSize: 0.0,
                                    initialChildSize: 0.5,
                                    maxChildSize: 0.85,
                                    builder: (_, controller) {
                                      return Container(
                                        color: primaryColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(bodyPadding),
                                          child: ListView(
                                            controller: controller,
                                            children: <Widget>[
                                              ListTile(
                                                trailing: IconButton(
                                                  icon: const Icon(Icons.close, size: iconSize),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }
                                                ),
                                                title: const Text(
                                                  'Specifications',
                                                  style: TextStyle(
                                                    fontSize: 20.0
                                                  ),
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Element ID'
                                                ),
                                                subtitle: Text(
                                                  element.elementID != null ? element.elementID.toString() : ''
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Family'
                                                ),
                                                subtitle: Text(
                                                  element.family ?? ''
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Type'
                                                ),
                                                subtitle: Text(
                                                  element.type ?? ''
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Lenght'
                                                ),
                                                subtitle: Text(
                                                  element.length != null ? element.length.toString() : ''
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Base Level'
                                                ),
                                                subtitle: Text(
                                                  element.baseLevel ?? ''
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Top Level'
                                                ),
                                                subtitle: Text(
                                                  element.topLevel ?? ''
                                                )
                                              ),
                                              ListTile(
                                                title: const Text(
                                                  'Top Offset'
                                                ),
                                                subtitle: Text(
                                                  element.topOffset != null ? element.topOffset.toString() : ''
                                                )
                                              )
                                            ]
                                          )
                                        )
                                      );
                                    }
                                  ); 
                                }
                              );
                            }
                          )
                        );
                      },
                    ) : Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'There is no meta for this model\nUpload one by pressing the button bellow',
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
                                primary: secondaryColor, // <-- Button color
                                onPrimary: accentColor, // <-- Splash color
                              ),
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  allowedExtensions: ['csv'],
                                  type: FileType.custom
                                );
                                if (result != null) {
                                  File file = File(result.files.single.path!);
                                  _bimBloc.add(BimUpdateMeta(data, file));
                                }
                              }
                            )
                          )
                        ]
                      )
                    )
                  );
                }
              )
            )
          );
        }
        return const SizedBox.shrink();
      }
    );
  }

  Future<bool> initBlocs() async {
    final nodeAPIRepo = NodeAPIRepository();
    _bimBloc = BimBloc(nodeAPIRepo);

    return true;
  }
}