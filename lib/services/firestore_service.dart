import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

class FirestoreService {
  final _jobs = FirebaseFirestore.instance.collection('jobs');

  Stream<List<Job>> getJobs({
    String orderBy = 'createdAt',
    bool descending = true,
  }) {
    return _jobs
        .orderBy(orderBy, descending: descending)
        .snapshots()
        .map((snap) =>
        snap.docs.map((doc) => Job.fromDoc(doc)).toList()
    );
  }
}