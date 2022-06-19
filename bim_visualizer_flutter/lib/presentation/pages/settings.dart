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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: AppBar(
              leading: IconButton(
                color: primaryColor,
                icon: const Icon(Icons.arrow_back, size: 40.0),
                onPressed: () => {
                  Navigator.pop(context)
                },
              ),
              toolbarHeight: 100.0,
              backgroundColor: secondaryColor,
              title: const Text('Settings', style: TextStyle(fontSize: 40)),
            )
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: _buildForm(context, hostname, ipAddress, password),
            )
          ),
        )
    );
  }

  Widget _buildForm(context, hostname, ipAddress, password) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(45.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: hostname,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(30.0),
                enabled: false,
                labelText: 'Hostname',
                labelStyle: TextStyle(fontSize: 30.0)
              )
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: server.ipAddress != '' ? server.ipAddress : '',
              cursorColor: secondaryColor,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(30.0),
                labelText: 'IP Address',
                labelStyle: TextStyle(fontSize: 30.0, color: secondaryColor),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: secondaryColor),
                )
              ),
              onChanged: (value) => ipAddress = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              obscureText: true,
              initialValue: server.password != '' ? server.password : '',
              cursorColor: secondaryColor,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(30.0),
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 30.0, color: secondaryColor),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: secondaryColor),
                )
              ),
              onChanged: (value) => password = value,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              child: const Text('SAVE'),
              style: ElevatedButton.styleFrom(
                primary: accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
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
      )
    );
  }
}
