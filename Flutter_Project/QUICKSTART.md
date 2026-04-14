# 🚀 Quick Start Guide - HR Management System

## ⚡ Fast Setup (3 Steps)

### Step 1: Start the Backend
```bash
cd Hr
npm start
```
✅ You should see: `Server running on port 5001`

### Step 2: Run the Flutter App
Open a **NEW terminal** window:
```bash
cd frontend
flutter run
```
✅ Select your device (emulator/simulator/phone)

### Step 3: Use the App! 🎉
The app will open automatically on your device.

---

## 📱 What You'll See

### Bottom Navigation (5 Tabs)
1. **Dashboard** 📊 - Overview and quick stats
2. **Employees** 👥 - View and add employees
3. **Attendance** 📅 - Mark daily attendance
4. **Leaves** 🏖️ - Manage leave requests
5. **Payroll** 💰 - Generate and view payrolls

---

## 🎯 Try These Features First

### 1. Add Your First Employee
- Tap **Employees** tab
- Tap the **+** button at top right
- Fill the form with employee details
- Tap **Add Employee**

### 2. Mark Attendance
- Tap **Attendance** tab
- You'll see all employees
- Tap **Present**, **Absent**, or **Half Day** for each employee

### 3. Generate Payroll
- Tap **Payroll** tab
- Tap **Generate** for any employee
- Tap **History** to see all payroll records

---

## 🐛 Troubleshooting

### "Failed to load employees"
❌ **Problem**: Backend is not running
✅ **Solution**: Start the backend server first (Step 1 above)

### App won't run
❌ **Problem**: Dependencies not installed
✅ **Solution**: Run `flutter pub get` in the frontend folder

### Testing on physical phone
❌ **Problem**: Can't connect to localhost
✅ **Solution**: 
1. Find your computer's IP: `ifconfig | grep inet` (Mac/Linux)
2. Edit `frontend/lib/services/api_service.dart`
3. Change line 10 from `http://localhost:5001/api` to `http://YOUR_IP:5001/api`

---

## 📚 For Beginners: Understanding the Code

### Start Here (in order)
1. `lib/main.dart` - App entry point (14 lines of code only!)
2. `lib/screens/home_screen.dart` - Navigation setup
3. `lib/screens/dashboard_screen.dart` - Your first full screen
4. `lib/services/api_service.dart` - Backend communication

### Key Concepts
- **StatefulWidget** = Screen that can change
- **setState()** = Update the screen
- **async/await** = Wait for backend response
- **Future** = Something that will happen later (like API call)

### Every Screen Follows This Pattern
```dart
1. Load data from backend (initState)
2. Show loading spinner while waiting
3. Display data in beautiful cards
4. Handle errors with retry button
```

---

## 💡 Next Development Ideas

- [ ] Add search for employees
- [ ] Add filters for leaves
- [ ] Add charts/graphs
- [ ] Add employee photos
- [ ] Add push notifications
- [ ] Dark mode toggle
- [ ] Export reports to PDF

---

## 🎓 Learning Resources

- **Flutter Docs**: https://docs.flutter.dev
- **Dart Language**: https://dart.dev/guides
- **Material Design**: https://material.io

---

**Need Help?** Read the comments in the code - every part is explained! 📝
