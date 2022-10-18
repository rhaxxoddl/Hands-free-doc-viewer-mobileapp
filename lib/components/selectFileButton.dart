import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../page/pdf_view_page.dart';

class SelectFileButton extends StatelessWidget {
  const SelectFileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
        child: Column(
          children: [
            Icon(
              Icons.file_open,
              size: 100,
            ),
            Text("Select new file..."),
          ],
        ));
  }
}
