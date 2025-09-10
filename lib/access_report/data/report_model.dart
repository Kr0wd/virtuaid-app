class AccessReport {
  final String id;
  final String residentId;
  final String pdfUrl;
  final DateTime date;

  AccessReport({
    required this.id,
    required this.residentId,
    required this.pdfUrl,
    required this.date,
  });

  factory AccessReport.fromJson(Map<String, dynamic> json) {
    String _string(dynamic v) => v?.toString() ?? '';
    String _pickUrl(Map<String, dynamic> j) =>
        _string(j['pdf_url'] ?? j['pdf'] ?? j['url'] ?? j['file'] ?? '');
    DateTime _pickDate(Map<String, dynamic> j) {
      final v = j['date'] ?? j['report_month'] ?? j['created_at'] ?? j['created'] ?? j['timestamp'];
      if (v is int) {
        return DateTime.fromMillisecondsSinceEpoch(v);
      }
      return DateTime.tryParse(_string(v)) ?? DateTime.now();
    }
    return AccessReport(
      id: _string(json['id'] ?? json['pk'] ?? json['uuid'] ?? ''),
      residentId: _string(json['resident_id'] ?? json['resident'] ?? json['residentId'] ?? ''),
      pdfUrl: _pickUrl(json),
      date: _pickDate(json),
    );
  }
}
