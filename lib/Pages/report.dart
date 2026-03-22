import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bottom_nav_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  REPORT SCREEN  — matches screenshot exactly
//  Features:
//   • App bar with hamburger + avatar
//   • Natural-language description text field
//   • Upload / Capture Photo section
//   • Auto-detected location card with Edit
//   • Civic-AI routing suggestion card
//   • Submit Report CTA
//   • "Reporting as Verified Citizen" footer
//   • Bottom nav bar (separate file)
// ─────────────────────────────────────────────────────────────────────────────

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _navIndex = 1; // Reports tab active
  final _descCtrl = TextEditingController();
  bool _photoAdded = false;

  // ── Token colors ────────────────────────────────────────────────────────
  static const _accent   = Color(0xFF1A2FFF);
  static const _ink      = Color(0xFF07091A);
  static const _muted    = Color(0xFF8E93B0);
  static const _bg       = Color(0xFFF4F5FC);
  static const _surface  = Colors.white;
  static const _line     = Color(0xFFE6E8F2);
  static const _green    = Color(0xFF00C07F);

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ── Page title ──────────────────────────────────────────────
            const Text(
              'Report Issue',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: _ink,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your contribution helps us maintain a better city for everyone. Describe what you see.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _muted,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 28),

            // ── Describe the Issue ──────────────────────────────────────
            _SectionLabel(label: 'DESCRIBE THE ISSUE'),
            const SizedBox(height: 10),
            _DescriptionField(controller: _descCtrl),

            const SizedBox(height: 24),

            // ── Upload / Capture Photo ──────────────────────────────────
            _PhotoUploadSection(
              hasPhoto: _photoAdded,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _photoAdded = !_photoAdded);
              },
            ),

            const SizedBox(height: 24),

            // ── Location Detected ───────────────────────────────────────
            _LocationCard(),

            const SizedBox(height: 14),

            // ── Civic-AI routing suggestion ─────────────────────────────
            _AiRoutingCard(),

            const SizedBox(height: 32),

            // ── Submit button ───────────────────────────────────────────
            _SubmitButton(accent: _accent),

            const SizedBox(height: 16),

            // ── Footer ──────────────────────────────────────────────────
            Center(
              child: Text(
                'REPORTING AS VERIFIED CITIZEN #8812',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _muted,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CivicBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: IconButton(
          icon: const Icon(Icons.menu_rounded, color: _ink, size: 24),
          onPressed: () {},
        ),
      ),
      title: const Text(
        'Civic-OS',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: _ink,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 18,
              backgroundColor: _accent.withOpacity(0.12),
              child: const Icon(Icons.person_rounded, color: _accent, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── SECTION LABEL ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Color(0xFF8E93B0),
        letterSpacing: 1.4,
      ),
    );
  }
}

// ─── DESCRIPTION FIELD ────────────────────────────────────────────────────────
class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const _DescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8F2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF07091A),
          height: 1.55,
        ),
        decoration: const InputDecoration(
          hintText: 'Provide natural language details\nabout the situation...',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Color(0xFFB0B4CC),
            height: 1.55,
          ),
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// ─── PHOTO UPLOAD SECTION ─────────────────────────────────────────────────────
class _PhotoUploadSection extends StatelessWidget {
  final bool hasPhoto;
  final VoidCallback onTap;
  const _PhotoUploadSection({required this.hasPhoto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasPhoto
                ? const Color(0xFF00C07F).withOpacity(0.4)
                : const Color(0xFFE6E8F2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Camera icon circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: hasPhoto
                    ? const Color(0xFF00C07F).withOpacity(0.1)
                    : const Color(0xFFEEEFFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasPhoto ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                color: hasPhoto ? const Color(0xFF00C07F) : const Color(0xFF1A2FFF),
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasPhoto ? 'Photo Added ✓' : 'Upload / Capture Photo',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: hasPhoto ? const Color(0xFF00C07F) : const Color(0xFF07091A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Only geotagged photos are allowed for verification',
              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF8E93B0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'PNG, JPG or Live Camera',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB0B4CC),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── LOCATION CARD ────────────────────────────────────────────────────────────
class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8F2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00C07F),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LOCATION DETECTED',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF07091A),
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2FFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Address
          const Text(
            '221B Baker St, London NW1 6XE',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF07091A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Automatic GPS Tracking Active • High Precision',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF8E93B0),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AI ROUTING CARD ──────────────────────────────────────────────────────────
class _AiRoutingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E3F5), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2FFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_fix_high_rounded,
              color: Color(0xFF1A2FFF),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF07091A),
                  height: 1.55,
                ),
                children: [
                  TextSpan(
                    text: 'Civic-AI: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: 'Based on your description, this will be routed to the ',
                  ),
                  TextSpan(
                    text: 'Public Safety',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2FFF),
                    ),
                  ),
                  TextSpan(text: ' department.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SUBMIT BUTTON ────────────────────────────────────────────────────────────
class _SubmitButton extends StatefulWidget {
  final Color accent;
  const _SubmitButton({required this.accent});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() async {
    HapticFeedback.lightImpact();
    await _ctrl.forward();
    await _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: widget.accent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withOpacity(0.38),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Submit Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}