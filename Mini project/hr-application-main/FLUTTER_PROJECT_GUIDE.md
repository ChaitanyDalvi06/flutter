# Complete Flutter HR Application Guide
## From Basics to Your Project - Exam Preparation Guide

**Created for exam preparation on: 12 February 2026**

---

# TABLE OF CONTENTS

1. [Flutter Fundamentals](#1-flutter-fundamentals)
2. [Backend Fundamentals (Node.js)](#2-backend-fundamentals)
3. [Your Project Architecture](#3-your-project-architecture)
4. [Frontend Deep Dive](#4-frontend-deep-dive)
5. [Backend Deep Dive](#5-backend-deep-dive)
6. [How Everything Connects](#6-how-everything-connects)
7. [Common Interview Questions](#7-common-interview-questions)

---

# 1. FLUTTER FUNDAMENTALS

## 1.1 What is Flutter?

**Flutter** is a **UI toolkit** by Google for building beautiful, natively compiled applications for mobile, web, and desktop from a **single codebase**.

**Key Points:**
- Uses **Dart** programming language
- **Hot Reload**: See changes instantly without restarting app
- **Widget-based**: Everything is a widget
- **Cross-platform**: One code = iOS + Android + Web

## 1.2 What is a Widget?

**Widget** = Building block of Flutter UI. Everything you see is a widget.

```dart
// Example from your project
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Management',
      home: const AuthWrapper(),
    );
  }
}
```

**Types of Widgets:**
1. **StatelessWidget**: Doesn't change (static)
2. **StatefulWidget**: Can change (dynamic)

## 1.3 StatelessWidget vs StatefulWidget

### StatelessWidget (Cannot Change)
```dart
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Welcome!'); // This text never changes
  }
}
```

### StatefulWidget (Can Change)
```dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0; // This can change
  
  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}
```

## 1.4 BuildContext

**BuildContext** = A reference to the location of a widget in the widget tree.

Think of it as **GPS coordinates** for your widget.

```dart
// Using context to navigate
Navigator.push(context, MaterialPageRoute(...));

// Using context to get theme
Theme.of(context).primaryColor
```

## 1.5 State Management

**Problem**: How do we share data between different screens?

**Solution**: State Management

**Your project uses: Provider**

```dart
// Provider makes data available to all child widgets
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => EmployeeProvider()),
  ],
  child: MaterialApp(...)
)
```

---

# 2. BACKEND FUNDAMENTALS

## 2.1 What is Backend?

**Backend** = The server-side that:
- Stores data in database
- Processes requests
- Handles authentication
- Performs business logic

**Your backend uses: Node.js + Express + MongoDB**

## 2.2 REST API

**REST API** = A way for frontend and backend to communicate

**HTTP Methods:**
- **GET**: Read data (get employee list)
- **POST**: Create data (add new employee)
- **PUT**: Update data (edit employee)
- **DELETE**: Remove data (delete employee)

```javascript
// Example from your backend
app.get('/api/employees', getAllEmployees);    // GET
app.post('/api/employees', createEmployee);    // POST
app.put('/api/employees/:id', updateEmployee); // PUT
```

## 2.3 MVC Pattern (Model-View-Controller)

**Your backend follows MVC:**

```
User Request → Routes → Controller → Service → Model → Database
                  ↓
              Response
```

**Components:**
- **Model**: Database schema (what data looks like)
- **View**: Frontend (Flutter app)
- **Controller**: Handles requests, calls services
- **Service**: Business logic
- **Routes**: URL paths

---

# 3. YOUR PROJECT ARCHITECTURE

## 3.1 Overall Structure

```
HR Application
├── Backend (Node.js)
│   ├── Database (MongoDB)
│   ├── API Endpoints
│   └── Authentication (JWT)
│
└── Frontend (Flutter)
    ├── UI Screens
    ├── State Management (Provider)
    └── API Calls (HTTP)
```

## 3.2 How They Connect

```
Flutter App (Frontend)
      ↓
   HTTP Request (API call)
      ↓
Node.js Server (Backend)
      ↓
MongoDB Database
      ↓
Response with Data
      ↓
Flutter App Shows Data
```

## 3.3 Project Features

1. **Authentication**: Login/Register
2. **Employee Management**: Add, edit, view employees
3. **Attendance Tracking**: Mark present/absent
4. **Leave Management**: Apply for leaves
5. **Payroll**: Calculate and generate salary
6. **Dashboard**: View statistics

---

# 4. FRONTEND DEEP DIVE

## 4.1 Project Structure Explained

```
frontend/lib/
├── main.dart              → Entry point (app starts here)
├── config/
│   ├── constants.dart     → API URLs, enums
│   └── theme.dart         → App colors, styles
├── models/
│   ├── employee.dart      → Employee data structure
│   ├── attendance.dart    → Attendance data structure
│   └── user.dart          → User data structure
├── providers/
│   ├── auth_provider.dart      → Login/logout logic
│   ├── employee_provider.dart  → Employee state management
│   └── attendance_provider.dart → Attendance state
├── screens/
│   ├── auth/              → Login, Register screens
│   ├── employees/         → Employee list, add, detail
│   ├── attendance/        → Attendance marking
│   └── dashboard/         → Main dashboard
└── services/
    ├── api_service.dart        → HTTP request handler
    └── employee_service.dart   → Employee API calls
```

## 4.2 main.dart - Application Entry Point

**Location**: `frontend/lib/main.dart`

```dart
void main() {
  runApp(const MyApp());  // This starts the app
}
```

**Line-by-line Explanation:**

```dart
void main() {
  // main() is the starting point of every Dart program
  // void means it doesn't return anything
  runApp(const MyApp());  
  // runApp() takes a widget and makes it the root of the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // MyApp is a StatelessWidget (doesn't change)
  // {super.key} is for widget identification

  @override
  Widget build(BuildContext context) {
    // build() method creates the UI
    // Returns a Widget that will be displayed
    
    return MultiProvider(
      // MultiProvider allows multiple providers
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Creates AuthProvider (manages login state)
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        // Creates EmployeeProvider (manages employee data)
      ],
      child: MaterialApp(
        // MaterialApp is the root widget for Material Design
        title: 'HR Management',
        theme: AppTheme.lightTheme,  // Colors, fonts
        home: const AuthWrapper(),   // First screen
        routes: {
          // Named routes for navigation
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const MainScreen(),
        },
      ),
    );
  }
}
```

## 4.3 Models - Data Structures

**What is a Model?** 
A Model defines the **structure of data**.

**Example: Employee Model**
**Location**: `frontend/lib/models/employee.dart`

```dart
class Employee {
  final String id;           // Unique ID
  final String name;         // Employee name
  final String email;        // Email address
  final String? department;  // ? means optional (can be null)
  final SalaryStructure? salaryStructure;
  
  Employee({
    required this.id,        // required = must provide
    required this.name,
    required this.email,
    this.department,         // not required
    this.salaryStructure,
  });
  
  // Convert JSON to Employee object
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'],
    );
  }
  
  // Convert Employee object to JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'department': department,
  };
}
```

**Why fromJson and toJson?**
- **fromJson**: Convert API response (JSON) → Dart object
- **toJson**: Convert Dart object → JSON to send to API

## 4.4 Providers - State Management

**What is Provider?**
Provider is a **state management solution**. It helps share data across screens.

**Example: AuthProvider**
**Location**: `frontend/lib/providers/auth_provider.dart`

```dart
class AuthProvider extends ChangeNotifier {
  // ChangeNotifier allows this class to notify listeners
  
  User? _user;              // Private variable (underscore)
  bool _isLoading = false;  // Loading state
  String? _error;           // Error message
  
  // Getters (read-only access)
  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  
  // Login method
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();  // Tell UI to rebuild
    
    try {
      // Call API
      final response = await AuthService.login(email, password);
      _user = User.fromJson(response['user']);
      
      _isLoading = false;
      notifyListeners();  // Update UI
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
```

**How to use Provider in UI:**

```dart
// In your widget
final authProvider = Provider.of<AuthProvider>(context);

// Or shorter way
final authProvider = context.read<AuthProvider>();

// Call login
await authProvider.login(email, password);

// Listen to changes
Consumer<AuthProvider>(
  builder: (context, auth, child) {
    if (auth.isLoading) return CircularProgressIndicator();
    return Text('Welcome ${auth.user?.name}');
  },
)
```

## 4.5 Services - API Communication

**What is a Service?**
Service handles **communication with backend API**.

**Example: ApiService**
**Location**: `frontend/lib/services/api_service.dart`

```dart
class ApiService {
  static const _storage = FlutterSecureStorage();
  // Secure storage for saving JWT token
  
  // GET request
  static Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }
  
  // POST request
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$apiBaseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),  // Convert to JSON string
    );
    return _handleResponse(response);
  }
  
  // Handle API response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      return jsonDecode(response.body);
    } else {
      // Error
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}
```

**Example: EmployeeService**
**Location**: `frontend/lib/services/employee_service.dart`

```dart
class EmployeeService {
  // Get all employees
  static Future<List<Employee>> getAllEmployees() async {
    final response = await ApiService.get('/employees');
    // response = [{"id": "1", "name": "John"}, {...}]
    
    return (response as List)
        .map((json) => Employee.fromJson(json))
        .toList();
  }
  
  // Create employee
  static Future<Employee> createEmployee(Map<String, dynamic> data) async {
    final response = await ApiService.post('/employees', data);
    return Employee.fromJson(response);
  }
}
```

## 4.6 Screens - UI Components

**What is a Screen?**
A Screen is a **full-page widget** that users see.

**Example: Login Screen**
**Location**: `frontend/lib/screens/auth/login_screen.dart`

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides basic structure (AppBar, Body, etc.)
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16), // Space between widgets
            
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,  // Hide password
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 24),
            
            // Login Button
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                
                // Get provider
                final authProvider = context.read<AuthProvider>();
                
                // Call login
                final success = await authProvider.login(email, password);
                
                if (success) {
                  // Navigate to dashboard
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    // Clean up controllers when widget is destroyed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

## 4.7 Navigation

**How to move between screens:**

```dart
// Push new screen (can go back)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => EmployeeDetailScreen()),
);

// Push and remove previous (can't go back)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => DashboardScreen()),
);

// Navigate using named routes
Navigator.pushNamed(context, '/employees');

// Go back to previous screen
Navigator.pop(context);
```

## 4.8 Common Flutter Widgets

### Container
```dart
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(20),
  child: Text('Hello'),
)
```

### Column (Vertical Layout)
```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

### Row (Horizontal Layout)
```dart
Row(
  children: [
    Icon(Icons.star),
    Text('Rating'),
  ],
)
```

### ListView (Scrollable List)
```dart
ListView.builder(
  itemCount: employees.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(employees[index].name),
      subtitle: Text(employees[index].email),
    );
  },
)
```

---

# 5. BACKEND DEEP DIVE

## 5.1 Backend Structure

```
backend/src/
├── server.js           → Entry point
├── app.js              → Express app setup
├── config/
│   ├── db.js           → MongoDB connection
│   └── constants.js    → Constants
├── models/
│   ├── Employee.js     → Employee schema
│   ├── User.js         → User schema
│   └── Attendance.js   → Attendance schema
├── controllers/
│   ├── auth.controller.js      → Login/register logic
│   └── employee.controller.js  → Employee CRUD
├── services/
│   └── employee.service.js     → Business logic
├── routes/
│   └── employee.routes.js      → API endpoints
├── middlewares/
│   ├── auth.middleware.js      → JWT verification
│   └── error.middleware.js     → Error handling
└── jobs/
    └── attendance.job.js       → Cron jobs
```

## 5.2 server.js - Entry Point

**Location**: `backend/src/server.js`

```javascript
import "dotenv/config";  // Load .env file
import app from "./app.js";
import connectDB from "./config/db.js";
import { PORT } from "./config/constants.js";
import initCron from "./jobs/attendance.job.js";

// Connect to MongoDB
connectDB();

// Start cron jobs
initCron();

// Start server on port 8080
app.listen(PORT, () => {
  console.log("Server running on port", PORT);
});
```

## 5.3 app.js - Express Setup

**Location**: `backend/src/app.js`

```javascript
import express from "express";
import cors from "cors";  // Allow frontend to call API

const app = express();

// Middleware
app.use(cors());              // Enable CORS
app.use(express.json());      // Parse JSON body

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/employees", employeeRoutes);
app.use("/api/attendance", attendanceRoutes);
app.use("/api/payroll", payrollRoutes);
app.use("/api/leaves", leaveRoutes);
app.use("/api/dashboard", dashboardRoutes);

// Error handling
app.use(errorMiddleware);

export default app;
```

## 5.4 Models - Database Schema

**What is a Model?**
Model defines **structure of data in database**.

**Example: Employee Model**
**Location**: `backend/src/models/Employee.js`

```javascript
import mongoose from "mongoose";

// Define schema (structure)
const employeeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Employee name is required"],
      trim: true,  // Remove extra spaces
      maxlength: [100, "Name cannot exceed 100 characters"],
    },
    email: {
      type: String,
      required: [true, "Email is required"],
      unique: true,  // No duplicate emails
      lowercase: true,
    },
    department: {
      type: String,
      trim: true,
    },
    designation: {
      type: String,
      trim: true,
    },
    salaryStructure: {
      basic: {
        type: Number,
        min: [0, "Basic salary cannot be negative"],
      },
      hra: {
        type: Number,
        default: 0,
      },
    },
    status: {
      type: String,
      enum: ["ACTIVE", "INACTIVE", "RESIGNED"],
      default: "INACTIVE",
    },
  },
  {
    timestamps: true,  // Adds createdAt, updatedAt
  },
);

export default mongoose.model("Employee", employeeSchema);
```

## 5.5 Routes - API Endpoints

**What is a Route?**
Route defines **URL paths and which controller to call**.

**Example: Employee Routes**
**Location**: `backend/src/routes/employee.routes.js`

```javascript
import express from "express";
import * as employeeController from "../controllers/employee.controller.js";
import auth from "../middlewares/auth.middleware.js";

const router = express.Router();

// All routes require authentication
router.use(auth);

// GET /api/employees - Get all employees
router.get("/", employeeController.getAllEmployees);

// POST /api/employees - Create new employee
router.post("/", employeeController.createEmployee);

// GET /api/employees/:id - Get one employee
router.get("/:id", employeeController.getEmployeeById);

// PUT /api/employees/:id - Update employee
router.put("/:id", employeeController.updateEmployee);

export default router;
```

## 5.6 Controllers - Request Handlers

**What is a Controller?**
Controller **handles HTTP requests** and sends responses.

**Example: Employee Controller**
**Location**: `backend/src/controllers/employee.controller.js`

```javascript
import * as employeeService from "../services/employee.service.js";

// Get all employees
export const getAllEmployees = async (req, res, next) => {
  try {
    // Call service layer
    const employees = await employeeService.getAllEmployees();
    
    // Send success response
    res.status(200).json({
      success: true,
      data: employees,
    });
  } catch (error) {
    // Pass error to error middleware
    next(error);
  }
};

// Create employee
export const createEmployee = async (req, res, next) => {
  try {
    // Get data from request body
    const employeeData = req.body;
    
    // Call service to create
    const employee = await employeeService.createEmployee(employeeData);
    
    // Send response
    res.status(201).json({
      success: true,
      message: "Employee created successfully",
      data: employee,
    });
  } catch (error) {
    next(error);
  }
};
```

## 5.7 Services - Business Logic

**What is a Service?**
Service contains **business logic** and **database operations**.

**Example: Employee Service**
**Location**: `backend/src/services/employee.service.js`

```javascript
import Employee from "../models/Employee.js";

// Get all employees from database
export const getAllEmployees = async () => {
  return await Employee.find();  // MongoDB query
};

// Create new employee
export const createEmployee = async (data) => {
  return await Employee.create(data);
};

// Get employee by ID
export const getEmployeeById = async (id) => {
  return await Employee.findById(id);
};

// Update employee
export const updateEmployee = async (id, data) => {
  return await Employee.findByIdAndUpdate(
    id,
    data,
    { new: true }  // Return updated document
  );
};
```

## 5.8 Middleware - Authentication

**What is Middleware?**
Middleware is **code that runs between request and controller**.

**Example: Auth Middleware**
**Location**: `backend/src/middlewares/auth.middleware.js`

```javascript
import jwt from "jsonwebtoken";

const auth = async (req, res, next) => {
  try {
    // Get token from header
    const token = req.header("Authorization")?.replace("Bearer ", "");
    
    if (!token) {
      throw new Error("No token provided");
    }
    
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Add user to request
    req.userId = decoded.userId;
    req.userRole = decoded.role;
    
    // Continue to next middleware/controller
    next();
  } catch (error) {
    res.status(401).json({
      success: false,
      message: "Authentication failed",
    });
  }
};

export default auth;
```

## 5.9 Cron Jobs - Automated Tasks

**What is a Cron Job?**
Cron job runs **automatically at scheduled time**.

**Example: Daily Attendance Reset**
**Location**: `backend/src/jobs/attendance.job.js`

```javascript
import cron from "node-cron";
import Employee from "../models/Employee.js";
import Attendance from "../models/Attendance.js";

const initCron = () => {
  // Run at 00:00 (midnight) every day
  cron.schedule("0 0 * * *", async () => {
    console.log("Running Daily Attendance Reset Job...");
    
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      // Get all active employees
      const activeEmployees = await Employee.find({ status: "ACTIVE" });
      
      // Mark all as ABSENT by default
      for (const employee of activeEmployees) {
        await Attendance.create({
          employeeId: employee._id,
          date: today,
          status: "ABSENT",
        });
      }
      
      console.log("Attendance reset completed");
    } catch (error) {
      console.error("Error in cron job:", error);
    }
  });
};

