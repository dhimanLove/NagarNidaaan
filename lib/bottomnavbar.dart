import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  CIVIC BOTTOM NAV BAR
//  Usage:
//    CivicBottomNavBar(currentIndex: _idx, onTap: (i) => setState(() => _idx = i))
// ─────────────────────────────────────────────────────────────────────────────

class CivicBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CivicBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded,          label: 'HOME'),
    _NavItem(icon: Icons.flag_rounded,           label: 'REPORTS'),
    _NavItem(icon: Icons.map_outlined,           label: 'MAP'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item     = _items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: _NavTile(
                  item: item,
                  selected: selected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── TILE ─────────────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  static const _accent = Color(0xFF1A2FFF);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with pill background when selected
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? _accent.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                item.icon,
                size: 22,
                color: selected ? _accent : const Color(0xFFB0B4CC),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 9,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                color: selected ? _accent : const Color(0xFFB0B4CC),
                letterSpacing: 0.6,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── MODEL ────────────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}