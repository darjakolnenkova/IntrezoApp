import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/vacancy_controller.dart';
import '../controllers/saved_jobs_controller.dart';
import '../models/vacancy.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:intrezo/views/application_form.dart';

class VacancyView extends StatelessWidget {
  final String vacancyId;

  const VacancyView({
    super.key,
    required this.vacancyId,
  });

  @override
  Widget build(BuildContext context) {
    final savedCtrl = context.read<SavedJobsController>();

    return ChangeNotifierProvider<VacancyController>(
      create: (_) => VacancyController(
        vacancyId: vacancyId,
        savedJobsCtrl: savedCtrl,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFD8D3CD),
        appBar: AppBar(
          backgroundColor: const Color(0xFF001A31),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Vacancy details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          toolbarHeight: 80,
        ),
        body: Consumer<VacancyController>(
          builder: (context, ctl, _) {
            if (ctl.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (ctl.error != null) {
              return Center(child: Text(ctl.error!));
            }
            final Vacancy v = ctl.vacancy!;
            final postedAgo = v.createdAt != null
                ? timeago.format(v.createdAt!)
                : '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A31),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                v.company,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            ctl.isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: ctl.isSaved ? Colors.orange : Colors.grey,
                            size: 40,
                          ),
                          onPressed: ctl.toggleFavorite,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pills with wrapping
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _InfoPill(icon: Icons.wallet_travel, text: '${v.salary} €'),
                        _InfoPill(icon: Icons.location_on, text: v.location),
                        _InfoPill(icon: Icons.schedule, text: v.employmentType),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Posted $postedAgo by Intrezo',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        if (v.expiresAt != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Expires: ${DateFormat('dd.MM.yyyy').format(v.expiresAt!.toLocal())}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  _Section(title: 'Job Description', child: Text(v.description)),
                  const SizedBox(height: 24),

                  // Requirements
                  _Section(
                    title: 'Requirements',
                    child: Column(
                      children: v.requirements.map((r) => _bullet(r)).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Offers
                  _Section(
                    title: 'Company offers',
                    child: Column(
                      children: v.offers.map((o) => _bullet(o)).toList(),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF001A31),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F1F1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(46),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ApplicationForm(vacancyId: vacancyId),
                ),
              );
            },
            child: const Text(
              'APPLY',
              style: TextStyle(
                color: Color(0xFF001A31),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 16)),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
