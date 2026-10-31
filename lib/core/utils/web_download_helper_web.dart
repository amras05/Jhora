// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:convert';
import 'dart:typed_data';

void downloadFileWeb({required String filename, required String content, String mimeType = 'text/html;charset=utf-8'}) {
  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  Future.delayed(const Duration(seconds: 10), () {
    html.Url.revokeObjectUrl(url);
  });
}

void downloadBytesWeb({required String filename, required Uint8List bytes, String mimeType = 'application/pdf'}) {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  Future.delayed(const Duration(seconds: 10), () {
    html.Url.revokeObjectUrl(url);
  });
}

void openHtmlInNewTabWeb(String content) {
  final blob = html.Blob([utf8.encode(content)], 'text/html;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
}

void downloadPdfFromHtmlWeb({required String filename, required String htmlContent}) {
  try {
    if (js.context.hasProperty('downloadHtmlAsPdf')) {
      js.context.callMethod('downloadHtmlAsPdf', [htmlContent, filename]);
      return;
    }
  } catch (_) {}
  openHtmlInNewTabWeb(htmlContent);
}
