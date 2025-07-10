import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель вакансии
class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final List<String> tags;
  final String salary;
  final String currency;
  final DateTime createdAt;
  final String imageUrl;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.tags,
    required this.salary,
    required this.currency,
    required this.createdAt,
    required this.imageUrl,
  });

  /// Создаёт Job из документа Firestore, поддерживая и Timestamp, и String
  factory Job.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final raw = data['createdAt'];
    DateTime created;
    if (raw is Timestamp) {
      created = raw.toDate();
    } else if (raw is String) {
      created = DateTime.tryParse(raw) ?? DateTime.now();
    } else {
      created = DateTime.now();
    }

    return Job(
      id: doc.id,
      title: data['title'] as String? ?? '',
      company: data['company'] as String? ?? '',
      location: data['location'] as String? ?? '',
      tags: List<String>.from(data['tags'] as List? ?? []),
      salary: data['salary']?.toString() ?? '',
      currency: data['currency'] as String? ?? '€',
      createdAt: created,
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  /// Преобразует в карту для JobCard
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'tags': tags,
      'salary': salary,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
