import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String? type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime? createdAt;
  final DateTime? readAt;

  const AppNotification({
    required this.id,
    this.type,
    required this.title,
    required this.body,
    this.data = const {},
    this.createdAt,
    this.readAt,
  });

  bool get isRead => readAt != null;

  @override
  List<Object?> get props => [id, type, title, body, data, createdAt, readAt];
}
