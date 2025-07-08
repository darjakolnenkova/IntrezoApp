import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Explore verified job opportunities",
      "subtitle":
      "Access only trusted and legal job offers from reliable employers in Estonia – with clear terms, safe conditions, and full transparency.",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Apply in one click",
      "subtitle":
      "No complicated process – just a short form, and we’ll take it from there.",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Full support at every step of the way",
      "subtitle":
      "We provide full support with documents, visas, and relocation - making sure every step is simple, clear, and taken care of for you.",
    },
    {
      "image": "assets/images/onboarding1.png",
      "title": "Start a new life with confidence",
      "subtitle":
      "Secure an official job in Estonia with stable income and clear conditions.",
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _getStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A31),
      body: SafeArea(
        child: Column(
          children: [
            // Pagination Dots — top left
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 24, top: 40, bottom: 40),
              child: Row(
                children: List.generate(
                  onboardingData.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutBack,
                    margin: const EdgeInsets.only(right: 8),
                    width: _currentPage == index ? 60 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFFD8D3CD)
                          : Colors.transparent,
                      border: Border.all(
                        color: const Color(0xFFD8D3CD),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        _currentPage == index ? 20 : 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),



            // Main PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // ограничим максимальную высоту карточки, если экран маленький
                        double maxCardHeight = constraints.maxHeight * 0.8;

                        return Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: maxCardHeight,
                            ),
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
                                    onboardingData[index]["image"]!,
                                    height: 200,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Text(
                                  onboardingData[index]["title"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  onboardingData[index]["subtitle"]!,
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



            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFD8D3CD),
                            width: 2.0,
                          ),
                          foregroundColor: Color(0xFFD8D3CD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("BACK"),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentPage == onboardingData.length - 1
                          ? _getStarted
                          : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD8D3CD),
                        foregroundColor: const Color(0xFF001A31),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _currentPage == onboardingData.length - 1 ? "GET STARTED" : "NEXT",
                        style: TextStyle(
                          decoration: _currentPage == onboardingData.length - 1
                              ? TextDecoration.underline
                              : TextDecoration.none,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
