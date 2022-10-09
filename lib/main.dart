import 'package:flutter/material.dart';
import 'constants.dart';
import 'components/StartButton.dart';
import 'package:document_viewer_m_app/function/GetPermissionFunc.dart';

void main() {
  runApp(DocWithEyes());
}

class DocWithEyes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> statusPermission = getPermission();
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: cPrimaryColor,
        scaffoldBackgroundColor: cBackgroundColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'DocWithEyes',
            style: tTitleTextStyle,
          ),
          backgroundColor: cBackgroundColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: StartButton(),
                padding: EdgeInsets.all(40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
