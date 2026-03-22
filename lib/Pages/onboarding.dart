import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:travia/Pages/homepage.dart';
 // your home screen

// ─────────────────────────────────────────────
//  DESIGN TOKENS
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

  static const red = Color(0xFFFF4455);

  static const r6 = 6.0;
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
//  PAGE MODEL
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
//  MAIN
// ─────────────────────────────────────────────
void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardingScreen(),
  ));
}

// ─────────────────────────────────────────────
//  ONBOARDING SCREEN
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _current = 0;

  late final AnimationController _floatCtrl;
  late final AnimationController _entryCtrl;
  late final Animation<double> _floatAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  static final _pages = <_PageData>[
    _PageData(
      tag: '01 · REPORT',
      headline: 'Empower\nYour City.',
      body: 'Spot a broken streetlight or pothole? Report it in seconds. Your voice drives real urban change.',
      accent: _T.indigo,
      accentSoft: _T.indigoSoft,
      builder: (a, s) => _ReportCard(accent: a, soft: s),
    ),
    _PageData(
      tag: '02 · TRACK',
      headline: 'Follow\nEvery Fix.',
      body: 'Live status updates move your reports from submission to resolution. Always know where things stand.',
      accent: _T.green,
      accentSoft: _T.greenSoft,
      builder: (a, s) => _TrackCard(accent: a, soft: s),
    ),
    _PageData(
      tag: '03 · COMMUNITY',
      headline: 'Build a\nBetter Block.',
      body: 'Join thousands of civic-minded neighbours. Upvote issues, add photos, celebrate wins together.',
      accent: _T.amber,
      accentSoft: _T.amberSoft,
      builder: (a, s) => _CommunityCard(accent: a, soft: s),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -7.0, end: 7.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    setState(() => _current = i);
    HapticFeedback.selectionClick();
    _entryCtrl
      ..reset()
      ..forward();
  }

  void _next() {
    if (_current < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _pages[_current];
    final isLast = _current == _pages.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _T.bg,
        body: Stack(
          children: [
            // ── Ambient decor blobs
            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutCubic,
              top: -100, right: -80,
              child: _Blob(color: p.accent, size: 280),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutCubic,
              bottom: 60, left: -60,
              child: _Blob(color: p.accent, size: 160),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              width: 34, height: 34,
                              decoration: BoxDecoration(
                                color: p.accent,
                                borderRadius: BorderRadius.circular(_T.r12),
                              ),
                              child: const Icon(Icons.location_city_rounded,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 9),
                            const Text('CivicPulse',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: _T.ink,
                                  letterSpacing: -0.3,
                                )),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: _T.surface,
                              borderRadius: BorderRadius.circular(_T.rFull),
                              boxShadow: _T.badgeShadow,
                            ),
                            child: const Text('Skip',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _T.inkMuted,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Illustration pager
                  SizedBox(
                    height: 270,
                    child: PageView.builder(
                      controller: _pageCtrl,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (_, i) => AnimatedBuilder(
                        animation: _floatAnim,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(0, _floatAnim.value),
                          child: child,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: _pages[i].builder(
                              _pages[i].accent, _pages[i].accentSoft),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Progress dots
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      children: List.generate(_pages.length, (i) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _StepDot(
                          active: i == _current,
                          passed: i < _current,
                          color: p.accent,
                        ),
                      )),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ── Text — driven by same page ctrl (physics locked)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageCtrl,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (_, i) => FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tag pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _pages[i].accentSoft,
                                    borderRadius:
                                    BorderRadius.circular(_T.rFull),
                                  ),
                                  child: Text(_pages[i].tag,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: _pages[i].accent,
                                        letterSpacing: 1.4,
                                      )),
                                ),
                                const SizedBox(height: 14),
                                Text(_pages[i].headline,
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800,
                                      color: _T.ink,
                                      height: 1.1,
                                      letterSpacing: -1.0,
                                    )),
                                const SizedBox(height: 12),
                                Text(_pages[i].body,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: _T.inkMuted,
                                      height: 1.65,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Bottom actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.off(
                                  () => const Homepage(),
                              transition: Transition.fade,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                            width: double.infinity,
                            height: 58,
                            decoration: BoxDecoration(
                              color: p.accent,
                              borderRadius: BorderRadius.circular(_T.r16),
                              boxShadow: [
                                BoxShadow(
                                  color: p.accent.withOpacity(0.36),
                                  blurRadius: 28,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLast ? 'Get Started' : 'Continue',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 19),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?  ',
                                style: TextStyle(
                                    fontSize: 13, color: _T.inkMuted)),
                            GestureDetector(
                              onTap: () {},
                              child: Text('Sign in',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: p.accent,
                                  )),
                            ),
                          ],
                        ),
                      ],
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

// ─────────────────────────────────────────────
//  STEP DOT
// ─────────────────────────────────────────────
class _StepDot extends StatelessWidget {
  final bool active, passed;
  final Color color;
  const _StepDot(
      {required this.active, required this.passed, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      width: active ? 30 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? color
            : passed
            ? color.withOpacity(0.35)
            : const Color(0xFFD5D8EC),
        borderRadius: BorderRadius.circular(_T.rFull),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  AMBIENT BLOB
// ─────────────────────────────────────────────
class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(0.08),
    ),
  );
}

// ─────────────────────────────────────────────
//  SHARED MICRO-WIDGETS
// ─────────────────────────────────────────────
class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color bg, fg;
  const _IconBadge({required this.icon, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    width: 40, height: 40,
    decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(_T.r12)),
    child: Icon(icon, color: fg, size: 20),
  );
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(_T.rFull),
    ),
    child: Text(label,
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.9)),
  );
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _MiniTag({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(_T.rFull)),
    child: Text(label,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
  );
}

