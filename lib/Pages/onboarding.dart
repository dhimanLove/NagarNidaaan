import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:travia/Pages/homepage.dart';

// ─────────────────────────────────────────────
// MAIN (FIXED)
// ─────────────────────────────────────────────
void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const GetMaterialApp( // ✅ FIX
    debugShowCheckedModeBanner: false,
    home: OnboardingScreen(),
  ));
}

// ─────────────────────────────────────────────
// DESIGN TOKENS (UNCHANGED)
// ─────────────────────────────────────────────
class _T {
  static const bg = Color(0xFFF4F5FA);
  static const surface = Colors.white;
  static const ink = Color(0xFF080B1A);
  static const inkMuted = Color(0xFF8B90AB);

  static const indigo = Color(0xFF2232FF);
  static const indigoSoft = Color(0xFFEBEDFF);

  static const green = Color(0xFF1EC97E);
  static const greenSoft = Color(0xFFE3F9EF);

  static const amber = Color(0xFFFFB020);
  static const amberSoft = Color(0xFFFFF4DE);

  static const r12 = 12.0;
  static const r16 = 16.0;
  static const r20 = 20.0;
  static const rFull = 999.0;

  static List<BoxShadow> cardShadow(Color accent) => [
    BoxShadow(
      color: accent.withOpacity(0.10),
      blurRadius: 36,
      offset: const Offset(0, 14),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get badgeShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────
class _PageData {
  final String tag;
  final String headline;
  final String body;
  final Color accent;
  final Color accentSoft;
  final Widget Function(Color, Color) builder;

  const _PageData({
    required this.tag,
    required this.headline,
    required this.body,
    required this.accent,
    required this.accentSoft,
    required this.builder,
  });
}

// ─────────────────────────────────────────────
// ONBOARDING
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _current = 0;

  static final _pages = <_PageData>[
    _PageData(
      tag: '01 · REPORT',
      headline: 'Report Issues',
      body: 'Report problems in your area quickly.',
      accent: _T.indigo,
      accentSoft: _T.indigoSoft,
      builder: (a, s) => const Icon(Icons.flag, size: 120),
    ),
    _PageData(
      tag: '02 · TRACK',
      headline: 'Track Status',
      body: 'Track progress in real time.',
      accent: _T.green,
      accentSoft: _T.greenSoft,
      builder: (a, s) => const Icon(Icons.track_changes, size: 120),
    ),
    _PageData(
      tag: '03 · COMMUNITY',
      headline: 'Community',
      body: 'Connect with others nearby.',
      accent: _T.amber,
      accentSoft: _T.amberSoft,
      builder: (a, s) => const Icon(Icons.groups, size: 120),
    ),
  ];

  void _next() {
    if (_current < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _current == _pages.length - 1;
    final p = _pages[_current];

    return Scaffold(
      backgroundColor: _T.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Get.offAll(() => const Homepage());
                },
                child: const Text("Skip"),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final item = _pages[i];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      item.builder(item.accent, item.accentSoft),
                      const SizedBox(height: 20),
                      Text(item.headline,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(item.body,
                            textAlign: TextAlign.center),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.accent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (isLast) {
                    Get.offAll(() => const Homepage()); // ✅ FIX
                  } else {
                    _next();
                  }
                },
                child: Text(isLast ? "Get Started" : "Continue"),
              ),
            )
          ],
        ),
      ),
    );
  }
}