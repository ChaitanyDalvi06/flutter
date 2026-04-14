import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'employees_screen.dart';
import 'attendance_screen.dart';
import 'leaves_screen.dart';
import 'payroll_screen.dart';

// This is the main screen with bottom navigation
// It lets users switch between different sections of the app
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This keeps track of which screen we're showing
  int _currentIndex = 0;
  
  // List of all our screens
  final List<Widget> _screens = [
    const DashboardScreen(),
    const EmployeesScreen(),
    const AttendanceScreen(),
    const LeavesScreen(),
    const PayrollScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show the current screen based on selected index
      body: _screens[_currentIndex],
      
      // Bottom navigation bar - like tabs at the bottom
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // When user taps a tab, update the current index
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'Leaves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payroll',
          ),
        ],
      ),
    );
  }
}
