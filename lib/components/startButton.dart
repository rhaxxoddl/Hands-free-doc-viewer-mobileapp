import 'package:document_viewer_m_app/page/file_select_page.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class StartButton extends StatelessWidget {
  const StartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FileListPage()));
      },
      child: Text(
        "START",
        style: TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: cPointColor,
      ),
    );
  }
}
