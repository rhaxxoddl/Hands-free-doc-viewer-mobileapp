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
  static const stream =
      EventChannel("com.example.document_viewer_m_app/eventChannel");

  late StreamSubscription _streamSubscription;
  _PdfViewPageState(this.targetFile);

  void _startListener() {
    _streamSubscription = stream.receiveBroadcastStream().listen(_listenStream);
  }

  void _cancelListener() {
    _streamSubscription.cancel();
  }

  void _listenStream(value) {
    debugPrint("Dart: [${value[0]}][${value[1]}]");
  }

  @override
  void initState() {
    _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(targetFile), initialPage: _initialPage);
    _startListener();
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    _cancelListener();
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
