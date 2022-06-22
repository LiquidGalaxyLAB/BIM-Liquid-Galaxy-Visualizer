import 'package:bim_visualizer_flutter/business_logic/bloc/preferences/preferences_bloc.dart';
import 'package:bim_visualizer_flutter/data/models/server_model.dart';
import 'package:bim_visualizer_flutter/utils/ui/form_field.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key, required this.preferencesBloc, required this.server}) : super(key: key);

  final PreferencesBloc preferencesBloc;
  final Server server;

  @override
  Widget build(BuildContext context) {
  GlobalKey formKey = GlobalKey<FormState>();

  TextEditingController hostname = TextEditingController();
  hostname.text = 'lg';

  TextEditingController ipAddress = TextEditingController();
  ipAddress.text = server.ipAddress != '' ? server.ipAddress! : '';
  
  TextEditingController password = TextEditingController();
  password.text = server.password != '' ? server.password! : '';

    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              color: primaryColor,
              icon: const Icon(Icons.arrow_back, size: iconSize),
              onPressed: () => {
                Navigator.pop(context)
              },
            ),
            backgroundColor: secondaryColor,
            title: const Text('Settings', style: TextStyle(fontSize: titleSize)),
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
    return  Padding(
      padding: const EdgeInsets.all(padding),
      child: Column(
        children: <Widget>[
          CustomFormField.build(enabled: false,
            fieldController: hostname,
            labelText: 'Hostname',
            textInputType: TextInputType.text
          ),
          const SizedBox(height: bottomSpacing),
          CustomFormField.build(fieldController: ipAddress,
            labelText: 'IP Address',
            textInputType: TextInputType.number
          ),
          const SizedBox(height: bottomSpacing),
          CustomFormField.build(obscureText: true,
            fieldController: password,
            labelText: 'Password',
            textInputType: TextInputType.text
          ),
          const SizedBox(height: bottomSpacing),
          ElevatedButton(
            child: const Text('SAVE'),
            style: ElevatedButton.styleFrom(
              primary: accentColor,
              padding: const EdgeInsets.symmetric(horizontal: buttonWidth, vertical: buttonHeight),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              )
            ),
            onPressed: () {
              // Instantiate a new server
              Server server = Server(
                hostname: hostname.text.toString(),
                ipAddress: ipAddress.text.toString(),
                password: password.text.toString()
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