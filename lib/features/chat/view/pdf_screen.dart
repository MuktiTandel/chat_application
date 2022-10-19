import 'package:chat_application/core/elements/customColor.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatelessWidget {
   PdfScreen({Key? key, required this.pdfUrl}) : super(key: key);

  String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: CustomColor.primary
        ),
        title: const Text('PDF',
        style: TextStyle(
          color: CustomColor.primary
        ),),
      ),
      body: SfPdfViewer.network(
          pdfUrl,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        canShowScrollHead: true,
        canShowScrollStatus: true,
      ),
    );
  }
}
