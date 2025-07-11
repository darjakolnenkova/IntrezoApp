import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/home_controller.dart';
import '../widgets/job_card.dart';
import 'vacancy_view.dart';               // <- импорт экрана деталей
import 'package:intrezo/models/job.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, ctrl, _) {
        return StreamBuilder<List<Job>>(
          stream: ctrl.jobsStream,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final jobs = snap.data ?? [];
            return ListView.builder(
              key: const PageStorageKey('jobsList'),
              padding: const EdgeInsets.only(bottom: 5),
              itemCount: jobs.length + 1,
              itemBuilder: (c, i) {
                if (i == 0) {
                  return _buildHeader(jobs.length, ctrl);
                }
                final job = jobs[i - 1];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: JobCard(
                    jobData: job.toMap(),
                    jobId: job.id,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              VacancyView(vacancyId: job.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(int count, HomeController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'EXPLORE JOBS ($count)',
              style: const TextStyle(
                color: Color(0xFF001A31),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF001A31).withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: FilterOption.values.map((opt) {
                final sel = opt == ctrl.selectedFilter;
                return InkWell(
                  onTap: () => ctrl.selectFilter(opt),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                      sel ? const Color(0xFF001A31) : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      opt.label,
                      style: TextStyle(
                        color:
                        sel ? Colors.white : const Color(0xFF001A31),
                        fontWeight:
                        sel ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
