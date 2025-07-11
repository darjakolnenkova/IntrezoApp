import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _ctrl = OnboardingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A31),
      body: SafeArea(
        child: Column(
          children: [
            // — Pagination Dots (top left) —
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 24, top: 40, bottom: 40),
              child: Row(
                children: List.generate(
                  _ctrl.data.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutBack,
                    margin: const EdgeInsets.only(right: 8),
                    width: _ctrl.currentPage == index ? 60 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _ctrl.currentPage == index
                          ? const Color(0xFFD8D3CD)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFFD8D3CD),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        _ctrl.currentPage == index ? 20 : 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // — PageView with onboarding cards —
            Expanded(
              child: PageView.builder(
                controller: _ctrl.pageController,
                itemCount: _ctrl.data.length,
                onPageChanged: (index) {
                  setState(() => _ctrl.onPageChanged(index));
                },
                itemBuilder: (context, index) {
                  final item = _ctrl.data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final maxCardHeight = constraints.maxHeight * 0.8;
                        return Center(
                          child: Container(
                            constraints:
                            BoxConstraints(maxHeight: maxCardHeight),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8D3CD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 70),
                                Center(
                                  child: Image.asset(
                                    item["image"]!,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Text(
                                  item["title"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  item["subtitle"]!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // — Navigation Buttons (BACK / NEXT / GET STARTED) —
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Row(
                children: [
                  if (_ctrl.currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _ctrl.previous());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFD8D3CD),
                            width: 2,
                          ),
                          foregroundColor: const Color(0xFFD8D3CD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("BACK"),
                      ),
                    ),
                  if (_ctrl.currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_ctrl.currentPage == _ctrl.data.length - 1) {
                          // Переходим на главный экран, очищая стек навигации
                          _ctrl.getStarted(context);
                        } else {
                          setState(() => _ctrl.next());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD8D3CD),
                        foregroundColor: const Color(0xFF001A31),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _ctrl.currentPage == _ctrl.data.length - 1
                            ? "GET STARTED"
                            : "NEXT",
                        style: TextStyle(
                          decoration: _ctrl.currentPage ==
                              _ctrl.data.length - 1
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
