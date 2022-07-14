import 'package:bim_visualizer_flutter/business_logic/bloc/galaxy/galaxy_bloc.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/data/models/meta_model.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Meta extends StatefulWidget {
  const Meta({Key? key, required this.galaxyBloc, required this.client, required this.server, required this.meta}) : super(key: key);

  final GalaxyBloc galaxyBloc;
  final SSHClient client;
  final Server server;
  final List<MetaModel> meta;

  @override
  State<Meta> createState() => _MetaState();
}

class _MetaState extends State<Meta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: primaryColor,
          icon: const Icon(Icons.close, size: iconSize),
          onPressed: () {
            String command = 'bash ' + dotenv.env['SERVER_LIBS_PATH']! + 'close.sh ' + widget.server.password!;
            widget.galaxyBloc.add(GalaxyExecute(widget.client, command));
            Navigator.pop(context);
          },
        ),
        backgroundColor: secondaryColor,
        title: const Text(
          'Meta',
          style: TextStyle(fontSize: titleSize, color: primaryColor)
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(bodyPadding),
        child: GroupedListView<MetaModel, String>(
          elements: widget.meta,
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
                        builder: (_, controller) {
                          return Container(
                            color: primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(bodyPadding),
                              child: ListView(
                                controller: controller,
                                children: <Widget>[
                                  ListTile(
                                    title: const Text(
                                      'Element ID'
                                    ),
                                    subtitle: Text(
                                      element.elementID.toString()
                                    )
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Family'
                                    ),
                                    subtitle: Text(
                                      element.family!
                                    )
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Type'
                                    ),
                                    subtitle: Text(
                                      element.type!
                                    )
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Lenght'
                                    ),
                                    subtitle: Text(
                                      element.length.toString()
                                    )
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Base Level'
                                    ),
                                    subtitle: Text(
                                      element.baseLevel!
                                    )
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Top Level'
                                    ),
                                    subtitle: Text(
                                      element.topLevel!
                                    )
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Top Offset'
                                    ),
                                    subtitle: Text(
                                      element.topOffset.toString()
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
        )
      )
    );
  }
}