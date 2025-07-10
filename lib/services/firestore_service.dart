import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

class FirestoreService {
  final _col = FirebaseFirestore.instance.collection('jobs');

  /// Возвращает Stream<List<Job>> с учётом сортировки
  Stream<List<Job>> getJobs({
    required String orderBy,
    required bool descending,
  }) {
    return _col
        .orderBy(orderBy, descending: descending)
        .snapshots()
        .map((snap) =>
    // Преобразуем каждый DocumentSnapshot в Job через фабрику
    snap.docs.map((doc) => Job.fromDoc(doc)).toList()
    );
  }
}
