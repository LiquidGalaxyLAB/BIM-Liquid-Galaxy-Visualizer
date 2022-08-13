import 'package:bim_visualizer_flutter/utils/ui/snackbar.dart';
import 'package:bim_visualizer_flutter/constants/colors.dart';
import 'package:bim_visualizer_flutter/constants/sizes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ModelBottomSheet extends StatefulWidget {
  const ModelBottomSheet({ Key? key }) : super(key: key);

  @override
  State<ModelBottomSheet> createState() => _ModelBottomSheetState();
}

class _ModelBottomSheetState extends State<ModelBottomSheet> {
  late String? name = '';
  late String? filePath = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Add new model',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w500
                ),
              )
            ),
            Container(
              height: 50,
              width: 500,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              child: TextField(
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enter the model name',
                ),
                onChanged: (value) { name = value; }
              ),
            ),
            SizedBox(
              height: 50,
              width: 500,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.folder_open),
                label: const Text('Choose a file'),
                style: ElevatedButton.styleFrom(
                  primary: secondaryColor
                ),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) filePath = result.files.single.path;
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MaterialButton(
                color: accentColor,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (name != '' && filePath != '') {
                    Navigator.of(context).pop({ 'name': name, 'filePath': filePath });
                  } else {
                    String title = 'Something went wrong';
                    String message = 'Please choose a name and pick a file';
                    CustomSnackbar.show(context: context,
                      title: title,
                      message: message,
                      error: true
                    );
                  }
                }
              )
            )
          ]
        )
      )
    );
  }
}