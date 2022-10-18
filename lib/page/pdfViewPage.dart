import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'dart:async';

class PdfViewPage extends StatefulWidget {
  String targetFilePath;
  PdfViewPage(@required this.targetFilePath, {Key? key}) : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState(targetFilePath);
}

class _PdfViewPageState extends State<PdfViewPage> {
  String targetFile;
  late PdfControllerPinch _pdfController;
  static const int _initialPage = 2;
  int _actualPageNumber = _initialPage;
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

  static const platform =
      MethodChannel('com.example.document_viewer_m_app/gazeTracker');
  Future<void> _checkEyePosition() async {
    try {
      final Float32List eyePosition =
          await platform.invokeMethod('getEyeCoordinary');
      if (eyePosition[0] >= 0 && eyePosition[1] >= 0) {
        if (eyePosition[1] >= deviceBottomRange[0] &&
            eyePosition[1] <= deviceBottomRange[1])
          _pdfController.nextPage(
              duration: Duration(milliseconds: 400), curve: Curves.easeIn);
        else if (eyePosition[1] >= deviceTopRange[0] &&
            eyePosition[1] <= deviceTopRange[1])
          _pdfController.previousPage(
              duration: Duration(milliseconds: 400), curve: Curves.easeOut);
        else
          debugPrint("_checkEyePosition: Invalid eye position");
      }
    } on PlatformException catch (e) {
      debugPrint("ERROR: $e");
    }
  }

  @override
  void initState() {
    deviceBottomRange = [deviceHeight * 0.8, deviceHeight];
    deviceTopRange = [0.0, deviceHeight * 0.05];
    _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(targetFile), initialPage: _initialPage);
    platform.invokeMethod('initGaze');
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      _checkEyePosition();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    platform.invokeMethod('releaseGaze');
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
