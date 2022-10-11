import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../page/pdfViewPage.dart';

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
            String? targetFilePath = result.files.first.path;
            if (targetFilePath != null) {
              debugPrint('Debug file name: ${targetFilePath}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewPage(targetFilePath)));
            }
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
