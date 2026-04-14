<div align="center">

<!-- Banner -->
<img src="Frontend/assets/Flutter_Logo.png" alt="SpendWise Logo" width="120" />

# 💸 SpendWise

### *Your money. Your rules. Your insights.*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Node.js](https://img.shields.io/badge/Node.js-Express-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![JWT](https://img.shields.io/badge/Auth-JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)](https://jwt.io)
[![License](https://img.shields.io/badge/License-MIT-purple?style=for-the-badge)](LICENSE)

<br/>

> **SpendWise** is a full-stack personal finance app built with Flutter & Node.js.  
> Track expenses, visualise spending habits, generate PDF bills, and export data — all in one beautiful app.

<br/>

---

</div>

## ✨ Features

| 🟢 Feature | Description |
|---|---|
| 🔐 **Secure Auth** | JWT-based signup & login with bcrypt password hashing |
| 📊 **Analytics Dashboard** | Interactive charts powered by `fl_chart` |
| 💳 **Expense & Income Tracking** | Log transactions with title, amount, category, date & notes |
| 🗂️ **Category Breakdown** | Visualise spending per category at a glance |
| 🧾 **PDF Bill Generator** | Export a styled PDF receipt / bill instantly |
| 📤 **JSON Data Export** | Share your transaction data as a JSON file |
| 🌗 **Clean Material UI** | Google Fonts + smooth `flutter_animate` animations |
| 💾 **Persistent Session** | Login state saved with `shared_preferences` |

---

## 🏗️ Tech Stack

<div align="center">

```
┌─────────────────────────────────────────────────────┐
│                   📱  FRONTEND                       │
│         Flutter · Dart · Provider · fl_chart         │
│         google_fonts · flutter_animate · pdf          │
└─────────────────────┬───────────────────────────────┘
                      │  HTTP REST API
┌─────────────────────▼───────────────────────────────┐
│                   🖥️  BACKEND                        │
│          Node.js · Express · JWT · bcryptjs           │
└─────────────────────┬───────────────────────────────┘
                      │  Supabase Client
┌─────────────────────▼───────────────────────────────┐
│                   🗄️  DATABASE                       │
│          Supabase (PostgreSQL) · RPC Functions        │
└─────────────────────────────────────────────────────┘
```

</div>

---

## 📁 Project Structure

```
SpendWise/
├── 🖥️  Backend/
│   ├── server.js              # Express entry point
│   ├── db.js                  # Supabase client
│   ├── schema.sql             # PostgreSQL schema + RPC functions
│   ├── middleware/
│   │   └── auth.js            # JWT verification middleware
│   └── routes/
│       ├── auth.js            # /api/auth  — signup, login
│       └── expenses.js        # /api/expenses — CRUD + analytics
│
└── 📱  Frontend/
    └── lib/
        ├── main.dart
        ├── core/              # Theme, config, constants
        ├── models/            # Expense model
        ├── providers/         # Auth + Expense state (Provider)
        ├── screens/           # All app screens
        │   ├── splash_screen.dart
        │   ├── login_screen.dart
        │   ├── signup_screen.dart
        │   ├── home_screen.dart
        │   ├── dashboard_screen.dart
        │   ├── transactions_screen.dart
        │   ├── analytics_screen.dart
        │   ├── add_expense_screen.dart
        │   ├── export_screen.dart
        │   └── settings_screen.dart
        ├── services/          # Auth service, PDF bill service
        └── widgets/           # Reusable UI components
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.x`
- [Node.js](https://nodejs.org) `v18+`
- A [Supabase](https://supabase.com) project (free tier works)

---

### 🗄️ 1 — Database Setup

1. Create a new project on [Supabase](https://supabase.com).
2. Open the **SQL Editor** in your Supabase dashboard.
3. Paste the contents of `Backend/schema.sql` and click **Run**.

---

### 🖥️ 2 — Backend Setup

```bash
cd Backend
npm install
```

Create a `.env` file in `Backend/`:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-service-role-key
JWT_SECRET=your-super-secret-key
PORT=3000
```

Start the server:

```bash
# Development (with hot-reload)
npm run dev

# Production
npm start
```

The API will be live at `http://localhost:3000` 🚀

---

### 📱 3 — Flutter App Setup

```bash
cd Frontend
flutter pub get
```

Update the base URL in `lib/core/config.dart` to point to your running backend:

```dart
// For local development
static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android emulator
// static const String baseUrl = 'http://localhost:3000/api'; // iOS simulator / Web
```

Run the app:

```bash
flutter run
```

---

## 📡 API Reference

### Auth  `/api/auth`

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/signup` | Register a new user |
| `POST` | `/login` | Login & receive JWT token |

### Expenses  `/api/expenses` *(🔒 JWT required)*

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Get all expenses for the logged-in user |
| `POST` | `/` | Add a new expense / income |
| `PUT` | `/:id` | Update an existing record |
| `DELETE` | `/:id` | Delete a record |
| `GET` | `/analytics/total` | Get total income / expense |
| `GET` | `/analytics/categories` | Get per-category breakdown |

---

## 📊 Database Schema

```sql
users
  ├── id            BIGSERIAL  PK
  ├── name          VARCHAR(100)
  ├── email         VARCHAR(255)  UNIQUE
  ├── password_hash VARCHAR(255)
  └── created_at    TIMESTAMPTZ

expenses
  ├── id         BIGSERIAL  PK
  ├── user_id    BIGINT  →  users(id)
  ├── title      VARCHAR(255)
  ├── amount     FLOAT
  ├── category   VARCHAR(100)
  ├── date       VARCHAR(30)
  ├── type       VARCHAR(10)  CHECK ('expense' | 'income')
  ├── notes      TEXT
  └── created_at TIMESTAMPTZ
```

---

## 🎨 Screenshots

> *Add your app screenshots here!*

| Splash | Login | Dashboard | Analytics |
|:---:|:---:|:---:|:---:|
| `splash_screen` | `login_screen` | `dashboard_screen` | `analytics_screen` |

---

## 🛡️ Security

- Passwords are hashed with **bcryptjs** before storage — plain-text passwords are never stored.
- All expense routes are protected by a **JWT middleware** that validates the `Authorization: Bearer <token>` header.
- CORS is configured on the Express server.

---

## 🤝 Contributing

Contributions are welcome! 🎉

```bash
# 1. Fork the repo
# 2. Create your feature branch
git checkout -b feature/amazing-feature

# 3. Commit your changes
git commit -m "feat: add amazing feature"

# 4. Push to the branch
git push origin feature/amazing-feature

# 5. Open a Pull Request
```

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

<div align="center">

Made with ❤️ and ☕ using Flutter & Node.js

⭐ **Star this repo if you found it helpful!** ⭐

</div>
