import 'package:flutter/material.dart';
import 'constants.dart';
import 'components/startButton.dart';
import 'package:document_viewer_m_app/function/getPermissionFunc.dart';

void main() {
  runApp(DocEye());
}

class DocEye extends StatelessWidget {
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
            'DocEye',
            style: tTitleTextStyle,
          ),
          backgroundColor: cBackgroundColor,
        ),
        body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/exampleImage.png',
                      height: 500,
                    ),
                  ),
                  Container(
                    child: StartButton(),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
