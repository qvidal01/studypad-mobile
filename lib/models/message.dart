import 'package:hive/hive.dart';

part 'message.g.dart';

/// Message model for chat conversations
@HiveType(typeId: 2)
class Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final MessageRole role;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final List<String>? documentIds;

  @HiveField(5)
  final List<DocumentReference>? references;

  @HiveField(6)
  final MessageStatus status;

  @HiveField(7)
  final String? errorMessage;

  Message({
    required this.id,
    required this.text,
    required this.role,
    required this.timestamp,
    this.documentIds,
    this.references,
    this.status = MessageStatus.sent,
    this.errorMessage,
  });

  /// Create Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      text: json['text'] as String,
      role: _parseRole(json['role'] as String?),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      documentIds: (json['document_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      references: (json['references'] as List<dynamic>?)
          ?.map((e) => DocumentReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: _parseStatus(json['status'] as String?),
      errorMessage: json['error_message'] as String?,
    );
  }

  /// Convert Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'role': role.name,
      'timestamp': timestamp.toIso8601String(),
      'document_ids': documentIds,
      'references': references?.map((e) => e.toJson()).toList(),
      'status': status.name,
      'error_message': errorMessage,
    };
  }

  /// Parse role from string
  static MessageRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }

  /// Parse status from string
  static MessageStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  /// Copy with method for immutable updates
  Message copyWith({
    String? id,
    String? text,
    MessageRole? role,
    DateTime? timestamp,
    List<String>? documentIds,
    List<DocumentReference>? references,
    MessageStatus? status,
    String? errorMessage,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      documentIds: documentIds ?? this.documentIds,
      references: references ?? this.references,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message{id: $id, role: $role, status: $status}';
  }
}

/// Message role in conversation
@HiveType(typeId: 3)
enum MessageRole {
  @HiveField(0)
  user,

  @HiveField(1)
  assistant,

  @HiveField(2)
  system,
}

/// Message delivery status
@HiveType(typeId: 4)
enum MessageStatus {
  @HiveField(0)
  sending,

  @HiveField(1)
  sent,

  @HiveField(2)
  failed,
}

/// Document reference in a message (for citations)
@HiveType(typeId: 5)
class DocumentReference {
  @HiveField(0)
  final String documentId;

  @HiveField(1)
  final String documentTitle;

  @HiveField(2)
  final int? pageNumber;

  @HiveField(3)
  final String? excerpt;

  DocumentReference({
    required this.documentId,
    required this.documentTitle,
    this.pageNumber,
    this.excerpt,
  });

  factory DocumentReference.fromJson(Map<String, dynamic> json) {
    return DocumentReference(
      documentId: json['document_id'] as String,
      documentTitle: json['document_title'] as String,
      pageNumber: json['page_number'] as int?,
      excerpt: json['excerpt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'document_title': documentTitle,
      'page_number': pageNumber,
      'excerpt': excerpt,
    };
  }
}
