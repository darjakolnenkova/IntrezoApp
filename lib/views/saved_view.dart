import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/saved_jobs_controller.dart';
import '../widgets/job_card.dart';
import 'vacancy_view.dart'; // добавлен импорт

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<SavedJobsController>();
    final savedIds = ctrl.savedIds.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD8D3CD),
      extendBody: true,
      body: savedIds.isEmpty
          ? _buildEmptyState()
          : Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: ListView.builder(
          key: const PageStorageKey('savedList'),
          padding: const EdgeInsets.only(bottom: 50),
          itemCount: savedIds.length,
          itemBuilder: (c, i) {
            final jobId = savedIds[i];
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('jobs')
                  .doc(jobId)
                  .get(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || !snap.data!.exists) {
                  return const SizedBox.shrink();
                }
                final data = snap.data!.data()!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              VacancyView(vacancyId: jobId),
                        ),
                      );
                    },
                    child: JobCard(
                      jobData: data,
                      jobId: jobId,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: savedIds.isNotEmpty,
        child: _buildFooter(context, ctrl),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'No Saved Jobs',
            style: TextStyle(
              color: Color(0xFF001A31),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You don’t have any jobs saved yet.\n'
                'Please use the search to find and save jobs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF44515E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, SavedJobsController ctrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      color: const Color(0xFFD8D3CD),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _askClearAll(context, ctrl),
            child: const Text(
              'Clear all',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                color: Color(0xFF001A31),
              ),
            ),
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () => _askClearAll(context, ctrl),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            mini: true,
            child: const Icon(Icons.delete, size: 24),
          ),
        ],
      ),
    );
  }
}

/// Диалог подтверждения для очистки избранного
Future<void> _askClearAll(
    BuildContext context, SavedJobsController ctrl) async {
  final messenger = ScaffoldMessenger.of(context);
  final yes = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete all favorites?'),
      content: const Text(
        'Are you sure you want to delete all favorites? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete all'),
        ),
      ],
    ),
  );

  if (yes == true) {
    await ctrl.clearAll();
    messenger.showSnackBar(
      const SnackBar(content: Text('All favorites removed')),
    );
  }
}
