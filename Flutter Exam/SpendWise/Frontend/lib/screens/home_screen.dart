import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'dashboard_screen.dart';
import 'transactions_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import 'add_expense_screen.dart';

// ── Shared dimensions ─────────────────────────────────────────────────────────
const double _pillHeight   = 68.0;
const double _fabDiameter  = 60.0;
const double _fabRadius    = _fabDiameter / 2;
const double _cornerRadius = 36.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _screens = [
    DashboardScreen(),
    AnalyticsScreen(),
    TransactionsScreen(),
    SettingsScreen(),
  ];

  void _openAdd() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _GlassPillNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              onAdd: _openAdd,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glass pill nav ────────────────────────────────────────────────────────────
class _GlassPillNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  const _GlassPillNav({
    required this.currentIndex,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    const outerPad  = 14.0;
    const hMargin   = 16.0;

    // Stack height: FAB extends _fabRadius above pill top, pill is _pillHeight,
    // then safe-area + outer padding below.
    final stackHeight = _fabRadius + _pillHeight + bottomPad + outerPad;

    // FAB bottom edge in the Stack: put FAB centre at pill's top edge.
    // pill top (from stack bottom) = bottomPad + outerPad + _pillHeight
    // FAB bottom = pill top − fabRadius
    final fabBottom = bottomPad + outerPad + _pillHeight - _fabRadius;

    return SizedBox(
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Glassmorphism pill (plain ClipRRect — no ClipPath/notch) ───
          // ClipPath + BackdropFilter causes GPU bleed outside corners.
          // Using ClipRRect only guarantees hard-clip at all rounded edges.
          Positioned(
            left:   hMargin,
            right:  hMargin,
            bottom: bottomPad + outerPad,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cornerRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  height: _pillHeight,
                  decoration: BoxDecoration(
                    // Pure white-transparent gradient — no green tint at edges
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.12),
                        Colors.white.withOpacity(0.06),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.18),
                      width: 1.1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _NavItem(icon: Icons.home_rounded,         label: 'Home',      index: 0, current: currentIndex, onTap: onTap),
                      _NavItem(icon: Icons.bar_chart_rounded,    label: 'Analytics', index: 1, current: currentIndex, onTap: onTap),
                      const SizedBox(width: _fabDiameter + 12),
                      _NavItem(icon: Icons.receipt_long_rounded, label: 'Wallet',    index: 2, current: currentIndex, onTap: onTap),
                      _NavItem(icon: Icons.person_rounded,       label: 'Profile',   index: 3, current: currentIndex, onTap: onTap),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Centre FAB sitting above the pill ──────────────────────────
          Positioned(
            bottom: fabBottom,
            left:   0,
            right:  0,
            child: Center(
              child: _GlassFab(onPressed: onAdd, size: _fabDiameter),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual nav tab ────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.primaryColor.withOpacity(0.14),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.25),
                  width: 0.8,
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? AppTheme.primaryColor
                  : Colors.white.withOpacity(0.45),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected
                    ? AppTheme.primaryColor
                    : Colors.white.withOpacity(0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Glassmorphism centre FAB ──────────────────────────────────────────────────
class _GlassFab extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  const _GlassFab({required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width:  size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.30),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.85),
                    AppTheme.primaryColor.withOpacity(0.55),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.55),
                  width: 1.8,
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

