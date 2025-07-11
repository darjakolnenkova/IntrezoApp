import 'package:cloud_firestore/cloud_firestore.dart';

class Vacancy {
  final String id;
  final String title;
  final String company;
  final String location;
  final List<String> imageUrls;
  final String employmentType;
  final String salary;
  final String description;
  final List<String> requirements;
  final List<String> offers;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  Vacancy({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.imageUrls,
    required this.employmentType,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.offers,
    this.createdAt,
    this.expiresAt,
  });

  factory Vacancy.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final Timestamp? postTs = data['createdAt'] as Timestamp?;
    final Timestamp? expTs  = data['expiresAt'] as Timestamp?;
    return Vacancy(
      id: doc.id,
      title: data['title'] as String? ?? '',
      company: data['company'] as String? ?? '',
      location: data['location'] as String? ?? '',
      description: data['description'] as String? ?? '',
      requirements: List<String>.from(data['requirements'] as List<dynamic>? ?? []),
      offers:       List<String>.from(data['offers']       as List<dynamic>? ?? []),
      employmentType: data['employmentType'] as String? ?? '',
      salary:         data['salary']         as String? ?? '',
      imageUrls:      List<String>.from(data['imageUrls']      as List<dynamic>? ?? []),
      createdAt: postTs?.toDate(),
      expiresAt: expTs?.toDate(),
    );
  }
}