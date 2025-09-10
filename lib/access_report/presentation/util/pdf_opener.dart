import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PdfOpener {
  static Future<bool> downloadAndOpen(String url, {String? filename}) async {
    try {
      final dir = await getTemporaryDirectory();
      final name = filename ?? 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${dir.path}/$name';
      final file = File(filePath);

      final dio = Dio();
      await dio.download(url, file.path, options: Options(responseType: ResponseType.bytes));

      final result = await OpenFilex.open(file.path);
      return result.type == ResultType.done;
    } catch (_) {
      return false;
    }
  }
}
