import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _jobsCol =
  FirebaseFirestore.instance.collection('jobs');
  final CollectionReference<Map<String, dynamic>> _appsCol =
  FirebaseFirestore.instance.collection('applications');

  Stream<List<Job>> getJobs({
    required String orderBy,
    required bool descending,
  }) {
    return _jobsCol
        .orderBy(orderBy, descending: descending)
        .snapshots()
        .map((snap) =>
        snap.docs.map((doc) => Job.fromDoc(doc)).toList()
    );
  }

  Future<void> submitApplication(Map<String, dynamic> data) {
    return _appsCol.add(data);
  }
}
