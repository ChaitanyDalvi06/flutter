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
const double _notchRadius  = _fabRadius + 10; // semi-circle gap around the FAB

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
          // ── Glassmorphism pill with notch ─────────────────────────────
          Positioned(
            left:   hMargin,
            right:  hMargin,
            bottom: bottomPad + outerPad,
            child: ClipPath(
              clipper: const _NotchedPillClipper(
                notchRadius: _notchRadius,
                cornerRadius: _cornerRadius,
              ),
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

// ── Notched pill clipper ──────────────────────────────────────────────────────
// Draws the pill shape with a semi-circle cut out of the top-centre for the FAB.
class _NotchedPillClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double cornerRadius;

  const _NotchedPillClipper({
    required this.notchRadius,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) {
    final cx = size.width / 2;
    return Path()
      // Start at top-left corner end
      ..moveTo(cornerRadius, 0)
      // Top edge → notch start
      ..lineTo(cx - notchRadius, 0)
      // Semi-circle notch (counter-clockwise = dips downward into the pill)
      ..arcToPoint(
        Offset(cx + notchRadius, 0),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      // Top edge → top-right corner start
      ..lineTo(size.width - cornerRadius, 0)
      // Top-right rounded corner
      ..arcToPoint(Offset(size.width, cornerRadius),
          radius: Radius.circular(cornerRadius))
      // Right edge
      ..lineTo(size.width, size.height - cornerRadius)
      // Bottom-right rounded corner
      ..arcToPoint(Offset(size.width - cornerRadius, size.height),
          radius: Radius.circular(cornerRadius))
      // Bottom edge
      ..lineTo(cornerRadius, size.height)
      // Bottom-left rounded corner
      ..arcToPoint(Offset(0, size.height - cornerRadius),
          radius: Radius.circular(cornerRadius))
      // Left edge
      ..lineTo(0, cornerRadius)
      // Top-left rounded corner
      ..arcToPoint(Offset(cornerRadius, 0),
          radius: Radius.circular(cornerRadius))
      ..close();
  }

  @override
  bool shouldReclip(_NotchedPillClipper old) =>
      old.notchRadius != notchRadius || old.cornerRadius != cornerRadius;
}

