import 'package:flutter/material.dart';
import '../components/PreferenceButton.dart';
import 'dart:io';
import 'package:external_path/external_path.dart';
import '../components/SelectFileButton.dart';

class FileListPage extends StatefulWidget {
  @override
  _FileListPageState createState() => _FileListPageState();
}

class _FileListPageState extends State<FileListPage> {
  String directory = '';
  List<FileSystemEntity> fileList = [];

  void _listofFiles() async {
    directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    print(
        "print exist: ${File(directory + "/circle05 - Inception.pdf").statSync()}");
    setState(() {
      print('listofFiles set State!: $directory');
      fileList = Directory('$directory').listSync();
      for (FileSystemEntity file in fileList) {
        FileStat f = file.statSync();
        print("File Stat: ${f.toString()}");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
    // FlutterFileView.initController;
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
