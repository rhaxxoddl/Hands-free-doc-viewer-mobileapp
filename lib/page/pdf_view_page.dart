import 'dart:io';
import 'dart:typed_data';

import 'package:document_viewer_m_app/provider/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class PdfViewPage extends StatefulWidget {
  String targetFilePath;
  PdfViewPage(@required this.targetFilePath, {Key? key}) : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState(targetFilePath);
}

class _PdfViewPageState extends State<PdfViewPage> {
  static const int INITIAL_PAGE = 1;

  String targetFile;
  late PdfControllerPinch _pdfController;
  int _actualPageNumber = INITIAL_PAGE;
  int _allPageCount = 0;
  bool isSampleDoc = true;
  _PdfViewPageState(this.targetFile);
  double deviceHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height *
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .devicePixelRatio;
  late List<double> deviceBottomRange;
  late List<double> deviceTopRange;
  late Timer _timer;
  late final PreferenceProvider _preferenceProvider;

  static const platform =
      MethodChannel('com.example.document_viewer_m_app/gazeTracker');
  Future<void> _checkEyePosition() async {
    try {
      final Float32List eyePosition =
          await platform.invokeMethod('getEyePosition');
      if (eyePosition[0] >= 0 && eyePosition[1] >= 0) {
        if (eyePosition[1] >= deviceBottomRange[0] &&
            eyePosition[1] <= deviceBottomRange[1]) {
          _pdfController.nextPage(
              duration:
                  Duration(milliseconds: _preferenceProvider.PAGE_SCROLL_SPEED),
              curve: Curves.easeIn);
          debugPrint("next page: [${eyePosition}]");
        } else {
          if (eyePosition[1] >= deviceTopRange[0] &&
              eyePosition[1] <= deviceTopRange[1]) {
            _pdfController.previousPage(
                duration: Duration(
                    milliseconds: _preferenceProvider.PAGE_SCROLL_SPEED),
                curve: Curves.easeOut);
            debugPrint("previous page: [${eyePosition}]");
          } else {
            debugPrint("_checkEyePosition: Invalid eye position");
          }
        }
      }
    } on PlatformException catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    deviceBottomRange = [deviceHeight * 0.8, deviceHeight];
    deviceTopRange = [0.0, AppBar().preferredSize.height];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preferenceProvider = Provider.of<PreferenceProvider>(context);
    _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(targetFile), initialPage: INITIAL_PAGE);
    platform.invokeMethod('initGaze');
    try {
      _timer = Timer.periodic(
          Duration(milliseconds: _preferenceProvider.EYE_TRACKING_DELAY),
          (timer) {
        _checkEyePosition();
      });
    } catch (e) {
      debugPrint("ERROR: pdf_view_page\n ${e}");
      exit(255);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    platform.invokeMethod('releaseGaze');
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.article),
        title: Text(targetFile.substring(targetFile.lastIndexOf('/') + 1)),
      ),
      body: FutureBuilder(
          future: PdfDocument.openFile(targetFile),
          builder: (_, pdfData) {
            return Container(
              child: PdfViewPinch(
                documentLoader:
                    const Center(child: CircularProgressIndicator()),
                pageLoader: const Center(child: CircularProgressIndicator()),
                controller: _pdfController,
                onDocumentLoaded: ((document) {
                  setState(() {
                    _allPageCount = document.pagesCount;
                  });
                }),
                onPageChanged: ((page) {
                  setState(() {
                    _actualPageNumber = page;
                  });
                }),
              ),
            );
          }),
    );
  }
}
