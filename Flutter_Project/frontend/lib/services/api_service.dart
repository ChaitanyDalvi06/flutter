import 'dart:convert';
import 'package:http/http.dart' as http;

// Simple API service to talk to our backend
// This is like a helper that makes all our network requests easier!
class ApiService {
  // Change this to your computer's IP address if testing on phone
  // For emulator/simulator, use localhost
  static const String baseUrl = 'http://localhost:5001/api';
  
  // ========== EMPLOYEE APIs ==========
  
  // Get all employees from the backend
  Future<List<dynamic>> getEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl/employees'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load employees');
  }
  
  // Add a new employee
  Future<Map<String, dynamic>> addEmployee(Map<String, dynamic> employeeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employees'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employeeData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add employee');
  }
  
  // ========== ATTENDANCE APIs ==========
  
  // Mark attendance for an employee
  Future<Map<String, dynamic>> markAttendance(
    String employeeId,
    String date,
    String status,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance/mark'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'employeeId': employeeId,
        'date': date,
        'status': status,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to mark attendance');
  }
  
  // Get attendance for a specific employee
  Future<List<dynamic>> getEmployeeAttendance(String employeeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/attendance/$employeeId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load attendance');
  }
  
  // ========== PAYROLL APIs ==========
  
  // Generate payroll for an employee
  Future<Map<String, dynamic>> generatePayroll(
    String employeeId,
    int month,
    int year,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payroll/generate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'employeeId': employeeId,
        'month': month,
        'year': year,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to generate payroll');
  }
  
  // Get payroll history for an employee
  Future<List<dynamic>> getEmployeePayroll(String employeeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payroll/$employeeId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load payroll');
  }
  
  // ========== LEAVE APIs ==========
  
  // Create a leave request
  Future<Map<String, dynamic>> createLeave(Map<String, dynamic> leaveData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/leaves'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(leaveData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to create leave');
  }
  
  // Get all leaves
  Future<List<dynamic>> getAllLeaves() async {
    final response = await http.get(Uri.parse('$baseUrl/leaves'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load leaves');
  }
  
  // Update leave status (approve/reject)
  Future<Map<String, dynamic>> updateLeave(
    String leaveId,
    String status,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/leaves/$leaveId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to update leave');
  }
  
  // ========== DASHBOARD APIs ==========
  
  // Get dashboard overview
  Future<Map<String, dynamic>> getDashboardOverview() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/overview'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load dashboard');
  }
}
