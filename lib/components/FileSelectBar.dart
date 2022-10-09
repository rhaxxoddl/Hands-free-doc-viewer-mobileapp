import 'package:flutter/material.dart';
import '../constants.dart';

class FileSelectBar extends StatelessWidget {
  const FileSelectBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          Text("Select new file..."),
        ],
      ),
    );
  }
}
