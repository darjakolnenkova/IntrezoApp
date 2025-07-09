import 'package:cloud_firestore/cloud_firestore.dart';

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

  Job({
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

  factory Job.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Job(
      id: doc.id,
      title: data['title'] as String? ?? '',
      company: data['company'] as String? ?? '',
      location: data['location'] as String? ?? '',
      tags: List<String>.from(data['tags'] as List? ?? []),
      salary: data['salary']?.toString() ?? '',
      currency: data['currency'] as String? ?? '€',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }
}