class _FloatBadge extends StatelessWidget {
  final Widget child;
  const _FloatBadge({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: _T.surface,
      borderRadius: BorderRadius.circular(_T.rFull),
      boxShadow: _T.badgeShadow,
    ),
    child: child,
  );
}

class _Skel extends StatelessWidget {
  final double w, h;
  const _Skel({required this.w, required this.h});

  @override
  Widget build(BuildContext context) => Container(
    width: w, height: h,
    decoration: BoxDecoration(
      color: const Color(0xFFEEEFF5),
      borderRadius: BorderRadius.circular(_T.r6),
    ),
  );
}

// ─────────────────────────────────────────────
//  ILLUSTRATION 1 — REPORT
// ─────────────────────────────────────────────
class _ReportCard extends StatelessWidget {
  final Color accent, soft;
  const _ReportCard({required this.accent, required this.soft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Ghost card rotated behind
        Positioned(
          top: 22, right: 0,
          child: Transform.rotate(
            angle: 0.07,
            child: Container(
              width: 220, height: 130,
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(_T.r20),
              ),
            ),
          ),
        ),

        // Main card
        Positioned(
          top: 0, left: 0, right: 20,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(_T.r20),
              boxShadow: _T.cardShadow(accent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBadge(
                        icon: Icons.flag_rounded, bg: soft, fg: accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Report Issue',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _T.ink)),
                          const SizedBox(height: 2),
                          Text('CIVIC CURATOR ACTIVE',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: accent,
                                  letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                    _StatusPill(label: 'LIVE', color: _T.green),
                  ],
                ),
                const SizedBox(height: 14),
                _Skel(w: double.infinity, h: 8),
                const SizedBox(height: 6),
                _Skel(w: 150, h: 8),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _MiniTag(label: '📍 Sector 12', bg: soft, fg: accent),
                    const SizedBox(width: 8),
                    _MiniTag(
                        label: '🛠 Road',
                        bg: _T.amberSoft,
                        fg: _T.amber),
                    const Spacer(),
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(_T.r12),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Floating badge
        Positioned(
          bottom: 0, right: 6,
          child: _FloatBadge(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_rounded, size: 13, color: accent),
                const SizedBox(width: 5),
                Text('3 photos attached',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  ILLUSTRATION 2 — TRACK
// ─────────────────────────────────────────────
class _TrackCard extends StatelessWidget {
  final Color accent, soft;
  const _TrackCard({required this.accent, required this.soft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0, left: 0, right: 20,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(_T.r20),
              boxShadow: _T.cardShadow(accent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBadge(
                        icon: Icons.track_changes_rounded,
                        bg: soft,
                        fg: accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Issue #2847',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _T.ink)),
                          const SizedBox(height: 2),
                          const Text('Pothole — MG Road',
                              style: TextStyle(
                                  fontSize: 11, color: _T.inkMuted)),
                        ],
                      ),
                    ),
                    _StatusPill(label: 'IN PROGRESS', color: _T.amber),
                  ],
                ),
                const SizedBox(height: 18),
                _TimelineStep(
                    label: 'Submitted', done: true, color: accent),
                _TimelineStep(
                    label: 'Assigned to PWD', done: true, color: accent),
                _TimelineStep(
                    label: 'Work in progress',
                    done: false, active: true, color: _T.amber),
                _TimelineStep(
                    label: 'Resolved',
                    done: false, color: _T.inkMuted, isLast: true),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0, right: 6,
          child: _FloatBadge(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 13, color: _T.amber),
                const SizedBox(width: 5),
                const Text('ETA: 2 days',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _T.amber)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  ILLUSTRATION 3 — COMMUNITY
// ─────────────────────────────────────────────
class _CommunityCard extends StatelessWidget {
  final Color accent, soft;
  const _CommunityCard({required this.accent, required this.soft});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 22, right: 0,
          child: Transform.rotate(
            angle: -0.06,
            child: Container(
              width: 200, height: 110,
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(_T.r20),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0, left: 0, right: 20,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _T.surface,
              borderRadius: BorderRadius.circular(_T.r20),
              boxShadow: _T.cardShadow(accent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBadge(
                        icon: Icons.groups_rounded, bg: soft, fg: accent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Community Feed',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _T.ink)),
                          const SizedBox(height: 2),
                          const Text('247 neighbours active',
                              style: TextStyle(
                                  fontSize: 11, color: _T.inkMuted)),
                        ],
                      ),
                    ),
                    _StatusPill(label: 'LIVE', color: _T.green),
                  ],
                ),
                const SizedBox(height: 14),
                _FeedRow(
                    avatar: '🙋',
                    name: 'Ananya S.',
                    text: 'Fixed! Street light on Block C 🎉',
                    votes: 24,
                    color: accent),
                const SizedBox(height: 10),
                _FeedRow(
                    avatar: '👤',
                    name: 'Rohan K.',
                    text: 'Water logging near gate 4 🚨',
                    votes: 41,
                    color: _T.red),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0, right: 6,
          child: _FloatBadge(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.thumb_up_rounded, size: 13, color: accent),
                const SizedBox(width: 5),
                Text('+65 upvotes today',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  TIMELINE STEP
// ─────────────────────────────────────────────
class _TimelineStep extends StatelessWidget {
  final String label;
  final bool done;
  final bool active;
  final Color color;
  final bool isLast;

  const _TimelineStep({
    required this.label,
    required this.done,
    this.active = false,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? color : const Color(0xFFDDDFEE),
                ),
                child: done
                    ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 10)
                    : active
                    ? Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white),
                )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done
                        ? color.withOpacity(0.25)
                        : const Color(0xFFDDDFEE),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 1),
            child: Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? color : (done ? _T.ink : _T.inkMuted),
                )),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FEED ROW
// ─────────────────────────────────────────────
class _FeedRow extends StatelessWidget {
  final String avatar, name, text;
  final int votes;
  final Color color;

  const _FeedRow({
    required this.avatar,
    required this.name,
    required this.text,
    required this.votes,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Text(avatar, style: const TextStyle(fontSize: 14))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _T.ink)),
              Text(text,
                  style: const TextStyle(fontSize: 11, color: _T.inkMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(_T.rFull),
          ),
          child: Row(
            children: [
              Icon(Icons.arrow_upward_rounded, size: 10, color: color),
              const SizedBox(width: 2),
              Text('$votes',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ),
        ),
      ],
    );
  }
}