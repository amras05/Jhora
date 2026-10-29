import 'dart:typed_data';

void downloadFileWeb({required String filename, required String content, String mimeType = 'text/html;charset=utf-8'}) {}

void downloadBytesWeb({required String filename, required Uint8List bytes, String mimeType = 'application/pdf'}) {}

void openHtmlInNewTabWeb(String content) {}

void downloadPdfFromHtmlWeb({required String filename, required String htmlContent}) {}
