// lib/views/vacancy_view.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/vacancy_controller.dart';
import '../controllers/saved_jobs_controller.dart';
import '../models/vacancy.dart';
import 'package:timeago/timeago.dart' as timeago;

class VacancyView extends StatelessWidget {
  final String vacancyId;

  const VacancyView({
    Key? key,
    required this.vacancyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Берём уже созданный SavedJobsController
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
          title: const Text('Vacancy details'),
          leading: const BackButton(color: Colors.white),
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

            final postedAgo = v.postedAt != null
                ? timeago.format(v.postedAt!)
                : '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Carousel
                  if (v.imageUrls.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                      ),
                      items: v.imageUrls
                          .map((url) => Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ))
                          .toList(),
                    ),
                  const SizedBox(height: 12),

                  // Title + Bookmark
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
                                style:
                                TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            ctl.isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: ctl.isSaved
                                ? Colors.orange
                                : Colors.grey,
                            size: 28,
                          ),
                          onPressed: ctl.toggleFavorite,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pills
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoPill(icon: Icons.wallet_travel, text: v.salary),
                        _InfoPill(icon: Icons.location_on, text: v.location),
                        _InfoPill(
                            icon: Icons.schedule, text: v.employmentType),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dates
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Icon(Icons.timer,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Posted $postedAgo',
                            style:
                            TextStyle(color: Colors.grey[600])),
                        const SizedBox(width: 16),
                        if (v.expiresAt != null) ...[
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                              'Expires: ${v.expiresAt!.toLocal().toString().split(" ")[0]}',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  _Section(
                      title: 'Job Description',
                      child: Text(v.description)),
                  const SizedBox(height: 16),

                  // Requirements
                  _Section(
                    title: 'Requirements',
                    child: Column(
                        children: v.requirements
                            .map((r) => _bullet(r))
                            .toList()),
                  ),
                  const SizedBox(height: 16),

                  // Offers
                  _Section(
                    title: 'Company offers',
                    child: Column(
                        children:
                        v.offers.map((o) => _bullet(o)).toList()),
                  ),
                  const SizedBox(height: 32),

                  // APPLY
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001A31),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        minimumSize:
                        const Size.fromHeight(48),
                      ),
                      onPressed: () {
                        // TODO: Apply action
                      },
                      child: const Text('APPLY',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
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
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
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
      padding:
      const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
