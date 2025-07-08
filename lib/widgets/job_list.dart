import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'job_card.dart';

class JobList extends StatefulWidget {
  const JobList({super.key});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final _jobsStream = FirebaseFirestore.instance
      .collection('jobs')
      .orderBy('createdAt', descending: true)
      .snapshots();

  Set<String> _savedIds = {};

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('saved_jobs') ?? [];
    setState(() => _savedIds = list.toSet());
  }

  Future<void> _toggleFavorite(String jobId) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_savedIds.contains(jobId)) {
        _savedIds.remove(jobId);
      } else {
        _savedIds.add(jobId);
      }
    });

    await prefs.setStringList('saved_jobs', _savedIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _jobsStream,
      builder: (context, jobSnap) {
        if (jobSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final jobs = jobSnap.data!.docs;

        if (jobs.isEmpty) {
          return const Center(child: Text("No job offers yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: jobs.length,
          itemBuilder: (context, i) {
            final doc = jobs[i];
            final data = doc.data()! as Map<String, dynamic>;
            final isSaved = _savedIds.contains(doc.id);

            return JobCard(
              jobData: data,
              isSaved: isSaved,
              onSave: () => _toggleFavorite(doc.id),
            );
          },
        );
      },
    );
  }
}
