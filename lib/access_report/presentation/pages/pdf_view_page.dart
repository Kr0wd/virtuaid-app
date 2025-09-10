import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewPage extends StatelessWidget {
  final String url;
  const PdfViewPage({super.key, required this.url});

  Future<void> _open() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report PDF')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _open,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Open PDF'),
        ),
      ),
    );
  }
}
