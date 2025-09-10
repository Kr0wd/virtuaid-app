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
    String string(dynamic v) => v?.toString() ?? '';
    String pickUrl(Map<String, dynamic> j) =>
        string(j['pdf_url'] ?? j['pdf'] ?? j['url'] ?? j['file'] ?? '');
    DateTime pickDate(Map<String, dynamic> j) {
      final v = j['date'] ?? j['report_month'] ?? j['created_at'] ?? j['created'] ?? j['timestamp'];
      if (v is int) {
        return DateTime.fromMillisecondsSinceEpoch(v);
      }
      return DateTime.tryParse(string(v)) ?? DateTime.now();
    }
    return AccessReport(
      id: string(json['id'] ?? json['pk'] ?? json['uuid'] ?? ''),
      residentId: string(json['resident_id'] ?? json['resident'] ?? json['residentId'] ?? ''),
      pdfUrl: pickUrl(json),
      date: pickDate(json),
    );
  }
}
