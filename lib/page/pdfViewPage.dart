import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

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

  @override
  void initState() {
    _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(targetFile), initialPage: _initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
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
