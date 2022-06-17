import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/constants.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key, required this.preferencesBloc, required this.server}) : super(key: key);

  final PreferencesBloc preferencesBloc;
  final Server server;

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey<FormState>();
    String hostname = 'lg';
    String ipAddress = server.ipAddress!;
    String password = server.password!;
    
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            title: const Text('Settings'),
          ),
          body: ListView(children: <Widget>[
            Form(
              key: formKey,
              child: _buildForm(context, hostname, ipAddress, password),
            )
          ]),
        )
    );
  }

  Widget _buildForm(context, hostname, ipAddress, password) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: hostname,
            decoration: const InputDecoration(
              enabled: false,
              labelText: 'hostname',
              border: OutlineInputBorder()
            )
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: server.ipAddress != '' ? server.ipAddress : '',
            cursorColor: secondaryColor,
            decoration: const InputDecoration(
              labelText: 'IP Address',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: secondaryColor),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: secondaryColor),
              ),
            ),
            onChanged: (value) => ipAddress = value,
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: server.password != '' ? server.password : '',
            cursorColor: secondaryColor,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: secondaryColor),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: secondaryColor),
              ),
            ),
            onChanged: (value) => password = value,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            child: const Text('SAVE'),
            style: ElevatedButton.styleFrom(
              primary: accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              )
            ),
            onPressed: () {
              // Instantiate a new server
              Server server = Server(
                hostname: hostname,
                ipAddress: ipAddress,
                password: password
              );

              // emit preferences save state
              preferencesBloc.add(PreferencesUpdate(server));

              // navigate back
              Navigator.pop(context);
            },
          )
        ]
      )
    );
  }
}
