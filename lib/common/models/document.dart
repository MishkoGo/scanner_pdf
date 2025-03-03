class Document {
  final String imagePath;
  String documentName;
  final String documentDate;

  Document({
    required this.imagePath,
    required this.documentDate,
    required this.documentName,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      imagePath: json['imagePath'] as String,
      documentDate: json['documentName'] as String,
      documentName: json['documentDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'documentName': documentName,
      'documentDate': documentDate,
    };
  }
}
