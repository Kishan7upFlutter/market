import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    String pdfViewerUrl = "https://docs.google.com/gview?embedded=true&url=$pdfUrl";

    String filename = pdfUrl.split("/").last;
    return Scaffold(
      appBar: AppBar(title: Text("PDF")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(pdfViewerUrl),

        ),
      ),
    );
  }
}
