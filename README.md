<div align="center">

# 🦋 Flutter Projects Collection

### by [Chaitanya Dalvi](https://github.com/ChaitanyDalvi06)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Node.js](https://img.shields.io/badge/Node.js-Express-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

*A curated collection of Flutter applications built while learning cross-platform mobile development* 🚀

</div>

---

## 📖 Overview

This repository is a **learning portfolio** of Flutter projects ranging from simple UI exercises to full-stack mobile applications with Node.js/Express backends. Each project demonstrates a different concept in Flutter — from basic widgets and state management to REST API integration, JWT authentication, and local storage.

> 💡 Whether you're new to Flutter or looking for real-world mini-project examples, this repo has something for you!

---

## 📂 Repository Structure

```
flutter/
├── 📱 counter_app/                   # Classic counter app (Flutter starter)
├── 🎨 product_list/                  # Product list with local image assets
├── 👤 profileui/                     # Profile UI screen design
├── 🌸 Flowers_App/                   # Flowers catalog app (frontend + backend)
│   ├── frontend/                     # Flutter app (image_picker, file_picker)
│   └── backend/                      # Node.js / Express REST API
├── 💾 flower_app_with_local_storage/ # Flowers app with offline local storage
│   ├── frontend/
│   └── backend/
├── 🔐 MyAuth/                        # Authentication app (JWT login/register)
│   ├── Frontend/auth_app/            # Flutter app
│   └── backend/auth_apis/            # Node.js auth API
├── 👔 employee/                      # Employee CRUD application
│   ├── employee_crud_app/            # Flutter app
│   └── employee-apis/                # Node.js REST API
├── 📚 lms/                           # Library Management System
│   ├── frontend/                     # Flutter app (student + librarian views)
│   └── backend/                      # Node.js backend with MongoDB
├── 🏢 Flutter_Project/               # Enterprise HR Management System
│   ├── frontend/                     # Flutter app (dashboard, payroll, leaves)
│   └── Hr/                           # Node.js backend
├── 🏛️ Mini project/                  # HR Application mini project
│   └── hr-application-main/          # Full-stack HR application
├── 📝 Assignments/                   # Flutter lab assignments
│   ├── Assignment/
│   ├── Assignment2/
│   └── Assignments1/
└── 🎓 Flutter Exam/                  # Flutter exam submissions
```

---

## ✨ Projects at a Glance

| 📦 Project | 🔑 Key Features | 🛠️ Tech |
|---|---|---|
| **counter_app** | Increment / Decrement counter | Flutter, StatefulWidget |
| **product_list** | Product cards with local image assets | Flutter, Assets |
| **profileui** | Polished profile UI screen | Flutter, Material UI |
| **Flowers_App** | Browse flowers, image upload, API integration | Flutter, Node.js, HTTP |
| **flower_app_with_local_storage** | Flowers catalog with offline persistence | Flutter, shared_preferences |
| **MyAuth** | User registration, login, JWT sessions | Flutter, Node.js, JWT |
| **employee** | Full CRUD for employee records | Flutter, Node.js, REST API |
| **lms** | Library management (student & librarian roles) | Flutter, Node.js, JWT, MongoDB |
| **Flutter_Project** | HR dashboard, attendance, payroll, leaves | Flutter, Node.js |
| **Mini project** | Comprehensive HR application | Flutter, Node.js |
| **Assignments** | Various Flutter widget/layout exercises | Flutter |

---

## 🌟 Featured Project: HR Management System

The **`Flutter_Project/`** folder contains a full-stack **Enterprise HR Management & Payroll System** — the most feature-rich project in this repo.

### 📊 Capabilities
- 👥 **Employees** — View, add, and manage employee records
- 📅 **Attendance** — Mark Present / Absent / Half Day per employee
- 🏖️ **Leaves** — Submit and manage leave requests
- 💰 **Payroll** — Auto-generate salary payslips and view history
- 📊 **Dashboard** — Quick stats and system overview

