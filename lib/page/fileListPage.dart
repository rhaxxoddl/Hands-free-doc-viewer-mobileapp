import 'package:flutter/material.dart';
import '../components/PreferenceButton.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';

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
    setState(() {
      print('listofFiles set State!: ${directory}');
      fileList = Directory("$directory").listSync();
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
    print("list build:}");
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.article),
          actions: [PreferenceButton()],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fileList.length,
                    itemBuilder: (BuildContext context, int index) {
                      print('fileList[index].path: ${fileList[index].path}');
                      return Container(
                        height: 50,
                        child: Center(
                          child: Text('Entry ${fileList[index].path}'),
                        ),
                      );
                    }),
              )),
            ],
          ),
        ));
  }
}
