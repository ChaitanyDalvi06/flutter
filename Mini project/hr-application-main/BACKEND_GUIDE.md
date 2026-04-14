# 📚 HR Management System - Backend Complete Guide for Beginners

Welcome! This guide will teach you the entire backend system of the HR Management Application **step by step**, from basic concepts to actual code. Let's learn together!

---

## 📖 Table of Contents

1. [Project Overview](#project-overview)
2. [How the Backend Works (High Level)](#how-the-backend-works-high-level)
3. [Project Structure](#project-structure)
4. [Core Concepts](#core-concepts)
5. [File-by-File Explanation](#file-by-file-explanation)
6. [How Requests Flow](#how-requests-flow)
7. [Detailed Module Explanations](#detailed-module-explanations)
8. [Database Models](#database-models)
9. [API Endpoints](#api-endpoints)

---

## 🎯 Project Overview

This is an **HR Management System** backend built with **Node.js and Express**. It manages:
- 👥 **Employees** - Create, read, update employee records
- 📋 **Attendance** - Track daily attendance
- 🏖️ **Leaves** - Request and manage employee leaves
- 💰 **Payroll** - Calculate and manage employee salaries
- 📊 **Dashboard** - View company-wide statistics
- 🔐 **Authentication** - User login and registration with JWT tokens

Think of it as a **digital HR office** that handles all employee-related tasks.

---

## 🔄 How the Backend Works (High Level)

```
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND FLOW                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Mobile/Web App (Frontend)                                      │
│           ↓                                                      │
│  Makes HTTP Request (e.g., POST /api/employees)               │
│           ↓                                                      │
│  Express Server (src/server.js)                                │
│           ↓                                                      │
│  Route Handler (e.g., src/routes/employee.routes.js)          │
│           ↓                                                      │
│  Controller (e.g., src/controllers/employee.controller.js)    │
│           ↓                                                      │
│  Service (e.g., src/services/employee.service.js)             │
│           ↓                                                      │
│  Database (MongoDB) - via Models                               │
│           ↓                                                      │
│  Response sent back to Frontend                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**In Simple Words:**
1. Frontend sends a request
2. Express (web server) receives it
3. Routes decide which controller to run
4. Controller calls a Service (business logic)
5. Service talks to Database
6. Response goes back to Frontend

---

## 📁 Project Structure

```
backend/
├── .env                    # Configuration (PORT, DATABASE URL, etc.)
├── package.json            # Project dependencies
├── src/
│   ├── server.js          # 🚀 START HERE - Entry point
│   ├── app.js             # Express app configuration
│   ├── config/
│   │   ├── db.js          # Database connection setup
│   │   └── constants.js   # App-wide constants (statuses, roles)
│   ├── models/            # Database schemas (MongoDB)
│   │   ├── User.js        # User/Login data
│   │   ├── Employee.js    # Employee records
│   │   ├── Attendance.js  # Attendance records
│   │   ├── Leave.js       # Leave requests
│   │   ├── Payroll.js     # Salary calculations
│   │   └── Salary.js      # Salary details
│   ├── controllers/       # Handle requests, call services
│   │   ├── auth.controller.js
│   │   ├── employee.controller.js
│   │   ├── attendance.controller.js
│   │   ├── leave.controller.js
│   │   ├── payroll.controller.js
│   │   └── dashboard.controller.js
│   ├── services/          # Business logic
│   │   ├── employee.service.js
│   │   ├── attendance.service.js
│   │   ├── leave.service.js
│   │   ├── payroll.service.js
│   │   └── dashboard.service.js
│   ├── routes/            # URL endpoints
│   │   ├── auth.routes.js
│   │   ├── employee.routes.js
│   │   ├── attendance.routes.js
│   │   ├── leave.routes.js
│   │   ├── payroll.routes.js
│   │   └── dashboard.routes.js
│   ├── middlewares/       # Functions that process requests
│   │   ├── auth.middleware.js    # Check JWT token
│   │   └── error.middleware.js   # Handle errors
│   ├── jobs/              # Scheduled tasks
│   │   └── attendance.job.js     # Runs daily
│   └── utils/             # Helper functions
│       └── payrollCalculator.js
```

---

## 🎓 Core Concepts

### 1. **What is Express?**
Express is a web server framework for Node.js. Think of it as:
- A librarian who receives requests from visitors
- Finds the right information (via routes)
- Sends back responses

### 2. **What is MongoDB?**
MongoDB is a database. Think of it as:
- A filing cabinet where we store data
- Data is stored as JSON-like documents
- We can query (search) through data

### 3. **What is JWT (JSON Web Token)?**
JWT is a security token. When user logs in:
1. Server creates a token and gives it to the user
2. User sends this token with every request
3. Server verifies the token before allowing access
4. Think of it as a **digital ID card**

### 4. **What is Middleware?**
Middleware functions process requests **before** they reach the controller. Think of them as:
- Security guards checking ID at the gate
- Validators checking if data is correct
- Error handlers catching problems

### 5. **What is a Model?**
A Model defines the **shape of data** in the database. Example:
```javascript
// User model defines: User has name, email, password, role
User {
  name: String,
  email: String,
  password: String,
  role: String
}
```

### 6. **What is a Service?**
A Service contains **business logic** (rules of the business). Example:
- How to calculate payroll?
- What makes a valid leave request?
- How to count attendance?

### 7. **What is a Controller?**
A Controller **handles HTTP requests**. It:
- Reads the request data
- Calls the service for business logic
- Sends back the response

### 8. **What is a Route?**
A Route **maps URLs to controller functions**. Example:
```
GET  /api/employees       → getEmployees controller
POST /api/employees       → addEmployee controller
GET  /api/employees/:id   → getEmployeeById controller
```

---

## 📄 File-by-File Explanation

### 1. **package.json** - Project Configuration

```json
{
  "name": "hr",
  "version": "1.0.0",
  "main": "src/server.js",           // Entry point
  "type": "module",                  // Use ES6 imports
  "scripts": {
    "start": "node src/server.js",   // Production: node src/server.js
    "dev": "node --watch src/server.js"  // Development: auto-reload
  },
  "dependencies": {
    "express": "^5.2.1",             // Web server framework
    "mongoose": "^9.1.6",            // MongoDB ODM (connect to database)
    "jsonwebtoken": "^9.0.3",        // JWT for authentication
    "bcryptjs": "^3.0.3",            // Hash passwords (security)
    "cors": "^2.8.6",                // Allow cross-origin requests
    "dotenv": "^17.2.4",             // Load environment variables
    "node-cron": "^4.2.1"            // Schedule jobs (e.g., daily tasks)
  }
}
```

**What Each Dependency Does:**
- **express** - Creates the web server
- **mongoose** - Connects to MongoDB and defines models
- **jsonwebtoken** - Creates and verifies login tokens
- **bcryptjs** - Securely hashes passwords
- **cors** - Allows frontend to call backend APIs
- **dotenv** - Loads `.env` file (PORT, DATABASE URL, etc.)
- **node-cron** - Runs tasks on a schedule (like marking all employees absent daily)

### 2. **.env** - Secret Configuration

```env
PORT=8080                    # Server runs on http://localhost:8080
MONGO_URI=mongodb://localhost:27017/hr  # Local MongoDB connection
JWT_SECRET=hr_app_super_secret_jwt_key_2026  # Secret key for JWT
```

**Why .env?**
- Keep sensitive data out of code
- Easy to change for different environments (dev, production)
- Never commit `.env` to Git (it has secrets)

### 3. **src/server.js** - Application Entry Point

```javascript
import "dotenv/config";              // Load environment variables
import app from "./app.js";
import connectDB from "./config/db.js";  // Connect to MongoDB
import { PORT } from "./config/constants.js";
import initCron from "./jobs/attendance.job.js";  // Start scheduled jobs

connectDB();        // Step 1: Connect to database
initCron();         // Step 2: Start daily attendance job

app.listen(PORT, () => {  // Step 3: Start web server
  console.log("Server running on port", PORT);
});
```

**What Happens:**
1. Load `.env` file
2. Connect to MongoDB
3. Start scheduled jobs (e.g., daily attendance reset)
4. Start Express server on PORT 8080

**To Run:**
```bash
npm start          # Production
npm run dev        # Development (auto-reload on file change)
```

### 4. **src/app.js** - Express Configuration

```javascript
import express from "express";
import cors from "cors";
import errorMiddleware from "./middlewares/error.middleware.js";

import authRoutes from "./routes/auth.routes.js";
import employeeRoutes from "./routes/employee.routes.js";
// ... other routes

const app = express();

app.use(cors());           // Allow frontend to call this API
app.use(express.json());   // Parse JSON from requests

// Mount route groups
app.use("/api/auth", authRoutes);           // Login/Register
app.use("/api/employees", employeeRoutes);  // Employee CRUD
app.use("/api/attendance", attendanceRoutes);  // Attendance
app.use("/api/payroll", payrollRoutes);     // Salary
app.use("/api/leaves", leaveRoutes);        // Leave requests
app.use("/api/dashboard", dashboardRoutes); // Stats

app.use(errorMiddleware);  // Catch all errors

export default app;
```

**What This Does:**
- Creates Express app
- Allows cross-origin requests (frontend can call backend)
- Parses JSON from request body
- Mounts all routes under `/api/`
- Catches and handles errors

### 5. **src/config/db.js** - MongoDB Connection

```javascript
import mongoose from "mongoose";

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB Connected");
  } catch (error) {
    console.error("DB Error:", error.message);
  }
};

export default connectDB;
```

**What This Does:**
- Connects to MongoDB using the URI from `.env`
- If connection fails, logs the error

### 6. **src/config/constants.js** - App Constants

```javascript
export const PORT = process.env.PORT || 5000;

// All possible employee statuses
export const EMPLOYEE_STATUS = ["ACTIVE", "INACTIVE", "RESIGNED"];

// All possible attendance statuses
export const ATTENDANCE_STATUS = [
  "PRESENT", "ABSENT", "HALF_DAY", "LEAVE", "HOLIDAY", "WEEK_OFF"
];

// Payroll statuses
export const PAYROLL_STATUS = ["GENERATED", "PAID"];

// Leave types
export const LEAVE_TYPES = [
  "SICK", "CASUAL", "ANNUAL", "UNPAID", "MATERNITY", "PATERNITY"
];

// Leave request statuses
export const LEAVE_REQUEST_STATUS = [
  "PENDING", "APPROVED", "REJECTED", "CANCELLED"
];
```

**Why Use Constants?**
- Avoid typos and mistakes
- If we want to change a status, we change it here once
- Used everywhere in the app for validation

---

## 🗄️ Database Models

### **What is a Model?**
A Model is like a **blueprint** for data. It defines:
- What fields data has
- What type of data each field is
- Validation rules

### 1. **User Model** - Login Accounts

```javascript
// A User document looks like:
{
  _id: "507f1f77bcf86cd799439011",    // Auto-generated ID
  name: "John Doe",
  email: "john@company.com",
  password: "$2a$12$...",              // Hashed (encrypted)
  role: "ADMIN",                       // ADMIN, HR, or EMPLOYEE
  employeeId: "507f...",               // Reference to Employee
  createdAt: "2026-02-09T00:00:00Z",  // Auto-added by MongoDB
  updatedAt: "2026-02-09T00:00:00Z"   // Auto-updated by MongoDB
}
```

**Key Points:**
- Password is **hashed** (encrypted) for security
- Each User is linked to one Employee (via `employeeId`)
- Roles determine permissions:
  - **ADMIN** - Full access
  - **HR** - Can manage employees, attendance, payroll
  - **EMPLOYEE** - Can view own data, request leaves

**Code:**
```javascript
userSchema.pre("save", async function () {
  if (!this.isModified("password")) return;
  this.password = await bcrypt.hash(this.password, 12);  // Hash password
});

userSchema.methods.comparePassword = async function (candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);  // Verify
};
```

### 2. **Employee Model** - Employee Records

```javascript
// An Employee document looks like:
{
  _id: "507f...",
  name: "John Doe",
  email: "john@company.com",
  department: "Engineering",
  designation: "Software Engineer",
  joiningDate: "2024-01-15",
  status: "ACTIVE",  // ACTIVE, INACTIVE, RESIGNED
  
  salaryStructure: {
    basic: 50000,
    hra: 10000,
    allowances: [
      { name: "Travel", amount: 5000 },
      { name: "Mobile", amount: 2000 }
    ],
    deductions: [
      { name: "Insurance", amount: 1000 },
      { name: "Tax", amount: 5000 }
    ]
  },
  
  userId: "507f...",  // Reference to User (for login)
  createdAt: "2026-01-15T00:00:00Z",
  updatedAt: "2026-02-09T00:00:00Z"
}
```

### 3. **Attendance Model** - Daily Attendance

```javascript
// An Attendance document looks like:
{
  _id: "507f...",
  employeeId: "507f...",  // Which employee
  date: "2026-02-09",     // Which date (midnight)
  status: "PRESENT",      // PRESENT, ABSENT, HALF_DAY, LEAVE, HOLIDAY, WEEK_OFF
  createdAt: "2026-02-09T06:30:00Z"
}

// Important: One attendance record per employee per day
// Can't have two records for same employee on same day
```

### 4. **Leave Model** - Leave Requests

```javascript
// A Leave document looks like:
{
  _id: "507f...",
  employeeId: "507f...",        // Who requested
  leaveType: "SICK",             // SICK, CASUAL, ANNUAL, UNPAID, etc.
  startDate: "2026-02-10",
  endDate: "2026-02-12",
  days: 3,                        // Number of days requested
  reason: "Not feeling well",
  status: "PENDING",              // PENDING, APPROVED, REJECTED, CANCELLED
  approvedBy: "507f...",          // HR/Manager who approved (if approved)
  approvedAt: "2026-02-09T10:00:00Z",
  createdAt: "2026-02-09T09:00:00Z"
}
```

### 5. **Payroll Model** - Salary Calculation

```javascript
// A Payroll document looks like:
{
  _id: "507f...",
  employeeId: "507f...",
  month: 2,      // February
  year: 2026,
  
  attendanceSummary: {
    totalDays: 28,       // Days in month
    presentDays: 22,     // Days marked present (Half days count as 0.5)
    lopDays: 1           // Loss of Pay days (ABSENT)
  },
  
  breakdown: {
    basic: 50000,                      // Base salary
    hra: 10000,                        // House Rent Allowance
    allowances: 7000,                  // Other allowances
    gross: 67000,                      // Total before deductions
    deductions: 6000,                  // Fixed deductions
    lopDeduction: 2272.73,             // Deduction for absent days
    netSalary: 58727.27                // Final salary (Gross - Deductions - LOP)
  },
  
  status: "GENERATED",                 // GENERATED or PAID
  createdAt: "2026-02-01T00:00:00Z",
  updatedAt: "2026-02-09T00:00:00Z"
}
```

**Payroll Calculation Example:**
```
Gross Salary = Basic + HRA + Allowances = 50000 + 10000 + 7000 = 67000
Total Deductions = 6000
Per Day Salary = 67000 / 28 days = 2392.86
LOP Deduction = 1 absent day × 2392.86 = 2392.86
Net Salary = 67000 - 6000 - 2392.86 = 58607.14
```

---

## 🔐 Authentication & Middleware

### **Authentication Middleware** - Verify JWT Token

```javascript
export const authMiddleware = async (req, res, next) => {
  try {
    // Get token from header
    const token = req.headers.authorization?.replace("Bearer ", "");
    
    if (!token) {
      return res.status(401).json({ message: "No token provided" });
    }
    
    // Verify token using secret
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Find user by ID from token
    const user = await User.findById(decoded.id);
    
    if (!user) {
      return res.status(401).json({ message: "User not found" });
    }
    
    // Attach user to request so controller can use it
    req.user = user;
    next();  // Allow request to continue
    
  } catch (error) {
    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({ message: "Invalid token" });
    }
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({ message: "Token expired" });
    }
    next(error);
  }
};
```

**How JWT Works:**
1. User logs in → Server creates token
2. Frontend stores token
3. Frontend sends token with each request in header:
   ```
   Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
4. Server verifies token → Allows or denies request

### **Role-Based Access Control**

```javascript
export const requireRole = (...roles) => {
  return (req, res, next) => {
    // Check if user exists
    if (!req.user) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    
    // Check if user's role is allowed
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        message: "Forbidden - Insufficient permissions"
      });
    }
    
    next();  // Allow request to continue
  };
};
```

**Usage Example:**
```javascript
// Only ADMIN and HR can access this endpoint
router.post("/", requireRole("ADMIN", "HR"), controller.addEmployee);

// Any authenticated user can access this endpoint
router.get("/", authMiddleware, controller.getEmployees);
```

### **Error Middleware**

```javascript
export default (err, req, res, next) => {
  console.error(err);  // Log error for debugging
  
  res.status(500).json({
    success: false,
    message: err.message || "Internal Server Error"
  });
};
```

This catches any error that happens in a controller and sends a nice error response.

---

## 🔄 How Requests Flow

Let's trace a **real example**: An employee requesting a leave

### **Request Flow Diagram:**

```
1. FRONTEND (Flutter App)
   ↓
   POST /api/leaves
   {
     "leaveType": "SICK",
     "startDate": "2026-02-10",
     "endDate": "2026-02-12",
     "days": 3,
     "reason": "Not feeling well"
   }

2. ROUTES (leave.routes.js)
   ↓
   Middleware: authMiddleware (verify JWT)
   ↓
   Call: controller.createLeave

3. CONTROLLER (leave.controller.js)
   ↓
   Extract data from req.body
   ↓
   Call: leaveService.create(req.body)

4. SERVICE (leave.service.js)
   ↓
   Validate data
   ↓
   Call: Leave.create(data)

5. MODEL (Leave.js) + DATABASE (MongoDB)
   ↓
   Save document to database
   ↓
   Return saved document

6. RESPONSE Back Through Chain:
   Service → Controller → Route → FRONTEND
   ↓
   {
     "message": "Leave request submitted successfully",
     "leave": {
       "_id": "507f...",
       "employeeId": "507f...",
       "leaveType": "SICK",
       "startDate": "2026-02-10",
       "endDate": "2026-02-12",
       "days": 3,
       "reason": "Not feeling well",
       "status": "PENDING",
       ...
     }
   }
```

---

## 📦 Detailed Module Explanations

### **Authentication Module**

#### **Auth Routes** (`routes/auth.routes.js`)
```javascript
router.post("/register", controller.register);    // Create account
router.post("/login", controller.login);          // Login
router.get("/me", controller.getMe);              // Get current user
```

#### **Auth Controller** (`controllers/auth.controller.js`)

**1. Register - Create New Account**
```javascript
export const register = async (req, res, next) => {
  // Input:
  // {
  //   "name": "John Doe",
  //   "email": "john@company.com",
  //   "password": "password123",
  //   "department": "Engineering"
  // }

  // Step 1: Check if email already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) return res.status(400).json({ message: "Email already registered" });

  // Step 2: Create Employee record
  const employee = await Employee.create({
    name, email, department,
    status: "ACTIVE"
  });

  // Step 3: Create User record (for login)
  const user = await User.create({
    name, email, password, role: "EMPLOYEE",
    employeeId: employee._id  // Link to employee
  });

  // Step 4: Generate JWT token
  const token = generateToken(user._id);

  // Step 5: Send response
  res.status(201).json({
    success: true,
    token,  // Frontend stores this
    user: { id, name, email, role }
  });
};
```

**What Happens:**
1. Frontend sends: email, password, name, department
2. Backend creates User (for login) + Employee (for HR data)
3. Backend generates JWT token
4. Frontend stores token and uses it for future requests

**Password Security:**
```javascript
// Before saving to database, password is hashed:
this.password = await bcrypt.hash(this.password, 12);

// When user logs in, we compare:
const isValid = await bcrypt.compare("password123", hashedPassword);
```

**2. Login - Authenticate User**
```javascript
export const login = async (req, res, next) => {
  // Input: { "email": "john@company.com", "password": "password123" }

  // Step 1: Find user by email
  const user = await User.findOne({ email }).select("+password");

  // Step 2: Check if password matches
  if (!user || !(await user.comparePassword(password))) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  // Step 3: Generate token
  const token = generateToken(user._id);

  // Step 4: Send response
  res.json({
    success: true,
    token,  // Frontend stores this
    user: { id, name, email, role }
  });
};
```

**What Happens:**
1. Frontend sends: email, password
2. Backend finds user and checks password
3. If correct, generates JWT token
4. Frontend stores token in localStorage/SecureStorage

---

### **Employee Module**

#### **Employee Routes** (`routes/employee.routes.js`)
```javascript
router.post("/", requireRole("ADMIN", "HR"), controller.addEmployee);
router.get("/", controller.getEmployees);
router.get("/:id", controller.getEmployeeById);
router.put("/:id", requireRole("ADMIN", "HR"), controller.updateEmployee);
```

#### **Employee Service** (`services/employee.service.js`)
```javascript
export const getAllEmployees = async () => {
  return await Employee.find();  // Get all from database
};

export const getEmployeeById = async (id) => {
  return await Employee.findById(id);  // Get one by ID
};

export const updateEmployee = async (id, data) => {
  return await Employee.findByIdAndUpdate(id, data, { new: true });
};
```

#### **Employee Controller** (`controllers/employee.controller.js`)

**Add Employee:**
```javascript
export const addEmployee = async (req, res) => {
  // Input from Frontend:
  // {
  //   "name": "Jane Smith",
  //   "email": "jane@company.com",
  //   "department": "HR",
  //   "designation": "HR Manager",
  //   "salary": 60000
  // }

  // Check if email already exists
  const existingEmployee = await Employee.findOne({ email });
  if (existingEmployee) {
    return res.status(400).json({
      message: "Employee with this email already exists"
    });
  }

  // Create employee
  const employee = await Employee.create({
    name, email, department, designation,
    joiningDate: new Date(),
    status: "INACTIVE"  // HR will activate later
  });

  // Also create User account (for login)
  const user = await User.create({
    name, email,
    password: "default_password",  // They change on first login
    role: "EMPLOYEE",
    employeeId: employee._id
  });

  res.json({
    message: "Employee added successfully",
    data: employee
  });
};
```

---

### **Attendance Module**

#### **Attendance Routes** (`routes/attendance.routes.js`)
```javascript
router.post("/mark", controller.markAttendance);           // Mark attendance
router.post("/check-in", controller.selfCheckIn);         // Quick check-in
router.get("/daily", controller.getDailyAttendance);      // Admin view daily
router.get("/:employeeId", controller.getEmployeeAttendance);  // Employee's history
```

#### **Attendance Service** (`services/attendance.service.js`)

```javascript
export const markAttendance = async (data) => {
  const { employeeId, date, status } = data;
  
  // Normalize date to midnight (ignore time)
  const startOfDay = new Date(date);
  startOfDay.setHours(0, 0, 0, 0);

  // Find if attendance already exists for this day
  const records = await Attendance.find({
    employeeId,
    date: { $gte: startOfDay, $lte: endOfDay }
  });

  if (records.length > 0) {
    // Update existing record
    records[0].status = status;
    await records[0].save();
    
    // Delete duplicates if any
    if (records.length > 1) {
      await Attendance.deleteMany({ _id: { $in: duplicateIds } });
    }
    
    return records[0];
  } else {
    // Create new record
    return await Attendance.create({
      employeeId,
      date: startOfDay,
      status
    });
  }
};
```

**Key Point:** Only **one** attendance record per employee per day (enforced by unique index)

#### **Attendance Controller** (`controllers/attendance.controller.js`)

**Mark Attendance:**
```javascript
export const markAttendance = async (req, res) => {
  const { employeeId, date, status } = req.body;
  const user = req.user;

  // Business Rule: Employees can only mark their own attendance
  if (user.role === "EMPLOYEE") {
    if (user.employeeId?.toString() !== employeeId) {
      return res.status(403).json({
        message: "You can only mark your own attendance"
      });
    }
  }

  // Admin/HR can mark anyone's attendance

  const attendance = await attendanceService.markAttendance({
    employeeId, date, status
  });

  res.json({
    message: "Attendance marked successfully",
    data: attendance
  });
};
```

**Self Check-in (Employees):**
```javascript
export const selfCheckIn = async (req, res) => {
  const user = req.user;  // Current logged-in user

  if (!user.employeeId) {
    return res.status(400).json({
      message: "No employee profile linked to your account"
    });
  }

  // Mark today as PRESENT
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const attendance = await attendanceService.markAttendance({
    employeeId: user.employeeId,
    date: today.toISOString(),
    status: "PRESENT"
  });

  res.json({
    message: "Check-in successful",
    data: attendance
  });
};
```

#### **Scheduled Job** (`jobs/attendance.job.js`)

This job **runs automatically every day at midnight**:

```javascript
const initCron = () => {
  // Cron syntax: "0 0 * * *" = 00:00 every day
  cron.schedule("0 0 * * *", async () => {
    console.log("Running Daily Attendance Reset...");

    // Step 1: Get all ACTIVE employees
    const activeEmployees = await Employee.find({ status: "ACTIVE" });

    // Step 2: Get all APPROVED leaves for today
    const activeLeaves = await Leave.find({
      startDate: { $lte: today },
      endDate: { $gte: today },
      status: "APPROVED"
    });

    const employeesOnLeave = new Set(
      activeLeaves.map(l => l.employeeId.toString())
    );

    // Step 3: For each employee, mark:
    // - LEAVE if on approved leave
    // - ABSENT if not on leave (default)
    for (const employee of activeEmployees) {
      const status = employeesOnLeave.has(employee._id.toString())
        ? "LEAVE"
        : "ABSENT";

      await Attendance.create({
        employeeId: employee._id,
        date: today,
        status
      });
    }
  });
};
```

**What This Does:**
- Runs every day at 00:00 (midnight)
- Marks all employees as ABSENT (or LEAVE if on approved leave)
- So HR doesn't have to manually mark everyone
- If employee checks in, their status changes to PRESENT

---

### **Leave Module**

#### **Leave Routes** (`routes/leave.routes.js`)
```javascript
router.post("/", controller.createLeave);           // Create leave request
router.get("/", requireRole("ADMIN", "HR"), controller.getAllLeaves);  // Admin view all
router.get("/employee/:employeeId", controller.getLeavesByEmployee);    // Employee's leaves
router.put("/:id", requireRole("ADMIN", "HR"), controller.updateLeave); // Approve/reject
```

#### **Leave Service** (`services/leave.service.js`)

```javascript
export const create = async (data) => {
  // Save leave request to database
  return Leave.create(data);
};

export const getLeaveDaysInMonth = async (employeeId, year, month) => {
  // Count how many days employee was on APPROVED leave this month
  
  const start = new Date(year, month - 1, 1);        // 1st of month
  const end = new Date(year, month, 0);              // Last of month

  // Find all APPROVED leaves in this month
  const leaves = await Leave.find({
    employeeId,
    status: "APPROVED",
    startDate: { $lte: end },    // Leave started before month ends
    endDate: { $gte: start }     // Leave ended after month starts
  });

  let totalDays = 0;
  for (const leave of leaves) {
    // Calculate overlap between leave and this month
    const overlapStart = new Date(
      Math.max(leave.startDate.getTime(), start.getTime())
    );
    const overlapEnd = new Date(
      Math.min(leave.endDate.getTime(), end.getTime())
    );
    
    const days = Math.ceil(
      (overlapEnd - overlapStart) / (1000 * 60 * 60 * 24)
    ) + 1;
    
    totalDays += Math.max(0, days);
  }

  return totalDays;
};
```

**Example:**
- Leave from Feb 10-15 = 6 days
- If calculating for February 2026, it counts all 6 days
- If calculating for March 2026, it counts 0 days (leave ended)

#### **Leave Controller** (`controllers/leave.controller.js`)

```javascript
export const createLeave = async (req, res) => {
  // Input: {
  //   "leaveType": "SICK",
  //   "startDate": "2026-02-10",
  //   "endDate": "2026-02-12",
  //   "days": 3,
  //   "reason": "Not feeling well"
  // }

  const leave = await leaveService.create(req.body);

  res.json({
    message: "Leave request submitted successfully",
    leave
  });
};

export const updateLeave = async (req, res) => {
  // Only HR/Admin can approve/reject
  // Input for update: { "status": "APPROVED" }

  const leave = await leaveService.updateById(req.params.id, req.body);

  if (!leave) {
    return res.status(404).json({ message: "Leave not found" });
  }

  res.json(leave);
};
```

---

### **Payroll Module**

#### **Payroll Routes** (`routes/payroll.routes.js`)
```javascript
router.post("/generate", requireRole("ADMIN", "HR"), controller.generatePayroll);
router.post("/salary/:employeeId", requireRole("ADMIN", "HR"), controller.updateSalaryStructure);
router.get("/history", requireRole("ADMIN", "HR"), controller.getAllPayrollHistory);
router.get("/:employeeId", controller.getEmployeePayroll);
```

#### **Payroll Service** (`services/payroll.service.js`)

**Main Payroll Calculation:**

```javascript
export const runPayroll = async (employee, month, year) => {
  // Step 1: Define month boundaries
  const startDate = new Date(year, month - 1, 1);     // 1st of month
  const endDate = new Date(year, month, 0);           // Last day of month
  const totalDays = endDate.getDate();                // Days in month (28-31)

  // Step 2: Get all attendance records for the month
  const attendanceRecords = await Attendance.find({
    employeeId: employee._id,
    date: { $gte: startDate, $lte: endDate }
  });

  // Step 3: Count present and absent days
  let presentDays = 0;
  let lopDays = 0;  // Loss of Pay

  attendanceRecords.forEach(record => {
    if (record.status === "PRESENT") presentDays += 1;
    else if (record.status === "HALF_DAY") presentDays += 0.5;
    else if (record.status === "ABSENT") lopDays += 1;
    // LEAVE is approved absence, not counted as LOP
  });

  // Step 4: Extract salary structure
  const { basic, hra, allowances, deductions } = employee.salaryStructure;

  const totalAllowances = allowances.reduce((sum, item) => sum + item.amount, 0);
  const totalDeductions = deductions.reduce((sum, item) => sum + item.amount, 0);

  // Step 5: Calculate salary
  const grossSalary = basic + hra + totalAllowances;
  const perDaySalary = grossSalary / totalDays;
  const lopDeduction = lopDays * perDaySalary;
  const netSalary = grossSalary - totalDeductions - lopDeduction;

  // Step 6: Save to database
  const payrollData = {
    employeeId: employee._id,
    month, year,
    attendanceSummary: { totalDays, presentDays, lopDays },
    breakdown: {
      basic, hra,
      allowances: totalAllowances,
      gross: grossSalary,
      deductions: totalDeductions,
      lopDeduction: parseFloat(lopDeduction.toFixed(2)),
      netSalary: parseFloat(netSalary.toFixed(2))
    },
    status: "GENERATED"
  };

  // Create or update existing payroll
  const payroll = await Payroll.findOneAndUpdate(
    { employeeId: employee._id, month, year },
    payrollData,
    { new: true, upsert: true }
  );

  return payroll;
};
```

**Payroll Calculation Example:**
```
Employee: John Doe (February 2026, 28 days)
Attendance: 22 present days, 1 absent day, 5 holidays/weekends

Basic: 50,000
HRA: 10,000
Allowances: 5,000 (Travel) + 2,000 (Mobile) = 7,000
Gross Salary: 50,000 + 10,000 + 7,000 = 67,000

Per Day Salary: 67,000 / 28 = 2,392.86
LOP (Loss of Pay): 1 absent × 2,392.86 = 2,392.86

Deductions: 1,000 (Insurance) + 5,000 (Tax) = 6,000

Net Salary: 67,000 - 6,000 - 2,392.86 = 58,607.14
```

#### **Payroll Controller** (`controllers/payroll.controller.js`)

**Generate Payroll for All Employees:**

```javascript
export const generatePayroll = async (req, res) => {
  const { month, year } = req.body;  // e.g., { month: 2, year: 2026 }

  try {
    // Get all ACTIVE employees
    const employees = await Employee.find({ status: "ACTIVE" });
    const results = [];

    // Generate payroll for each employee
    for (const emp of employees) {
      try {
        const payroll = await payrollService.runPayroll(emp, month, year);
        results.push(payroll);
      } catch (err) {
        console.error(`Failed for ${emp.name}:`, err);
      }
    }

    res.json({
      message: `Payroll generated for ${results.length} employees`,
      generated: results.length
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
```

**Update Salary Structure:**

```javascript
export const updateSalaryStructure = async (req, res) => {
  const { employeeId } = req.params;
  const { basic, hra, allowances, deductions } = req.body;

  // Example input:
  // {
  //   "basic": 50000,
  //   "hra": 10000,
  //   "allowances": [
  //     { "name": "Travel", "amount": 5000 },
  //     { "name": "Mobile", "amount": 2000 }
  //   ],
  //   "deductions": [
  //     { "name": "Insurance", "amount": 1000 },
  //     { "name": "Tax", "amount": 5000 }
  //   ]
  // }

  const employee = await Employee.findById(employeeId);
  if (!employee) {
    return res.status(404).json({ message: "Employee not found" });
  }

  // Update salary structure
  employee.salaryStructure = {
    basic: Number(basic),
    hra: Number(hra),
    allowances,
    deductions
  };

  await employee.save();

  res.json({
    message: "Salary structure updated",
    salaryStructure: employee.salaryStructure
  });
};
```

---

### **Dashboard Module**

#### **Dashboard Routes** (`routes/dashboard.routes.js`)
```javascript
router.get("/overview", controller.getOverview);  // Get company stats
```

#### **Dashboard Service** (`services/dashboard.service.js`)

```javascript
export const getOverview = async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  // Get all active employees
  const activeEmployees = await Employee.find({
    status: { $in: ["ACTIVE", "INACTIVE"] }
  }).select("_id");

  const activeEmployeeIds = new Set(
    activeEmployees.map(e => e._id.toString())
  );

  const totalActive = activeEmployeeIds.size;

  // Get today's attendance records
  const todayAttendance = await Attendance.find({
    date: { $gte: today, $lt: tomorrow }
  }).select("employeeId status");

  // Filter to only active employees
  const activeAttendance = todayAttendance.filter(a =>
    activeEmployeeIds.has(a.employeeId.toString())
  );

  // Count statuses
  let presentToday = 0;
  let onLeave = 0;
  const markedIds = new Set();

  activeAttendance.forEach(record => {
    markedIds.add(record.employeeId.toString());

    if (["PRESENT", "HALF_DAY"].includes(record.status)) {
      presentToday++;
    } else if (["ABSENT", "LEAVE"].includes(record.status)) {
      onLeave++;
    }
  });

  // Get pending leave requests
  const pendingLeaves = await Leave.countDocuments({ status: "PENDING" });
  const totalEmployees = await Employee.countDocuments();

  return {
    totalEmployees,   // Total in database
    presentToday,     // Present/Half-day today
    onLeave,          // Absent + Leave today
    pendingLeaves     // Awaiting approval
  };
};
```

**Dashboard Response Example:**
```json
{
  "totalEmployees": 50,
  "presentToday": 45,
  "onLeave": 3,
  "pendingLeaves": 7
}
```

---

## 🔌 API Endpoints Summary

### **Authentication**
```
POST   /api/auth/register    - Create account
POST   /api/auth/login       - Login
GET    /api/auth/me          - Get current user
```

### **Employees**
```
GET    /api/employees        - Get all employees
POST   /api/employees        - Add new employee (ADMIN/HR)
GET    /api/employees/:id    - Get employee details
PUT    /api/employees/:id    - Update employee (ADMIN/HR)
```

### **Attendance**
```
POST   /api/attendance/mark          - Mark attendance
POST   /api/attendance/check-in      - Quick check-in
GET    /api/attendance/daily         - Get daily attendance (ADMIN/HR)
GET    /api/attendance/:employeeId   - Get employee's attendance history
```

### **Leaves**
```
POST   /api/leaves                        - Request leave
GET    /api/leaves                        - Get all leaves (ADMIN/HR)
GET    /api/leaves/employee/:employeeId  - Get employee's leaves
PUT    /api/leaves/:id                    - Approve/Reject (ADMIN/HR)
```

### **Payroll**
```
POST   /api/payroll/generate              - Generate payroll (ADMIN/HR)
POST   /api/payroll/salary/:employeeId    - Update salary (ADMIN/HR)
GET    /api/payroll/history               - Get all payroll (ADMIN/HR)
GET    /api/payroll/:employeeId           - Get employee payroll
```

### **Dashboard**
```
GET    /api/dashboard/overview     - Get company stats
```

---

## 🚀 Quick Start Guide

### **1. Setup Environment**

```bash
# Install dependencies
npm install

# Create .env file
PORT=8080
MONGO_URI=mongodb://localhost:27017/hr
JWT_SECRET=hr_app_super_secret_jwt_key_2026
```

### **2. Start Server**

```bash
# Development (auto-reload)
npm run dev

# Production
npm start
```

**Expected Output:**
```
Server running on port 8080
MongoDB Connected
Initializing Attendance Cron Job (Runs daily at 00:00)
```

### **3. Test an API**

```bash
# Register
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@company.com",
    "password": "password123",
    "department": "Engineering"
  }'

# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@company.com",
    "password": "password123"
  }'

# Get current user (use token from login)
curl -X GET http://localhost:8080/api/auth/me \
  -H "Authorization: Bearer <TOKEN_FROM_LOGIN>"
```

---

## 🎓 Key Learnings Summary

### **What You Learned:**

1. **Architecture** - Routes → Controllers → Services → Models
2. **Authentication** - JWT tokens and role-based access
3. **Middlewares** - Security gates for requests
4. **Models** - Database schemas for 6 entities
5. **Business Logic** - Payroll calculation, attendance tracking
6. **Scheduled Jobs** - Automated daily tasks
7. **Error Handling** - Proper error responses
8. **Security** - Password hashing, JWT verification

### **Best Practices Used:**

✅ Separation of concerns (Routes, Controllers, Services)
✅ Middleware for authentication and error handling
✅ Validation at model level
✅ Constants for reusable values
✅ Proper HTTP status codes
✅ Role-based access control
✅ Secure password hashing
✅ Environment variables for configuration

### **Next Steps:**

1. **Understand the Code** - Read through each file
2. **Run Locally** - Set up MongoDB and test APIs
3. **Experiment** - Modify endpoints and see what happens
4. **Connect Frontend** - Use Flutter app to call these APIs
5. **Deploy** - Deploy to cloud (AWS, Azure, Railway, etc.)

---

## ❓ Common Questions

**Q: What is MongoDB?**
A: It's a database that stores data in JSON format. Unlike traditional SQL databases, it's flexible and easy to use.

**Q: What is JWT?**
A: It's a token that proves you're logged in. Frontend stores it and sends it with every request so the server knows who you are.

**Q: What if I forget to send JWT token?**
A: The server will reject your request with "Unauthorized - No token provided"

**Q: Can employees see other employees' salaries?**
A: No. The controller checks `req.user.role` and enforces that employees can only see their own data.

**Q: When does payroll run?**
A: When HR manually calls `/api/payroll/generate` for a specific month/year.

**Q: When does attendance reset run?**
A: Automatically every day at midnight (00:00) via node-cron job.

**Q: What happens if an employee is on leave?**
A: Their attendance is marked as "LEAVE" automatically. Payroll doesn't deduct salary for approved leaves.

---

## 📞 Need Help?

- Check the **constants.js** for all possible values
- Look at the **Models** to understand data structure
- Read the **Services** to understand business logic
- Debug by adding `console.log()` in controllers/services

**Happy Learning! 🎉**
