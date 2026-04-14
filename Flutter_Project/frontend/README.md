# HR Management System - Flutter Frontend

A beautiful, beginner-friendly Flutter mobile app for managing HR operations. This app connects to the Node.js backend API to manage employees, attendance, leaves, and payroll.

## 📱 Features

### ✅ Dashboard
- View total employees count
- See today's present employees
- Quick action buttons

### 👥 Employee Management
- View all employees in a beautiful list
- Add new employees with a simple form
- See employee details (name, designation, department, salary)

### 📅 Attendance
- Mark daily attendance for all employees
- Options: Present, Absent, Half Day
- User-friendly interface

### 🏖️ Leave Management
- View all leave requests
- Approve or reject pending leaves
- See leave details (dates, type, reason, status)

### 💰 Payroll
- Generate monthly payroll for employees
- View payroll history
- See working days, present days, and calculated salary

## 🚀 Getting Started

### Prerequisites
1. **Flutter installed** on your computer
2. **Backend server** running on http://localhost:5001

### Steps to Run

1. **Make sure backend is running first**
   ```bash
   cd Hr
   npm start
   ```

2. **Open a new terminal and navigate to frontend**
   ```bash
   cd frontend
   ```

3. **Get Flutter packages**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Testing on Different Devices

### Android Emulator / iOS Simulator
- Just run `flutter run` - it works with localhost

### Physical Phone
1. Connect your phone to the same WiFi as your computer
2. Find your computer's IP address:
   - **Mac/Linux**: Run `ifconfig | grep inet` in terminal
   - **Windows**: Run `ipconfig` in command prompt
3. Open `lib/services/api_service.dart`
4. Change `baseUrl` from `http://localhost:5001/api` to `http://YOUR_IP:5001/api`
   - Example: `http://192.168.1.100:5001/api`

## 📁 Project Structure

```
frontend/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── services/
│   │   └── api_service.dart         # Backend API calls
│   └── screens/
│       ├── home_screen.dart         # Bottom navigation
│       ├── dashboard_screen.dart    # Dashboard with stats
│       ├── employees_screen.dart    # Employee list
│       ├── add_employee_screen.dart # Add employee form
│       ├── attendance_screen.dart   # Mark attendance
│       ├── leaves_screen.dart       # Leave management
│       └── payroll_screen.dart      # Payroll generation
```

## 🎨 Design Features

- **Beautiful Material Design** with professional colors
- **Smooth animations** and transitions
- **Loading states** with progress indicators
- **Error handling** with retry buttons
- **Pull to refresh** on all lists
- **Responsive cards** with icons and colors

## 🔧 How It Works (For Beginners)

### 1. API Service (`api_service.dart`)
This file handles all communication with the backend. It has simple functions like:
- `getEmployees()` - Get all employees
- `addEmployee()` - Add a new employee
- `markAttendance()` - Mark attendance
- etc.

### 2. Screens
Each screen is a separate Dart file:
- **StatefulWidget**: Used when the screen needs to change (like loading data)
- **setState()**: Updates the UI when data changes
- **FutureBuilder/async-await**: Loads data from the backend

### 3. Navigation
The `home_screen.dart` uses a `BottomNavigationBar` to switch between screens.

## 🐛 Common Issues

### "Failed to load" errors
✅ **Solution**: Make sure your backend server is running on port 5001

### Connection refused
✅ **Solution**: Check the IP address in `api_service.dart` matches your computer's IP

### Build errors
✅ **Solution**: Run `flutter pub get` again

## 💡 Tips for Learning

1. **Start with `main.dart`** - See how the app starts
2. **Check `home_screen.dart`** - Understand navigation
3. **Read `dashboard_screen.dart`** - Learn how to load and display data
4. **Explore other screens** - See similar patterns repeated

All code has clear comments explaining what each part does!

## 📚 Next Steps

- Add user authentication
- Add employee profile pages
- Add charts for analytics
- Add notifications
- Export payroll reports

---

**Made with ❤️ for Flutter beginners**

Need help? All the code has comments explaining each part!
