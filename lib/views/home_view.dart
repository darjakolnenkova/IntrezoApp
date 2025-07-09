import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/job_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> _filters = ['Newest', 'Oldest', 'Salary ↑', 'Salary ↓'];
  String _selectedFilter = 'Newest';

  Query<Map<String, dynamic>> get _jobsQuery {
    final base = FirebaseFirestore.instance.collection('jobs');
    switch (_selectedFilter) {
      case 'Oldest':
        return base.orderBy('createdAt', descending: false);
      case 'Salary ↑':
        return base.orderBy('salary', descending: false);
      case 'Salary ↓':
        return base.orderBy('salary', descending: true);
      case 'Newest':
      default:
        return base.orderBy('createdAt', descending: true);
    }
  }

  void _selectFilter(int index) {
    final f = _filters[index];
    setState(() {
      _selectedFilter = f;
      _filters.removeAt(index);
      _filters.insert(0, f);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _jobsQuery.snapshots(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snap.data?.docs ?? [];
        return ListView.builder(
          key: const PageStorageKey('jobsList'),
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: docs.length + 1,
          itemBuilder: (c, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPLORE JOBS (${docs.length})',
                          style: const TextStyle(
                            color: Color(0xFF001A31),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (ctx, j) {
                              final f = _filters[j];
                              final sel = f == _selectedFilter;
                              return ChoiceChip(
                                label: Text(
                                  f,
                                  style: TextStyle(
                                    color: sel ? Colors.white : const Color(0xFF001A31),
                                    fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                selected: sel,
                                onSelected: (_) => _selectFilter(j),
                                selectedColor: const Color(0xFF001A31),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Color(0xFF001A31), width: 2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            final doc = docs[i - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: JobCard(
                jobData: doc.data(),
                jobId: doc.id,   // передаём ID
              ),
            );
          },
        );
      },
    );
  }
}

