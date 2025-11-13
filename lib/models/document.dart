import 'package:hive/hive.dart';

part 'document.g.dart';

/// Document model representing an uploaded document
@HiveType(typeId: 0)
class Document {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? filename;

  @HiveField(3)
  final String? mimeType;

  @HiveField(4)
  final int? fileSize;

  @HiveField(5)
  final DateTime uploadedAt;

  @HiveField(6)
  final String? url;

  @HiveField(7)
  final DocumentStatus status;

  @HiveField(8)
  final int? pageCount;

  @HiveField(9)
  final String? thumbnailUrl;

  Document({
    required this.id,
    required this.title,
    this.filename,
    this.mimeType,
    this.fileSize,
    required this.uploadedAt,
    this.url,
    this.status = DocumentStatus.processing,
    this.pageCount,
    this.thumbnailUrl,
  });

  /// Create Document from JSON
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      title: json['title'] as String,
      filename: json['filename'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSize: json['file_size'] as int?,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'] as String)
          : DateTime.now(),
      url: json['url'] as String?,
      status: _parseStatus(json['status'] as String?),
      pageCount: json['page_count'] as int?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  /// Convert Document to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'filename': filename,
      'mime_type': mimeType,
      'file_size': fileSize,
      'uploaded_at': uploadedAt.toIso8601String(),
      'url': url,
      'status': status.name,
      'page_count': pageCount,
      'thumbnail_url': thumbnailUrl,
    };
  }

  /// Parse status from string
  static DocumentStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'ready':
        return DocumentStatus.ready;
      case 'processing':
        return DocumentStatus.processing;
      case 'failed':
        return DocumentStatus.failed;
      default:
        return DocumentStatus.processing;
    }
  }

  /// Get file size in human-readable format
  String get fileSizeFormatted {
    if (fileSize == null) return 'Unknown size';
    final kb = fileSize! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  /// Get file extension from filename
  String? get fileExtension {
    if (filename == null) return null;
    final parts = filename!.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : null;
  }

  /// Copy with method for immutable updates
  Document copyWith({
    String? id,
    String? title,
    String? filename,
    String? mimeType,
    int? fileSize,
    DateTime? uploadedAt,
    String? url,
    DocumentStatus? status,
    int? pageCount,
    String? thumbnailUrl,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      url: url ?? this.url,
      status: status ?? this.status,
      pageCount: pageCount ?? this.pageCount,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Document{id: $id, title: $title, status: $status}';
  }
}

/// Document processing status
@HiveType(typeId: 1)
enum DocumentStatus {
  @HiveField(0)
  processing,

  @HiveField(1)
  ready,

  @HiveField(2)
  failed,
}
