// lib/screens/home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/job_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Теперь не final — будем менять порядок в этом списке
  List<String> _filters = [
    'Newest',
    'Oldest',
    'Salary ↑',
    'Salary ↓',
  ];
  String _selectedFilter = 'Newest';

  Set<String> _savedIds = {};

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedIds = (prefs.getStringList('saved_jobs') ?? []).toSet();
    });
  }

  Future<void> _toggleFavorite(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_savedIds.contains(jobId)) _savedIds.remove(jobId);
      else _savedIds.add(jobId);
      prefs.setStringList('saved_jobs', _savedIds.toList());
    });
  }

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
      // Убираем выбранный и вставляем в начало
      _filters.removeAt(index);
      _filters.insert(0, f);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A31),
        elevation: 0,
        title: Image.asset('assets/images/miniintrezo.png', width: 150, height: 150),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _jobsQuery.snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          final count = docs.length;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: docs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Блок Explore Jobs + Фильтры
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
                            'EXPLORE JOBS ($count)',
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
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                              itemBuilder: (ctx, i) {
                                final f = _filters[i];
                                final selected = f == _selectedFilter;
                                return ChoiceChip(
                                  label: Text(
                                    f,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF001A31),
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  selected: selected,
                                  onSelected: (_) => _selectFilter(i),
                                  selectedColor: const Color(0xFF001A31),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: const Color(0xFF001A31),
                                      width: 2.0,
                                    ),
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
              // Карточка вакансии
              final doc = docs[index - 1];
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: JobCard(
                  jobData: doc.data(),
                  isSaved: _savedIds.contains(doc.id),
                  onSave: () => _toggleFavorite(doc.id),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
