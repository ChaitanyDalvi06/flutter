import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Screen to view and generate payroll
class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> employees = [];
  bool isLoading = true;
  String errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }
  
  Future<void> _loadEmployees() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      
      final data = await _apiService.getEmployees();
      
      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load employees';
        isLoading = false;
      });
    }
  }
  
  // Function to generate payroll for an employee
  Future<void> _generatePayroll(String employeeId, String employeeName) async {
    // Get current month and year
    final now = DateTime.now();
    final month = now.month;
    final year = now.year;
    
    try {
      await _apiService.generatePayroll(employeeId, month, year);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payroll generated for $employeeName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate payroll: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Function to view payroll history
  Future<void> _viewPayrollHistory(String employeeId, String employeeName) async {
    try {
      final payrolls = await _apiService.getEmployeePayroll(employeeId);
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => _buildPayrollHistoryDialog(employeeName, payrolls),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load payroll history: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll Management'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _buildEmployeesList(),
    );
  }
  
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(errorMessage, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadEmployees,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmployeesList() {
    if (employees.isEmpty) {
      return const Center(
        child: Text('No employees found'),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadEmployees,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return _buildEmployeePayrollCard(employee);
        },
      ),
    );
  }
  
  Widget _buildEmployeePayrollCard(Map<String, dynamic> employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF2196F3),
                  child: Text(
                    employee['name'] != null && employee['name'].isNotEmpty
                        ? employee['name'][0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        employee['designation'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '₹${employee['salary'] ?? 0}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generatePayroll(
                      employee['_id'],
                      employee['name'] ?? 'Unknown',
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Generate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewPayrollHistory(
                      employee['_id'],
                      employee['name'] ?? 'Unknown',
                    ),
                    icon: const Icon(Icons.history, size: 18),
                    label: const Text('History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Dialog to show payroll history
  Widget _buildPayrollHistoryDialog(String employeeName, List<dynamic> payrolls) {
    return AlertDialog(
      title: Text('Payroll History - $employeeName'),
      content: SizedBox(
        width: double.maxFinite,
        child: payrolls.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No payroll records found'),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: payrolls.length,
                itemBuilder: (context, index) {
                  final payroll = payrolls[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Month ${payroll['month']}/${payroll['year']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '₹${payroll['payableSalary']?.toStringAsFixed(2) ?? '0'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Working Days: ${payroll['workingDays'] ?? 0}'),
                          Text('Present Days: ${payroll['presentDays'] ?? 0}'),
                          Text('Absent Days: ${payroll['absentDays'] ?? 0}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
