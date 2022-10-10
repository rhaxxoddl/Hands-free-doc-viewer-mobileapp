import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SelectFileButton extends StatelessWidget {
  const SelectFileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (result != null && result.files.isNotEmpty) {
            String fileName = result.files.first.name;
            debugPrint(fileName);
          }
        },
        child: Row(
          children: [
            Icon(
              Icons.add,
              size: 50,
            ),
            Text("Select new file..."),
          ],
        ));
  }
}
