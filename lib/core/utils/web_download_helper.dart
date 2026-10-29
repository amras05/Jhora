import 'dart:typed_data';
import 'web_download_helper_stub.dart'
    if (dart.library.html) 'web_download_helper_web.dart' as impl;

void downloadFile(String filename, String content, {String mimeType = 'text/html;charset=utf-8'}) {
  impl.downloadFileWeb(filename: filename, content: content, mimeType: mimeType);
}

void downloadBytes(String filename, Uint8List bytes, {String mimeType = 'application/pdf'}) {
  impl.downloadBytesWeb(filename: filename, bytes: bytes, mimeType: mimeType);
}

void openInNewTab(String htmlContent) {
  impl.openHtmlInNewTabWeb(htmlContent);
}

void downloadPdfFromHtml(String filename, String htmlContent) {
  impl.downloadPdfFromHtmlWeb(filename: filename, htmlContent: htmlContent);
}
