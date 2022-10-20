import 'package:flutter/material.dart';
import 'constants.dart';
import 'components/startButton.dart';
import 'package:document_viewer_m_app/function/getPermissionFunc.dart';
import 'provider/preference_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PreferenceProvider>(
          create: (_) => PreferenceProvider())
    ],
    child: DocEye(),
  ));
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
      home: ChangeNotifierProvider(
        create: (_) => PreferenceProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'DocEye',
              style: tTitleTextStyle,
            ),
            backgroundColor: cBackgroundColor,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/exampleImage.png',
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: StartButton(),
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
