import 'package:flutter/material.dart';
import '../components/preferenceButton.dart';
import '../components/selectFileButton.dart';

class FileListPage extends StatefulWidget {
  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.article),
          actions: [PreferenceButton()],
        ),
        body: Container(
          child: Center(
            child: SizedBox(height: 120, child: SelectFileButton()),
          ),
        ));
  }
}
