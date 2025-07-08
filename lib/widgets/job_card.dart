import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final bool isSaved;
  final VoidCallback onSave;

  const JobCard({
    super.key,
    required this.jobData,
    required this.onSave,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = jobData['imageUrl'] as String? ?? '';
    final title = jobData['title'] as String? ?? '';
    final company = jobData['company'] as String? ?? '';
    final location = jobData['location'] as String? ?? '';
    final tags = List<String>.from(jobData['tags'] as List? ?? []);
    final salary = jobData['salary']?.toString() ?? '';
    final currency = jobData['currency'] as String? ?? '€';
    final postedAt = (jobData['createdAt'] as Timestamp?)?.toDate();
    final timeAgo = postedAt != null ? timeago.format(postedAt) : '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // — HEADER ROW —
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
              const Spacer(),
              IconButton(
                iconSize: 40,
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 35,
                  color: isSaved ? Colors.orange : Colors.grey,
                ),
                onPressed: onSave,
              ),
            ],
          ),

          const SizedBox(height: 12),
          // — TITLE —
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),
          // — COMPANY · LOCATION —
          Text(
            '$company · $location',
            style: TextStyle(color: Colors.grey[700]),
          ),

          const SizedBox(height: 12),
          // — TAGS —
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: tags
                .map((tag) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: const TextStyle(fontSize: 13),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 12),
          // — FOOTER ROW: timeAgo + salary —
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeAgo,
                style: TextStyle(color: Colors.grey[600]),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: salary,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF001A31),
                      ),
                    ),
                    TextSpan(
                      text: '$currency/Mo',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
