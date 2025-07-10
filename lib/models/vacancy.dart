// lib/models/vacancy.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Vacancy {
  final String id;
  final String title;
  final String company;
  final String location;
  final List<String> imageUrls;       // для Carousel
  final String employmentType;        // например, "Full time"
  final String salary;                // например, "1900–4300€"
  final String description;           // полное описание вакансии
  final List<String> requirements;    // список пунктов
  final List<String> offers;          // список пунктов
  final DateTime? postedAt;
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
    this.postedAt,
    this.expiresAt,
  });

  factory Vacancy.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final Timestamp? postTs = data['postedAt'] as Timestamp?;
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
      postedAt: postTs?.toDate(),
      expiresAt: expTs?.toDate(),
    );
  }
}