### 🚀 Quick Start (HR System)
```bash
# 1️⃣  Start the backend
cd Flutter_Project/Hr
npm install && npm start
# ✅ Server running on port 5001

# 2️⃣  Run the Flutter app
cd Flutter_Project/frontend
flutter pub get
flutter run
```

---

## 🔐 Featured Project: Authentication App (MyAuth)

A JWT-based authentication system with Flutter frontend and Node.js backend.

### 🔑 Features
- 📝 User registration
- 🔓 Login with JWT token
- 🔒 Protected routes using `shared_preferences` for token storage
- 🚪 Logout and session management

---

## 📚 Featured Project: Library Management System (LMS)

Role-based Library Management System with **Librarian** and **Student** views.

### 📖 Features
- 🎓 Student portal — browse and request books
- 📚 Librarian portal — manage book catalog and issue records
- 🔐 JWT-based authentication
- 🌐 REST API backend built with Node.js + Express

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| 📱 **Mobile Frontend** | Flutter 3.x · Dart 3.x |
| 🎨 **UI** | Material Design · Cupertino Icons |
| 🌐 **Backend** | Node.js · Express.js |
| 🔐 **Auth** | JWT (json web tokens) · `jwt_decode` |
| 💾 **Local Storage** | `shared_preferences` |
| 🌍 **HTTP Client** | `http` package |
| 🖼️ **Media** | `image_picker` · `file_picker` · `path_provider` |

---

## 🚀 Getting Started

### ✅ Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.x or later)
- [Dart SDK](https://dart.dev/get-dart) (bundled with Flutter)
- [Node.js](https://nodejs.org/) (v16+ for backend projects)
- An emulator, simulator, or physical device

Verify your Flutter setup:
```bash
flutter doctor
```

### 📥 Installation

```bash
# Clone the repository
git clone https://github.com/ChaitanyDalvi06/flutter.git
cd flutter
```

### ▶️ Running a Flutter App

Navigate to any Flutter project's folder and run:

```bash
# Example: run the LMS frontend
cd lms/frontend
flutter pub get     # install dependencies
flutter run         # launch on connected device / emulator
```

### ⚙️ Running a Node.js Backend

For projects with a backend (e.g., `lms`, `Flowers_App`, `MyAuth`, `employee`):

```bash
# Example: start the LMS backend
cd lms/backend
npm install         # install dependencies
npm start           # start Express server
```

> 🔧 **Tip:** If testing on a physical device, replace `localhost` with your machine's local IP address in the Flutter app's API service file.

---

## 🎨 Screenshots / Demo

> 📸 _Screenshots and demo GIFs will be added here. Run any project locally to see it in action!_

| Counter App | Product List | Profile UI |
|:-----------:|:------------:|:----------:|
| _(coming soon)_ | _(coming soon)_ | _(coming soon)_ |

| Flowers App | LMS | HR System |
|:-----------:|:---:|:---------:|
| _(coming soon)_ | _(coming soon)_ | _(coming soon)_ |

---

## 🤝 Contributing

Contributions, issues and feature requests are welcome! 🎉

1. 🍴 **Fork** the repository
2. 🌿 **Create** your feature branch  
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. 💾 **Commit** your changes  
   ```bash
   git commit -m "✨ Add amazing feature"
   ```
4. 📤 **Push** to the branch  
   ```bash
   git push origin feature/amazing-feature
   ```
5. 🔃 **Open a Pull Request**

Please make sure your code follows Flutter/Dart best practices and is well-documented.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 📬 Contact

**Chaitanya Dalvi**

[![GitHub](https://img.shields.io/badge/GitHub-Chaitanya_Dalvi-181717?logo=github)](https://github.com/ChaitanyDalvi06)

---

<div align="center">

Made with ❤️ and ☕ using **Flutter** & **Dart**

⭐ _If you found this helpful, consider giving the repo a star!_ ⭐

</div>