export default initCron;
```

---

# 6. HOW EVERYTHING CONNECTS

## 6.1 Complete Flow Example: Login

**Step-by-step flow when user logs in:**

### Frontend (Flutter)

1. **User enters email and password in LoginScreen**
```dart
final email = _emailController.text;
final password = _passwordController.text;
```

2. **Call AuthProvider.login()**
```dart
final authProvider = context.read<AuthProvider>();
await authProvider.login(email, password);
```

3. **AuthProvider calls AuthService**
```dart
class AuthProvider {
  Future<bool> login(String email, String password) async {
    final response = await AuthService.login(email, password);
    _user = User.fromJson(response['user']);
    return true;
  }
}
```

4. **AuthService makes HTTP POST request**
```dart
class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await ApiService.post('/auth/login', {
      'email': email,
      'password': password,
    });
  }
}
```

### Backend (Node.js)

5. **Request reaches Express server**
```
POST http://localhost:8080/api/auth/login
Body: { "email": "user@example.com", "password": "123456" }
```

6. **Route matches and calls controller**
```javascript
// routes/auth.routes.js
router.post("/login", authController.login);
```

7. **Controller processes request**
```javascript
// controllers/auth.controller.js
export const login = async (req, res) => {
  const { email, password } = req.body;
  const result = await authService.login(email, password);
  res.json(result);
};
```

8. **Service handles business logic**
```javascript
// services/auth.service.js
export const login = async (email, password) => {
  // Find user in database
  const user = await User.findOne({ email }).select("+password");
  
  if (!user) {
    throw new Error("User not found");
  }
  
  // Check password
  const isMatch = await user.comparePassword(password);
  
  if (!isMatch) {
    throw new Error("Invalid password");
  }
  
  // Generate JWT token
  const token = jwt.sign(
    { userId: user._id, role: user.role },
    process.env.JWT_SECRET
  );
  
  return { user, token };
};
```

9. **Response sent back to Flutter**
```json
{
  "success": true,
  "user": {
    "id": "123",
    "name": "John Doe",
    "email": "user@example.com",
    "role": "EMPLOYEE"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

10. **Flutter receives response and updates UI**
```dart
// AuthProvider updates state
_user = User.fromJson(response['user']);
await ApiService.setToken(response['token']);
notifyListeners();  // UI rebuilds

// Navigate to dashboard
Navigator.pushReplacementNamed(context, '/dashboard');
```

## 6.2 Complete Flow Example: Get Employees List

### Frontend

1. **Screen loads, fetches employees**
```dart
class EmployeeListScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }
  
  Future<void> _loadEmployees() async {
    final provider = context.read<EmployeeProvider>();
    await provider.fetchEmployees();
  }
}
```

2. **Provider calls service**
```dart
class EmployeeProvider {
  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();
    
    _employees = await EmployeeService.getAllEmployees();
    
    _isLoading = false;
    notifyListeners();
  }
}
```

3. **Service makes GET request**
```dart
class EmployeeService {
  static Future<List<Employee>> getAllEmployees() async {
    final response = await ApiService.get('/employees');
    return (response as List)
        .map((json) => Employee.fromJson(json))
        .toList();
  }
}
```

### Backend

4. **Auth middleware verifies JWT token**
```javascript
// middlewares/auth.middleware.js
const auth = (req, res, next) => {
  const token = req.header("Authorization")?.replace("Bearer ", "");
  const decoded = jwt.verify(token, process.env.JWT_SECRET);
  req.userId = decoded.userId;
  next();  // Token valid, continue
};
```

5. **Controller receives request**
```javascript
export const getAllEmployees = async (req, res) => {
  const employees = await employeeService.getAllEmployees();
  res.json({
    success: true,
    data: employees,
  });
};
```

6. **Service queries database**
```javascript
export const getAllEmployees = async () => {
  return await Employee.find();  // Get all from MongoDB
};
```

7. **Response sent to Flutter**
```json
{
  "success": true,
  "data": [
    {
      "_id": "123",
      "name": "John Doe",
      "email": "john@example.com",
      "department": "IT",
      "status": "ACTIVE"
    },
    {
      "_id": "124",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "department": "HR",
      "status": "ACTIVE"
    }
  ]
}
```

8. **Flutter displays data**
```dart
ListView.builder(
  itemCount: provider.employees.length,
  itemBuilder: (context, index) {
    final employee = provider.employees[index];
    return ListTile(
      title: Text(employee.name),
      subtitle: Text(employee.department),
    );
  },
)
```

---

# 7. COMMON INTERVIEW QUESTIONS

## Q1: What is Flutter?
**Answer**: Flutter is Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase using Dart language.

## Q2: Difference between StatelessWidget and StatefulWidget?
**Answer**: 
- **StatelessWidget**: Immutable, doesn't change (e.g., Text, Icon)
- **StatefulWidget**: Mutable, can change state (e.g., TextField, Checkbox)

## Q3: What is State Management?
**Answer**: State management is how we manage and share data across the app. Our project uses **Provider** pattern.

## Q4: What is Provider?
**Answer**: Provider is a state management solution that uses InheritedWidget. It helps share data down the widget tree and notifies widgets when data changes.

## Q5: What is the difference between GET and POST?
**Answer**:
- **GET**: Retrieve data from server (e.g., get employee list)
- **POST**: Send data to server (e.g., create new employee)

## Q6: What is JWT?
**Answer**: JWT (JSON Web Token) is a secure way to transmit information between parties. Used for authentication - server gives token after login, client sends it with every request.

## Q7: What is MVC?
**Answer**: MVC (Model-View-Controller) is a design pattern:
- **Model**: Data structure and database
- **View**: User interface
- **Controller**: Handles requests and business logic

## Q8: What is MongoDB?
**Answer**: MongoDB is a NoSQL database that stores data in JSON-like documents. Flexible schema, good for modern applications.

## Q9: Explain your project architecture
**Answer**: 
"My project is an HR Management system with:
- **Frontend**: Flutter mobile app with Provider state management
- **Backend**: Node.js + Express REST API
- **Database**: MongoDB
- Communication via HTTP requests with JWT authentication"

## Q10: How does authentication work in your app?
**Answer**:
"1. User enters email/password
2. Frontend sends POST request to /api/auth/login
3. Backend verifies credentials in database
4. If valid, generates JWT token
5. Token sent back to frontend
6. Frontend stores token securely
7. All subsequent requests include this token in headers
8. Backend verifies token before processing requests"

## Q11: What is async/await?
**Answer**: 
```dart
// async = function returns Future (promise of future value)
// await = wait for async operation to complete
Future<void> loadData() async {
  final data = await apiCall();  // Wait here
  print(data);  // Runs after apiCall completes
}
```

## Q12: What is BuildContext?
**Answer**: BuildContext is a reference to the location of a widget in the widget tree. Used to access inherited widgets, theme, navigation, etc.

## Q13: What is middleware in Express?
**Answer**: Middleware is a function that runs between receiving a request and sending a response. Used for authentication, logging, error handling, etc.

## Q14: What is CORS?
**Answer**: CORS (Cross-Origin Resource Sharing) allows frontend (running on different domain/port) to call backend API. Without CORS, browsers block these requests for security.

## Q15: Explain the flow when user marks attendance
**Answer**:
"1. User clicks 'Mark Present' button in Flutter app
2. AttendanceProvider calls AttendanceService
3. Service makes POST request: /api/attendance/mark
4. Backend auth middleware verifies JWT
5. Controller receives request with employeeId and status
6. Service creates/updates attendance record in MongoDB
7. Response sent back to Flutter
8. Provider updates local state
9. UI refreshes to show 'Present' status"

---

# 8. KEY CONCEPTS TO REMEMBER

## 8.1 Flutter Basics
- Everything is a **Widget**
- **StatelessWidget** = Cannot change
- **StatefulWidget** = Can change
- **BuildContext** = Widget location reference
- **Navigator** = Manages screens
- **Provider** = State management

## 8.2 Dart Basics
- `async/await` = Handle asynchronous operations
- `Future` = Promise of future value
- `?` = Nullable type (can be null)
- `??` = Null coalescing operator (default value)
- `=>` = Arrow function (short syntax)
- `_` = Private (only accessible in same file)

## 8.3 Backend Basics
- **Express** = Web framework for Node.js
- **MongoDB** = NoSQL database
- **Mongoose** = MongoDB ODM (Object Document Mapper)
- **JWT** = JSON Web Token for authentication
- **Middleware** = Code between request and response
- **REST API** = GET, POST, PUT, DELETE

## 8.4 HTTP Status Codes
- **200** = Success
- **201** = Created
- **400** = Bad Request
- **401** = Unauthorized
- **404** = Not Found
- **500** = Server Error

## 8.5 Project Flow
```
UI (Screen) 
  → Provider (State) 
    → Service (API Call) 
      → HTTP Request 
        → Backend Route 
          → Middleware (Auth) 
            → Controller 
              → Service 
                → Model 
                  → Database
```

---

# 9. QUICK REVISION CHECKLIST

## Before Exam, Make Sure You Can Explain:

### Flutter
- [ ] What is a Widget?
- [ ] StatelessWidget vs StatefulWidget
- [ ] What is Provider and why use it?
- [ ] How to make API calls in Flutter?
- [ ] Navigation between screens
- [ ] What is BuildContext?
- [ ] Async/await and Future

### Backend
- [ ] What is Express?
- [ ] MVC pattern
- [ ] What are Routes, Controllers, Services, Models?
- [ ] What is middleware?
- [ ] How JWT authentication works
- [ ] GET vs POST vs PUT vs DELETE
- [ ] What is MongoDB?

### Your Project
- [ ] Overall architecture (Frontend + Backend)
- [ ] How login works (complete flow)
- [ ] How to fetch employee list
- [ ] How attendance marking works
- [ ] What is Provider doing in your app
- [ ] What is auth middleware doing
- [ ] Why use JWT tokens

---

# 10. DEBUGGING TIPS

## If interviewer asks to fix a bug:

### Frontend Issues

**Problem**: "Data not showing on screen"
**Check**:
1. Is Provider notifyListeners() called?
2. Is API call successful? (check response)
3. Is data being parsed correctly? (fromJson)
4. Is UI rebuilding? (use Consumer or context.watch)

**Problem**: "Navigation not working"
**Check**:
1. Is route defined in MaterialApp?
2. Is context available?
3. Spelling of route name

### Backend Issues

**Problem**: "API returning 401 Unauthorized"
**Check**:
1. Is JWT token being sent? (check headers)
2. Is token valid? (not expired)
3. Is auth middleware working?

**Problem**: "API returning 500 Server Error"
**Check**:
1. Database connection working?
2. Check server logs
3. Data validation (required fields)

---

# 11. EXAMPLE ANSWERS FOR DEMO

## If asked: "Show me the code for login"

**You say**:
"Sure! Let me show you the complete flow:

**1. UI Layer (LoginScreen.dart)**
```dart
// User enters credentials
final email = _emailController.text;
final password = _passwordController.text;

// Call provider
await context.read<AuthProvider>().login(email, password);
```

**2. State Management (AuthProvider.dart)**
```dart
Future<bool> login(String email, String password) async {
  final response = await AuthService.login(email, password);
  _user = User.fromJson(response['user']);
  notifyListeners();  // Update UI
  return true;
}
```

**3. API Call (AuthService.dart)**
```dart
static Future<Map<String, dynamic>> login(String email, String password) {
  return ApiService.post('/auth/login', {
    'email': email,
    'password': password,
  });
}
```

**4. Backend (auth.controller.js)**
```javascript
export const login = async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email });
  const isMatch = await user.comparePassword(password);
  const token = jwt.sign({ userId: user._id }, JWT_SECRET);
  res.json({ user, token });
};
```

This follows the **separation of concerns** principle - UI, state, API, and backend each have their own responsibility."

---

# FINAL TIPS FOR YOUR EXAM

1. **Practice explaining out loud** - Don't just read, speak the concepts
2. **Draw diagrams** - Architecture, flow diagrams help understand
3. **Trace code flow** - Pick one feature (login), trace from UI to database
4. **Know your models** - Employee, User, Attendance structure
5. **Understand Provider** - It's the heart of your Flutter app
6. **Know HTTP methods** - GET, POST, PUT, DELETE - what each does
7. **JWT concept** - How authentication works in your app
8. **Be confident** - You built this, you know it!

## What to Say if Stuck:
- "Let me trace through the code flow..."
- "This follows the MVC pattern where..."
- "The Provider manages state and notifies listeners..."
- "We use JWT for secure authentication..."

## Red Flags to Avoid:
- ❌ "I don't know, AI made it"
- ❌ "I'm not sure how this works"
- ✅ "Let me walk through this step by step"
- ✅ "This is the Flutter/Provider/MVC pattern"

---

# GOOD LUCK! 🎉

You've got this! Remember:
- Take your time to explain
- Draw if needed
- Show the code
- Explain the flow
- Connect frontend to backend

**You understand the concepts now - just explain confidently!**

---

**Document Created**: February 11, 2026  
**For Exam On**: February 12, 2026  
**Total Pages**: This comprehensive guide  
**Time to Study**: Give yourself 3-4 hours to go through this properly

---

