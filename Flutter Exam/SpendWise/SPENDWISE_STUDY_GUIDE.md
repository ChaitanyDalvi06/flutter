# 📱 SpendWise — Complete Study Guide
### Everything You Need To Know: Flutter, Dart, Node.js, MySQL & Your Full Project

> **How to use this guide:** Read it top to bottom. Every concept is explained from scratch — no prior Flutter knowledge needed. Diagrams show you how the app looks and how data flows. The last section has common exam questions with answers.

---

# TABLE OF CONTENTS

1. [What is SpendWise?](#1-what-is-spendwise)
2. [Tech Stack — The Big Picture](#2-tech-stack--the-big-picture)
3. [Dart Language Basics](#3-dart-language-basics)
4. [Flutter Basics — Start Here](#4-flutter-basics--start-here)
5. [Flutter Widgets Deep Dive](#5-flutter-widgets-deep-dive)
6. [State Management with Provider](#6-state-management-with-provider)
7. [Navigation in Flutter](#7-navigation-in-flutter)
8. [HTTP Networking in Flutter](#8-http-networking-in-flutter)
9. [Backend: Node.js + Express](#9-backend-nodejs--express)
10. [Database: MySQL](#10-database-mysql)
11. [Authentication: JWT + bcrypt](#11-authentication-jwt--bcrypt)
12. [Project File-by-File Explained](#12-project-file-by-file-explained)
13. [App Screens — Visual Tour](#13-app-screens--visual-tour)
14. [Data Flow Diagrams](#14-data-flow-diagrams)
15. [Flutter Packages Used](#15-flutter-packages-used)
16. [Common Exam Questions & Answers](#16-common-exam-questions--answers)

---

# 1. What is SpendWise?

**SpendWise** is a personal finance management mobile app — like a digital pocket diary for your money. You can:

- ✅ **Track Expenses** — Record what you spend (food, travel, bills, etc.)
- ✅ **Track Income** — Record money you earn (salary, freelance, investment)
- ✅ **See Analytics** — Charts showing spending trends, category breakdowns
- ✅ **Export Reports** — Download PDF bill reports of your transactions
- ✅ **Login/Signup** — Personal accounts so your data is private

---

```
╔══════════════════════════════════════════════════════════╗
║                   SPENDWISE APP OVERVIEW                  ║
╠══════════════════════════════════════════════════════════╣
║                                                            ║
║   📱 Flutter App (Frontend)                               ║
║   ┌────────────────────────────────────────────────────┐  ║
║   │  Splash → Login/Signup → Dashboard                 │  ║
║   │         ↓                                          │  ║
║   │  Home (Bottom Nav Bar with 4 tabs):               │  ║
║   │  [🏠 Dashboard] [📊 Analytics] [💳 Wallet] [👤 Me] │  ║
║   │         ↓                                          │  ║
║   │  + FAB Button → Add/Edit Expense                  │  ║
║   └──────────────────────┬─────────────────────────────┘  ║
║                           │ HTTP Requests                   ║
║                           ▼                                 ║
║   🖥️ Node.js Backend (server.js)                          ║
║   ┌────────────────────────────────────────────────────┐  ║
║   │  Express Server at http://localhost:3000           │  ║
║   │  /api/auth/register  POST                         │  ║
║   │  /api/auth/login     POST                         │  ║
║   │  /api/expenses       GET, POST, PUT, DELETE       │  ║
║   └──────────────────────┬─────────────────────────────┘  ║
║                           │ SQL Queries                     ║
║                           ▼                                 ║
║   🗄️ MySQL Database                                        ║
║   ┌────────────────────────────────────────────────────┐  ║
║   │  Database: spendwise                               │  ║
║   │  Tables: users, expenses                          │  ║
║   └────────────────────────────────────────────────────┘  ║
╚══════════════════════════════════════════════════════════╝
```

---

# 2. Tech Stack — The Big Picture

Think of your project like a restaurant:
- **Flutter (Frontend)** = The dining area — what customers (users) see and interact with
- **Node.js + Express (Backend)** = The kitchen — processes orders (requests), applies business logic
- **MySQL (Database)** = The pantry — stores all the data permanently

```
┌─────────────────────────────────────────────────────────────────┐
│                    TECH STACK MAP                                │
├───────────────────┬─────────────────────┬───────────────────────┤
│   FRONTEND        │    BACKEND          │    DATABASE           │
│   (Flutter/Dart)  │  (Node.js/Express)  │    (MySQL)            │
├───────────────────┼─────────────────────┼───────────────────────┤
│ • Flutter 3.x     │ • Node.js (JS)      │ • MySQL 8.x           │
│ • Dart Language   │ • Express.js        │ • Tables: users,      │
│ • provider pkg    │ • bcryptjs          │   expenses            │
│ • fl_chart pkg    │ • jsonwebtoken      │ • InnoDB Engine       │
│ • http pkg        │ • mysql2 pkg        │ • utf8mb4 charset     │
│ • pdf pkg         │ • dotenv pkg        │                       │
│ • google_fonts    │ • cors pkg          │                       │
│ • flutter_animate │ • nodemon (dev)     │                       │
│ • shared_prefs    │                     │                       │
│ • printing pkg    │                     │                       │
│ • share_plus pkg  │                     │                       │
└───────────────────┴─────────────────────┴───────────────────────┘
         ↕ HTTP/REST API              ↕ SQL
    (JSON over network)         (queries)
```

---

# 3. Dart Language Basics

Flutter apps are written in **Dart** — a programming language made by Google. If you know any programming language, Dart will feel familiar.

## 3.1 Variables & Types

```dart
// Typed variables
int age = 20;
double price = 99.99;
String name = "SpendWise";
bool isLoggedIn = true;

// var — Dart figures out the type automatically
var city = "Mumbai";       // Dart knows this is String
var amount = 500.0;        // Dart knows this is double

// final — can only be set ONCE (like declaring a constant after runtime)
final DateTime now = DateTime.now();

// const — compile-time constant (known before app runs)
const String appName = "SpendWise";

// Nullable types — can hold null value (uses ?)
String? token;             // token can be null
int? userId;               // userId can be null
```

## 3.2 Functions

```dart
// Basic function
void sayHello() {
  print("Hello!");
}

// Function with return type and parameters
double addNumbers(double a, double b) {
  return a + b;
}

// Arrow function (one-liner)
double multiply(double a, double b) => a * b;

// Named parameters (very common in Flutter widgets)
void createUser({required String name, String? email}) {
  // required = must pass this, ? = optional
}

// Calling with named params:
createUser(name: "Chaitanya", email: "chai@example.com");
```

## 3.3 Classes & Objects

```dart
// A class is a blueprint
class Expense {
  final int? id;           // field
  final String title;      // field
  final double amount;     // field

  // Constructor
  const Expense({
    this.id,
    required this.title,
    required this.amount,
  });

  // Method
  bool get isExpensive => amount > 1000;

  // Convert to Map (for JSON/database)
  Map<String, dynamic> toMap() => {
    'title': title,
    'amount': amount,
  };
}

// Creating an object:
final myExpense = Expense(title: "Coffee", amount: 50.0);
print(myExpense.isExpensive);   // → false (50 < 1000)
```

## 3.4 Async / Await (Very Important in Flutter!)

In Flutter, many operations take time (fetching data from internet, reading files). Dart uses `async/await` to handle this without freezing the app.

```dart
// Think of async as: "this function might take time"
// Think of await as: "wait here until this finishes"

Future<String> fetchUserName() async {
  // Simulates a 2-second network call
  await Future.delayed(Duration(seconds: 2));
  return "Chaitanya";
}

// HOW TO USE:
void main() async {
  print("Fetching...");
  String name = await fetchUserName();  // waits 2 seconds
  print("Got: $name");                  // then prints
}
```

**In your project** — every API call uses async/await:
```dart
// From database_helper.dart
static Future<List<Expense>> getAll() async {
  final response = await http.get(_uri(''));  // WAIT for server response
  // ... process response
}
```

## 3.5 Lists & Maps

```dart
// List — like an array
List<String> categories = ["Food", "Travel", "Shopping"];
categories.add("Entertainment");           // add item
categories.remove("Travel");              // remove item
int count = categories.length;            // get length

// Map — key-value pairs (like a dictionary)
Map<String, double> monthlyTotals = {
  "January": 5000.0,
  "February": 3500.0,
};
monthlyTotals["March"] = 4200.0;          // add/update
double? jan = monthlyTotals["January"];   // read

// Common operations
List<String> filtered = categories
    .where((c) => c.contains("F"))        // filter
    .toList();                            // → ["Food"]

List<String> upper = categories
    .map((c) => c.toUpperCase())          // transform
    .toList();                            // → ["FOOD", "SHOPPING", ...]
```

---

# 4. Flutter Basics — Start Here

## 4.1 What is Flutter?

**Flutter** is Google's framework for building beautiful apps for mobile (Android + iOS), web, and desktop — all from a SINGLE codebase written in Dart.

```
┌──────────────────────────────────────────────────┐
│                 FLUTTER = 1 CODE                  │
│                         │                         │
│    ┌──────────┬──────────┼──────────┬──────────┐  │
│    │          │          │          │          │  │
│  Android    iOS        Web       macOS      Windows│
│  (APK)     (IPA)    (Browser)              (EXE) │
└──────────────────────────────────────────────────┘
```

## 4.2 Everything is a Widget!

**The most important Flutter concept:** In Flutter, literally EVERYTHING you see on screen is a **Widget**.

- A button → Widget
- A text label → Widget
- An image → Widget
- A color → Widget
- Padding around something → Widget
- The entire screen → Widget
- Even the whole App → Widget

```
┌──────────────────────────────────────────────────┐
│              WIDGET TREE EXAMPLE                   │
│                                                    │
│  MaterialApp                                       │
│  └── Scaffold                                      │
│      ├── AppBar                                    │
│      │   └── Text("Dashboard")                    │
│      └── Column                                    │
│          ├── Text("Balance: ₹5000")               │
│          ├── SizedBox(height: 20)                  │
│          └── Row                                   │
│              ├── Text("Income")                   │
│              └── Text("Expense")                  │
└──────────────────────────────────────────────────┘

Every indented item above is a Widget!
```

## 4.3 StatelessWidget vs StatefulWidget

This is a core concept you MUST know:

### StatelessWidget — No changing data
```dart
// Use when the widget NEVER changes after it's built
// Example: A label, an icon, a static card

class WelcomeText extends StatelessWidget {
  final String name;

  const WelcomeText({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text("Welcome, $name!");  // always shows the same thing
  }
}
```

### StatefulWidget — Has changing data
```dart
// Use when the widget CAN CHANGE (user clicks, types, data loads)
// Example: A toggle button, a form, a loading spinner

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;   // this can change!
  bool _obscure = true;    // this can change!

  void _togglePassword() {
    setState(() {            // ← setState tells Flutter to REDRAW
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_loading ? "Loading..." : "Sign In");
  }
}
```

**Real analogy:**
- `StatelessWidget` = A printed photo (never changes)
- `StatefulWidget` = A digital display (can update)

## 4.4 The build() Method

Every widget has a `build()` method that returns the UI. Flutter calls this method whenever it needs to draw (or redraw) the widget.

```dart
@override
Widget build(BuildContext context) {
  // context = information about where this widget is in the tree
  // Return value = what Flutter draws on screen
  return Text("Hello World");
}
```

## 4.5 main() and runApp()

Your app starts in `main.dart`:

```dart
void main() async {
  // 1. Initialize Flutter engine before doing anything
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Set up providers (state managers)
  final authProvider = AuthProvider();
  await authProvider.loadFromPrefs();  // Load saved login
  
  // 3. Start the app!
  runApp(
    MultiProvider(
      providers: [...],
      child: const SpendWiseApp(),  // Root widget
    ),
  );
}
```

## 4.6 Scaffold — The Page Layout Widget

`Scaffold` gives you the basic page structure:

```
┌──────────────────────────────────────┐
│  AppBar (top bar with title/actions) │  ← appBar:
├──────────────────────────────────────┤
│                                      │
│  Body (main content area)            │  ← body:
│                                      │
│                                      │
│                                      │
├──────────────────────────────────────┤
│  BottomNavigationBar (tab bar)       │  ← bottomNavigationBar:
└──────────────────────────────────────┘
         [FAB Button floating]           ← floatingActionButton:
```

```dart
Scaffold(
  appBar: AppBar(title: Text("Dashboard")),
  body: Center(child: Text("Hello")),
  bottomNavigationBar: BottomNavigationBar(...),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
)
```

---

# 5. Flutter Widgets Deep Dive

## 5.1 Layout Widgets

### Column — Stack vertically (top to bottom)
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,   // vertical alignment
  crossAxisAlignment: CrossAxisAlignment.start,  // horizontal alignment
  children: [
    Text("Item 1"),
    Text("Item 2"),
    Text("Item 3"),
  ],
)
```
```
┌────────────┐
│  Item 1    │  ← top
│  Item 2    │
│  Item 3    │  ← bottom
└────────────┘
```

### Row — Line up horizontally (left to right)
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text("Income"),
    Text("₹5000"),
  ],
)
```
```
┌─────────────────────────┐
│ Income          ₹5000   │  ← side by side
└─────────────────────────┘
```

### Stack — Layer widgets on top of each other
```dart
Stack(
  children: [
    Image.asset("background.png"),   // bottom layer
    Text("SpendWise"),               // top layer
  ],
)
```
Used in your project for the floating bottom nav bar!

### Container — Box with styling
```dart
Container(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 24),
  decoration: BoxDecoration(
    color: Color(0xFF111111),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Color(0xFF222222)),
  ),
  child: Text("Balance"),
)
```

## 5.2 Scrolling Widgets

### SingleChildScrollView
```dart
SingleChildScrollView(
  padding: EdgeInsets.all(20),
  child: Column(children: [...manyWidgets]),
)
```

### ListView.builder — Efficient list for many items
```dart
ListView.builder(
  itemCount: expenses.length,
  itemBuilder: (context, index) {
    final expense = expenses[index];
    return ListTile(
      title: Text(expense.title),
      trailing: Text("₹${expense.amount}"),
    );
  },
)
```

### CustomScrollView + Slivers (used in Dashboard)
More advanced scrolling — allows mixing fixed widgets and lists. Used in `dashboard_screen.dart`.

## 5.3 Input Widgets

### TextFormField (used in Login/Signup)
```dart
TextFormField(
  controller: _emailCtrl,   // TextEditingController to read the value
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    hintText: "you@example.com",
    prefixIcon: Icon(Icons.email_outlined),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) return "Email required";
    if (!value.contains("@")) return "Invalid email";
    return null;  // null = valid
  },
)
```

### Form + GlobalKey (for validation)
```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(children: [
    TextFormField(validator: ...),
    ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // All fields valid → submit
        }
      },
      child: Text("Submit"),
    ),
  ]),
)
```

## 5.4 Button Widgets

```dart
// Filled background button
ElevatedButton(
  onPressed: () => print("Pressed!"),
  child: Text("Sign In"),
)

// Text-only button
TextButton(
  onPressed: () {},
  child: Text("Forgot Password?"),
)

// Icon + Text button
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.download),
  label: Text("Export PDF"),
)

// Round floating button
FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
)
```

## 5.5 Display Widgets

```dart
// Text
Text(
  "SpendWise",
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
  ),
)

// Image from assets
Image.asset("assets/Flutter_Logo.png", width: 80, height: 80)

// Icon
Icon(Icons.home_rounded, size: 24, color: Colors.green)

// Circular Progress Indicator (loading spinner)
CircularProgressIndicator(color: Colors.green, strokeWidth: 2)
```

## 5.6 Dialog & BottomSheet (used in your app)

### ModalBottomSheet (Add Expense Screen)
```dart
// Opening the Add Expense sheet (in home_screen.dart)
showModalBottomSheet(
  context: context,
  isScrollControlled: true,    // allows full height
  backgroundColor: Colors.transparent,
  builder: (_) => const AddExpenseScreen(),
);

// The sheet snaps up from bottom of screen:
// ┌─────────────────────────────────┐
// │  Main App Content               │
// │                                 │
// ├─────────────────────────────────┤  ← sheet slides up
// │  ─── (handle bar)               │
// │  New Transaction                │
// │  [Expense] [Income]             │
// │  Amount: ₹ 0.00                 │
// │  ...                            │
// └─────────────────────────────────┘
```

## 5.7 Animation Widgets (used in Splash & Analytics)

```dart
// FadeTransition — fade in/out
FadeTransition(
  opacity: _fadeAnimation,   // Animation<double>
  child: Text("SpendWise"),
)

// ScaleTransition — grow/shrink
ScaleTransition(
  scale: _scaleAnimation,
  child: Image.asset("logo.png"),
)

// AnimationController setup (in initState)
_anim = AnimationController(
  vsync: this,      // this widget provides ticks
  duration: const Duration(milliseconds: 900),
);
_fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
_anim.forward();  // start animation
```

### flutter_animate package (easier animations)
```dart
// Just add .animate() to any widget!
Text("Hello").animate().fadeIn(duration: 400.ms)
Row(...).animate().fadeIn(delay: 100.ms)
```

---

# 6. State Management with Provider

## 6.1 What is State Management?

**The Problem:** When data changes (e.g., user adds an expense), how do you update ALL the widgets that show that data?

**Bad Approach:** Pass data manually up and down the widget tree (very messy with many widgets).

**Good Approach:** Use a central "store" of data. Any widget can read from it. When data changes, all listening widgets auto-update.

```
WITHOUT PROVIDER (messy):
App → Screen → Widget → Widget → Widget → Widget
  ↓ passes data all the way down through props

WITH PROVIDER (clean):
          [ExpenseProvider]
               ↑   ↑   ↑
       reads / | \ reads
  Dashboard  Analytics  Transactions
  (auto-updates when provider changes)
```

## 6.2 ChangeNotifier — The Data Store

Your app has two providers:

### AuthProvider (manages login state)
```dart
class AuthProvider extends ChangeNotifier {
  String? _token;       // private data
  String? _userName;
  String? _userEmail;

  // Public getters — reading the data
  bool get isLoggedIn => _token != null;
  String get userName => _userName ?? 'User';

  // Method that CHANGES data → must call notifyListeners()
  Future<void> logout() async {
    _token = null;
    _userName = null;
    _userEmail = null;
    // ... clear SharedPreferences ...
    notifyListeners();   // ← tells all listening widgets to rebuild!
  }
}
```

### ExpenseProvider (manages expense data)
```dart
class ExpenseProvider extends ChangeNotifier {
  List<Expense> _allExpenses = [];
  bool _isLoading = false;
  FilterType _filterType = FilterType.all;
  SortType _sortType = SortType.dateDesc;
  String _searchQuery = '';
  DateTime _selectedMonth = DateTime.now();

  // GETTERS — computed data
  double get monthlyIncome => ...   // sum of income this month
  double get monthlyExpense => ...  // sum of expenses this month
  double get monthlyBalance => monthlyIncome - monthlyExpense;

  // Load all expenses from API
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();                // show loading spinner
    _allExpenses = await DatabaseHelper.getAll();  // fetch from server
    _isLoading = false;
    notifyListeners();                // hide spinner, show data
  }
}
```

## 6.3 Setting Up Provider (in main.dart)

```dart
runApp(
  MultiProvider(
    providers: [
      // AuthProvider already created, just share it
      ChangeNotifierProvider.value(value: authProvider),
      
      // ExpenseProvider — create new + immediately load data
      ChangeNotifierProvider(create: (_) => ExpenseProvider()..loadExpenses()),
    ],
    child: const SpendWiseApp(),
  ),
);
```

## 6.4 Reading Provider in Widgets

```dart
// Method 1: context.watch — rebuilds when data changes (use in build())
final provider = context.watch<ExpenseProvider>();
Text("Balance: ₹${provider.monthlyBalance}")  // auto-updates!

// Method 2: context.read — just reads once (use in callbacks/functions)
final auth = context.read<AuthProvider>();
auth.logout();  // call a method

// Method 3: Consumer widget
Consumer<ExpenseProvider>(
  builder: (context, provider, child) {
    return Text("₹${provider.monthlyBalance}");
  },
)
```

---

# 7. Navigation in Flutter

## 7.1 Navigator — Moving Between Screens

Flutter uses a "stack" of screens. Think of screens like a stack of plates:
- **Push** = Put a new plate on top (go to new screen)
- **Pop** = Remove top plate (go back)
- **Replace** = Swap the top plate (go to new screen, can't go back)

```dart
// Push (go forward, can go back with back button)
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const TransactionsScreen()),
);

// Pop (go back)
Navigator.pop(context);

// PushReplacement (go forward, CANNOT go back — used after login)
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => const HomeScreen()),
);
```

## 7.2 Custom Page Transitions (used in SplashScreen)

```dart
Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    pageBuilder: (_, __, ___) => const HomeScreen(),
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),  // fade transition
  ),
);
```

## 7.3 IndexedStack — Tabbed Navigation (used in HomeScreen)

Your app uses `IndexedStack` for bottom tab navigation. It keeps all 4 tabs alive (doesn't destroy them when you switch):

```dart
class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;  // which tab is active

  static const _screens = [
    DashboardScreen(),    // index 0
    AnalyticsScreen(),    // index 1
    TransactionsScreen(), // index 2
    SettingsScreen(),     // index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,  // shows screen at this index
        children: _screens,
      ),
    );
  }
}
```

---

# 8. HTTP Networking in Flutter

## 8.1 How Flutter Talks to the Backend

```
┌──────────────┐   HTTP Request    ┌───────────────┐
│  Flutter App  │ ────────────────→ │  Node.js API  │
│              │ ←──────────────── │               │
└──────────────┘   JSON Response   └───────────────┘
```

Your app uses the `http` package:
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';  // for jsonEncode / jsonDecode
```

## 8.2 GET Request — Fetching Data

```dart
// From database_helper.dart
static Future<List<Expense>> getAll() async {
  // 1. Make GET request to server
  final response = await http.get(Uri.parse('http://localhost:3000/api/expenses'));
  
  // 2. Check if successful (200 = OK)
  if (response.statusCode != 200) {
    throw Exception('Failed to load expenses');
  }
  
  // 3. Parse JSON response body
  final List<dynamic> data = jsonDecode(response.body);
  
  // 4. Convert each JSON object to Expense model
  return data.map((e) => Expense.fromMap(e)).toList();
}
```

## 8.3 POST Request — Sending Data

```dart
// From database_helper.dart
static Future<int> insert(Expense expense) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/api/expenses'),
    headers: {'Content-Type': 'application/json'},  // tell server format
    body: jsonEncode(expense.toJson()),              // convert to JSON string
  );
  
  if (response.statusCode != 201) {        // 201 = Created
    throw Exception('Insert failed');
  }
  
  final data = jsonDecode(response.body);
  return data['id'] as int;  // server returns the new ID
}
```

## 8.4 PUT Request — Updating Data

```dart
static Future<int> update(Expense expense) async {
  final response = await http.put(
    Uri.parse('http://localhost:3000/api/expenses/${expense.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(expense.toJson()),
  );
  
  if (response.statusCode != 200) throw Exception('Update failed');
  return 1;
}
```

## 8.5 DELETE Request — Removing Data

```dart
static Future<int> delete(int id) async {
  final response = await http.delete(
    Uri.parse('http://localhost:3000/api/expenses/$id'),
  );
  
  if (response.statusCode != 200) throw Exception('Delete failed');
  return 1;
}
```

## 8.6 HTTP Status Codes (Important!)

| Code | Meaning | Used When |
|------|---------|-----------|
| 200 | OK | Successful GET / PUT / DELETE |
| 201 | Created | Successful POST (new record created) |
| 400 | Bad Request | Missing required fields |
| 401 | Unauthorized | Wrong password |
| 404 | Not Found | Record doesn't exist |
| 409 | Conflict | Email already registered |
| 500 | Server Error | Something crashed on server |

---

# 9. Backend: Node.js + Express

## 9.1 What is Node.js?

**Node.js** lets you run JavaScript on the server (not just in browsers). It's the engine running your backend.

**Express.js** is a web framework on top of Node.js — it makes it easy to create API routes (URLs the app can call).

## 9.2 Project Structure

```
Backend/
├── .env           ← Secret config (DB password, JWT secret)
├── package.json   ← Lists all dependencies
├── server.js      ← Main file — starts everything
├── db.js          ← MySQL connection pool
└── routes/
    ├── auth.js    ← /api/auth/register and /api/auth/login
    └── expenses.js← All /api/expenses routes
```

## 9.3 server.js Explained

```javascript
const express = require('express');
const cors    = require('cors');
require('dotenv').config();     // load .env file

const app  = express();
const PORT = 3000;

// MIDDLEWARE — runs on every request before reaching routes
app.use(cors());             // allow Flutter app on different port to call API
app.use(express.json());     // parse JSON request bodies automatically

// ROUTES — which function handles which URL
app.use('/api/auth',     authRoutes);     // all auth URLs
app.use('/api/expenses', expenseRoutes);  // all expense URLs

// Health check
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// Start the server
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

### What is CORS?
**CORS** (Cross-Origin Resource Sharing) — browsers/apps block requests to different domains by default for security. Your Flutter app runs on one port, your API on another. `cors()` middleware tells the browser: "Yes, it's OK to accept requests from other origins."

### What is Middleware?
Code that runs in the "middle" — between receiving the request and sending the response. Like a checkpoint.

```
Request → [CORS middleware] → [JSON parser middleware] → [Route handler] → Response
```

## 9.4 REST API Design

**REST** (Representational State Transfer) — a standard way to design web APIs using HTTP methods:

| HTTP Method | Action | Example |
|-------------|--------|---------|
| GET | Fetch/Read data | GET /api/expenses |
| POST | Create new data | POST /api/expenses |
| PUT | Update existing | PUT /api/expenses/5 |
| DELETE | Remove data | DELETE /api/expenses/5 |

Your API endpoints:
```
POST   /api/auth/register            → create account
POST   /api/auth/login               → sign in, get token

GET    /api/expenses                 → get all expenses
GET    /api/expenses?year=2026&month=3 → filter by month
GET    /api/expenses/total?type=expense → sum of expenses
GET    /api/expenses/analytics/category-totals → pie chart data
GET    /api/expenses/analytics/monthly-totals  → bar chart data
GET    /api/expenses/analytics/daily-totals    → trend chart data
POST   /api/expenses                 → add new expense
PUT    /api/expenses/:id             → edit expense
DELETE /api/expenses/:id             → delete expense
```

## 9.5 Route Handler Example

```javascript
// GET /api/expenses — fetch all expenses with optional filters
router.get('/', async (req, res) => {
  try {
    const { year, month } = req.query;  // read URL params
    let sql = 'SELECT * FROM expenses';
    const params = [];

    if (year && month) {
      sql += ' WHERE LEFT(date, 7) = ?';  // filter by YYYY-MM
      params.push(`${year}-${month}`);
    }

    sql += ' ORDER BY date DESC';

    const [rows] = await pool.query(sql, params);  // run SQL
    res.json(rows);                                // send back as JSON
  } catch (err) {
    res.status(500).json({ error: err.message });  // send error
  }
});
```

## 9.6 Environment Variables (.env file)

Never hard-code passwords in code! Use `.env`:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=yourpassword
DB_NAME=spendwise
JWT_SECRET=spendwise_jwt_secret_2026
PORT=3000
```

In code:
```javascript
process.env.DB_PASSWORD   // safely reads the password
process.env.JWT_SECRET    // reads the secret
```

## 9.7 db.js — Connection Pool

```javascript
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'spendwise',
  connectionLimit: 10,   // max 10 simultaneous connections
});

module.exports = pool;
```

**Connection Pool** = Instead of opening/closing a new database connection for each request (slow!), a pool keeps a set of ready connections and reuses them. Much faster!

---

# 10. Database: MySQL

## 10.1 What is MySQL?

**MySQL** is a relational database — data is stored in **tables** (like Excel spreadsheets), with rows and columns. You query it using **SQL** (Structured Query Language).

## 10.2 The SpendWise Database Schema

```
DATABASE: spendwise
│
├── TABLE: users
│   ┌──────┬────────────┬─────────────────────┬──────────────────┬──────────────────────┐
│   │  id  │    name    │        email         │   password_hash  │      created_at      │
│   ├──────┼────────────┼─────────────────────┼──────────────────┼──────────────────────┤
│   │  1   │ Chaitanya  │ chat@example.com     │ $2b$12$abc...    │ 2026-03-01 10:00:00  │
│   │  2   │ Priya      │ priya@example.com    │ $2b$12$xyz...    │ 2026-03-05 14:30:00  │
│   └──────┴────────────┴─────────────────────┴──────────────────┴──────────────────────┘
│
└── TABLE: expenses
    ┌──────┬──────────────┬────────┬─────────────┬──────────────────────┬─────────┬──────────┐
    │  id  │    title     │ amount │   category  │         date         │  type   │  notes   │
    ├──────┼──────────────┼────────┼─────────────┼──────────────────────┼─────────┼──────────┤
    │  1   │ Coffee       │  50.0  │ Food&Dining │ 2026-03-12T08:00:00  │ expense │  null    │
    │  2   │ Salary       │ 50000  │ Salary      │ 2026-03-01T00:00:00  │ income  │ March    │
    │  3   │ Bus ticket   │  80.0  │ Transport.  │ 2026-03-11T17:00:00  │ expense │  null    │
    └──────┴──────────────┴────────┴─────────────┴──────────────────────┴─────────┴──────────┘
```

## 10.3 SQL Commands

```sql
-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS spendwise;

-- CREATE TABLE
CREATE TABLE IF NOT EXISTS expenses (
  id         INT            AUTO_INCREMENT PRIMARY KEY,  -- auto-incrementing ID
  title      VARCHAR(255)   NOT NULL,                    -- text, max 255 chars
  amount     DOUBLE         NOT NULL,                    -- decimal number
  category   VARCHAR(100)   NOT NULL,
  date       VARCHAR(30)    NOT NULL,                    -- stored as ISO string
  type       ENUM('expense','income') NOT NULL,          -- only these two values
  notes      TEXT,                                       -- long text, can be NULL
  created_at TIMESTAMP      DEFAULT CURRENT_TIMESTAMP    -- auto-set on insert
);

-- INSERT (add new record)
INSERT INTO expenses (title, amount, category, date, type)
VALUES ('Coffee', 50.0, 'Food & Dining', '2026-03-12T08:00:00', 'expense');

-- SELECT (fetch records)
SELECT * FROM expenses;                                -- get everything
SELECT * FROM expenses WHERE type = 'expense';        -- filter
SELECT * FROM expenses ORDER BY date DESC;            -- sort newest first
SELECT * FROM expenses WHERE LEFT(date, 7) = '2026-03'; -- filter by month

-- UPDATE (edit record)
UPDATE expenses SET amount = 60.0 WHERE id = 1;

-- DELETE (remove record)
DELETE FROM expenses WHERE id = 1;

-- AGGREGATE functions
SELECT SUM(amount) AS total FROM expenses WHERE type = 'expense';
SELECT category, SUM(amount) AS total FROM expenses GROUP BY category;
```

## 10.4 What is AUTO_INCREMENT PRIMARY KEY?

```
id   title        amount
1    Coffee       50     ← first insert, gets id=1
2    Salary       50000  ← second insert, gets id=2
3    Bus          80     ← third insert, gets id=3

DELETE id=2 (Salary)

4    Movie        200    ← next insert gets id=4 (NOT 2!)
```

AUTO_INCREMENT never repeats — it always goes up. The `id` is the primary key — every row has a unique ID.

---

# 11. Authentication: JWT + bcrypt

## 11.1 Why Authentication?

Without auth, anyone could see/edit everyone's expenses. Auth ensures users can only access their own data.

## 11.2 bcrypt — Password Hashing

**NEVER store plain text passwords!** If the database gets hacked, all passwords are exposed.

**bcrypt** converts a password into a scrambled "hash" that:
1. Is irreversible (can't convert hash back to password)
2. Is random-looking (same password → different hash each time due to "salt")
3. Can be verified (compare password against hash to check if they match)

```
Password "abc123"  →  bcrypt.hash()  →  "$2b$12$xKLj9bQ..."
                                            ↑ this is stored in DB

Login check:
"abc123" + "$2b$12$xKLj9bQ..."  →  bcrypt.compare()  →  true ✓
"wrongpw" + "$2b$12$xKLj9bQ..."  →  bcrypt.compare()  →  false ✗
```

```javascript
// Registration — hash the password
const hash = await bcrypt.hash(password, 12); // 12 = salt rounds (security level)
// Store hash in database, NOT the original password
await pool.query('INSERT INTO users (password_hash) VALUES (?)', [hash]);

// Login — verify the password
const match = await bcrypt.compare(password, user.password_hash);
if (!match) return res.status(401).json({ error: 'Invalid credentials' });
```

## 11.3 JWT — JSON Web Token

After login, the server gives the Flutter app a **JWT token** — like a digital ID card.

**JWT Structure:** Three parts separated by dots:
```
eyJhbGciOiJIUzI1NiJ9 . eyJpZCI6MSwiZW1haWwiOiJ0ZXN0QGVtYWlsLmNvbSJ9 . SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
        ↑ Header               ↑ Payload (your data)               ↑ Signature
   (algorithm)          (id, name, email, expires)         (proves it's real)
```

**How it's used:**
```
1. User logs in with email + password
2. Server verifies credentials ✓
3. Server creates JWT: jwt.sign({id:1, name:"Chai"}, SECRET, {expiresIn:'7d'})
4. Server sends JWT to Flutter app
5. Flutter stores JWT in SharedPreferences (phone storage)
6. On next app open: load JWT from storage → user is still logged in!
7. JWT expires after 7 days → user must log in again
```

```javascript
// Creating JWT (on login/register)
const token = jwt.sign(
  { id: user.id, name: user.name, email: user.email },  // payload
  SECRET,                                                // secret key
  { expiresIn: '7d' }                                   // expires in 7 days
);
res.json({ token, user: {...} });
```

```dart
// Flutter stores the token
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token);

// On app restart, load token
_token = prefs.getString('auth_token');
if (_token != null) {
  // User is still logged in!
}
```

---

# 12. Project File-by-File Explained

## 12.1 Frontend Structure

```
lib/
├── main.dart                   ← App entry point
├── core/
│   ├── constants.dart          ← Category lists, colors, icons
│   └── theme.dart              ← App-wide colors, fonts, styles
├── models/
│   └── expense.dart            ← Expense data class
├── providers/
│   ├── auth_provider.dart      ← Login/logout state
│   └── expense_provider.dart   ← Expense data + filtering
├── database/
│   └── database_helper.dart    ← HTTP calls to backend API
├── services/
│   ├── auth_service.dart       ← HTTP calls for auth API
│   └── pdf_bill_service.dart   ← PDF generation logic
├── screens/
│   ├── splash_screen.dart      ← Logo + loading screen
│   ├── login_screen.dart       ← Sign in form
│   ├── signup_screen.dart      ← Register form
│   ├── home_screen.dart        ← Main container with bottom nav
│   ├── dashboard_screen.dart   ← Home tab with balance + charts
│   ├── analytics_screen.dart   ← Charts tab (pie/bar/line)
│   ├── transactions_screen.dart← Wallet tab with expense list
│   ├── settings_screen.dart    ← Profile tab with settings
│   ├── add_expense_screen.dart ← Add/edit expense form
│   └── export_screen.dart      ← PDF/JSON export screen
└── widgets/
    ├── chart_widgets.dart      ← Reusable chart components
    ├── summary_card.dart       ← Balance summary card
    └── transaction_tile.dart   ← Single expense row
```

## 12.2 main.dart — App Entry Point

```dart
void main() async {
  // Step 1: Initialize Flutter binding (must be first!)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Step 2: Create AuthProvider and load saved login
  final authProvider = AuthProvider();
  await authProvider.loadFromPrefs();  // checks if user is already logged in
  
  // Step 3: Run app with dependency injection (Provider)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..loadExpenses()),
      ],
      child: const SpendWiseApp(),
    ),
  );
}

class SpendWiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,  // hide debug banner
      theme: AppTheme.theme,              // apply custom theme
      home: const SplashScreen(),         // first screen
    );
  }
}
```

## 12.3 expense.dart — Data Model

```dart
class Expense {
  final int? id;          // nullable — no ID before saving to DB
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String type;      // 'expense' or 'income'
  final String? notes;    // optional

  // Constructor
  const Expense({...});

  // Convert Expense object → JSON (for sending to API)
  Map<String, dynamic> toJson() => {
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),  // "2026-03-12T10:00:00.000"
    ...
  };

  // Convert JSON (from API) → Expense object
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'] as int?,
    title: map['title'] as String,
    amount: (map['amount'] as num).toDouble(),
    date: DateTime.parse(map['date'] as String),
    ...
  );

  // Computed properties
  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';

  // Create a modified copy (useful for editing)
  Expense copyWith({String? title, double? amount, ...}) => Expense(
    title: title ?? this.title,   // use new value or keep old
    amount: amount ?? this.amount,
    ...
  );
}
```

## 12.4 theme.dart — Design System

Your app has a dark theme inspired by OlympTrade (trading app). All colors are defined once and reused everywhere:

```dart
class AppTheme {
  static const Color primaryColor  = Color(0xFF34FF29);   // Neon Green
  static const Color expenseColor  = Color(0xFFFF4444);   // Red
  static const Color incomeColor   = Color(0xFF34FF29);   // Green
  static const Color cardColor     = Color(0xFF111111);   // Dark card
  static const Color surfaceColor  = Color(0xFF0A0A0A);   // Almost black
}
```

Color code breakdown: `Color(0xFF34FF29)`
- `0xFF` — Always first (full opacity)
- `34` — Red component (hex) = 52 in decimal
- `FF` — Green component (hex) = 255 in decimal
- `29` — Blue component (hex) = 41 in decimal
→ This makes a bright green color!

## 12.5 constants.dart — App-wide Data

```dart
class AppConstants {
  // All expense/income categories with icons and colors
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Food & Dining',   'icon': Icons.restaurant_rounded, 'color': 0xFFFF6B6B},
    {'name': 'Transportation',  'icon': Icons.directions_car_rounded, 'color': 0xFF4ECDC4},
    // ... 10 more categories
  ];

  // Just the names (for expense type)
  static const List<String> expenseCategories = [
    'Food & Dining', 'Transportation', 'Shopping', ...
  ];

  // Just the names (for income type)
  static const List<String> incomeCategories = [
    'Salary', 'Freelance', 'Investment', 'Others'
  ];

  // Helper methods
  static Color getCategoryColor(String category) { ... }
  static IconData getCategoryIcon(String category) { ... }
}
```

## 12.6 splash_screen.dart — Loading Screen

```
┌──────────────────────────────────────┐
│                                      │
│                                      │
│           [SpendWise Logo]           │ ← fades in + scales up
│                                      │   (900ms animation)
│            SpendWise                 │
│         Track. Save. Grow.           │
│                                      │
│                                      │
└──────────────────────────────────────┘
         After 2 seconds →
   isLoggedIn? → HomeScreen : LoginScreen
```

Key concepts used:
- `AnimationController` — drives the animation
- `CurvedAnimation` — applies easing (starts slow, speeds up)
- `FadeTransition` — opacity animation
- `ScaleTransition` — size animation  
- `Future.delayed` — waits 2 seconds before navigating
- `SystemChrome.setEnabledSystemUIMode` — hides status bar for immersive mode

## 12.7 home_screen.dart — Main Container

The `HomeScreen` is a container holding all 4 main screens + the custom bottom nav bar.

```
┌──────────────────────────────────────┐
│                                      │
│   Active Screen (0, 1, 2, or 3)     │
│                                      │
│                                      │
│                                      │
│           ┌────────────────────────┐ │
│           │  [+] (floating FAB)    │ │  ← opens AddExpenseScreen
│ ┌─────────┼────────────────────────┤ │
│ │🏠 Home  │  Analytics  Wallet  👤 │ │  ← glass pill nav bar
│ └─────────┴────────────────────────┘ │
└──────────────────────────────────────┘
```

The nav bar features **Glassmorphism** — a frosted glass effect:
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(36),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),  // blur background
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(           // semi-transparent white
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.06),
          ],
        ),
      ),
    ),
  ),
)
```

## 12.8 dashboard_screen.dart — Home Tab

```
┌────────────────────────────────────────────┐
│ Dashboard                    [🔔]           │
│ Welcome back, Chaitanya                     │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │ TOTAL BALANCE                           │ │
│ │        ₹45,000.00        +12%↑          │ │
│ │ ─────────────────────────────────────── │ │
│ │  Income: ₹50,000   Expense: ₹5,000      │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Spending Trend    [Weekly] [Monthly]        │
│ ┌─────────────────────────────────────────┐ │
│ │    📈 Line chart showing spending        │ │
│ │       over 7 or 30 days                 │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Recent Transactions            See All →    │
│ ┌─────────────────────────────────────────┐ │
│ │ 🍔 Coffee      Food & Dining  -₹50      │ │
│ │ 💰 Salary      Salary        +₹50,000   │ │
│ │ 🚌 Bus ticket  Transport.     -₹80      │ │
│ └─────────────────────────────────────────┘ │
└────────────────────────────────────────────┘
```

## 12.9 analytics_screen.dart — Charts Tab

Three sub-tabs:

```
┌────────────────────────────────────────────┐
│ Analytics                                   │
│ [Overview]  [Categories]  [Trends]          │
├────────────────────────────────────────────┤
│                                             │
│ OVERVIEW TAB:                               │
│ ┌──────────────┐ ┌──────────────┐          │
│ │ All-time     │ │ All-time     │          │
│ │ Income       │ │ Spent        │          │
│ │ ₹1,00,000   │ │ ₹45,000     │          │
│ └──────────────┘ └──────────────┘          │
│                                             │
│ 6-Month Bar Chart                           │
│ ┌─────────────────────────────────────────┐ │
│ │  ▐▌             ▐▌         ▐▌           │ │
│ │  ▐▌    ▐▌       ▐▌  ▐▌    ▐▌  ▐▌      │ │
│ │  ▐▌    ▐▌ ▐▌   ▐▌  ▐▌    ▐▌  ▐▌      │ │
│ │  Oct  Nov  Dec  Jan  Feb  Mar           │ │
│ │  ■ Income  ■ Expense                    │ │
│ └─────────────────────────────────────────┘ │
├────────────────────────────────────────────┤
│ CATEGORIES TAB:                             │
│ ┌─────────────────────────────────────────┐ │
│ │         [Donut Pie Chart]               │ │
│ │     ● Food 40%  ● Transport 20%         │ │
│ │     ● Shopping 25% ● Health 15%         │ │
│ └─────────────────────────────────────────┘ │
└────────────────────────────────────────────┘
```

Uses **fl_chart** package for all charts.

## 12.10 transactions_screen.dart — Wallet Tab

```
┌────────────────────────────────────────────┐
│ Transactions                    [Sort ↕]   │
│                                             │
│ 🔍 [Search transactions...]                │
│    [All]  [Income]  [Expense]              │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │  15 Transactions  |  Spent: ₹5,000      │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Today                                       │
│ ─────────────────────────────────────────   │
│ 🍔 Coffee           Mar 12   -₹50.00        │
│ 🚌 Bus              Mar 12   -₹80.00        │
│                                             │
│ Yesterday                                   │
│ ─────────────────────────────────────────   │
│ 💰 Salary           Mar 11  +₹50,000        │
└────────────────────────────────────────────┘
```

## 12.11 add_expense_screen.dart — Add/Edit Form

```
┌────────────────────────────────────────────┐
│  ─── (drag handle)           [✕]           │
│  New Transaction                            │
│                                             │
│  [  Expense  ↓  ]  [  Income  ↑  ]        │
│                                             │
│              Amount                         │
│           ₹ 0.00                           │
│                                             │
│  Title                                      │
│  [________________________]                 │
│                                             │
│  Category                                   │
│  [Food & Dining        ▼]                  │
│                                             │
│  Date                                       │
│  [📅 12 March 2026     ]                   │
│                                             │
│  Notes (optional)                           │
│  [________________________]                 │
│                                             │
│  [     Save Transaction     ]               │
└────────────────────────────────────────────┘
```

## 12.12 settings_screen.dart — Profile Tab

```
┌────────────────────────────────────────────┐
│ Settings                                    │
│                                             │
│ ┌─────────────────────────────────────────┐ │
│ │    [CD]   Chaitanya                     │ │ ← initials avatar
│ │           chaitanya@example.com         │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ Account                                     │
│  👤 Edit Profile                           │
│  🔒 Change Password                        │
│                                             │
│ Preferences                                 │
│  ₹ Currency                    ₹ INR →     │
│  🔔 Notifications                          │
│                                             │
│ Data                                        │
│  📄 Export PDF Report          [Export]    │
│                                             │
│  [          Sign Out          ]             │
└────────────────────────────────────────────┘
```

## 12.13 pdf_bill_service.dart — PDF Generation

Uses the `pdf` and `printing` packages to generate a professional PDF report:

```dart
// Generate PDF bytes
final Uint8List bytes = await PdfBillService.generateMonthlyBill(
  expenses: filteredExpenses,
  from: DateTime(2026, 3, 1),
  to: DateTime(2026, 3, 31),
  userName: "Chaitanya",
);

// Share/download the PDF
await Printing.sharePdf(bytes: bytes, filename: 'SpendWise_Report_2026_03.pdf');
```

**The PDF contains:**
1. Header — SpendWise logo + report period + user name
2. Summary cards — Total Income, Total Expense, Net balance
3. Category breakdown table — how much spent per category
4. Full transaction list — all expenses/income sorted by date
5. Footer — page numbers + generation date

---

# 13. App Screens — Visual Tour

## 13.1 User Journey Map

```
   App Opens
       │
       ▼
  ┌─────────────┐
  │ Splash Screen│  (Logo + animation, 2 seconds)
  └──────┬──────┘
         │
    /────┴────\
   /             \
Is logged in?     Not logged in?
(JWT in storage)
   │                    │
   ▼                    ▼
┌──────────┐    ┌──────────────┐
│ Home     │    │ Login Screen │
│ Screen   │    └──────┬───────┘
└──────────┘           │
                 New user? │ Existing user?
                       ▼           ▼
                ┌──────────────┐  POST /api/auth/login
                │Signup Screen │  ↓ JWT received
                └──────────────┘  ↓ Saved to SharedPrefs
                POST /api/auth/register    │
                ↓ JWT received             ▼
                ↓ Saved to SharedPrefs ┌──────────┐
                                       │ Home     │
                                       │ Screen   │
                                       └──────────┘
```

## 13.2 Screen Flow After Login

```
HomeScreen (contains all 4 tabs)
│
├── Tab 0: DashboardScreen
│         ├── Balance Card (income - expense)
│         ├── Spending Trend Chart (line chart)
│         └── Recent 5 Transactions
│                   └── [See All] → TransactionsScreen (pushed)
│
├── Tab 1: AnalyticsScreen
│         ├── Overview (bar chart, totals)
│         ├── Categories (pie chart breakdown)
│         └── Trends (line chart)
│
├── Tab 2: TransactionsScreen
│         ├── Search bar
│         ├── Filter chips (All/Income/Expense)
│         └── Grouped expense list
│                   └── [Long press / menu] → Edit → AddExpenseScreen
│
├── Tab 3: SettingsScreen
│         ├── Profile card with initials
│         ├── Account settings
│         ├── Preferences
│         ├── Export PDF → PdfBillService → Printing.sharePdf
│         └── Sign Out → AuthProvider.logout() → LoginScreen
│
└── [+ FAB] → AddExpenseScreen (bottom sheet)
              └── Save → ExpenseProvider.addExpense() → API → DB
```

---

# 14. Data Flow Diagrams

## 14.1 Adding an Expense (Complete Flow)

```
User fills form in AddExpenseScreen
              │
              ▼
    Tap "Save Transaction"
              │
              ▼
  Form validation checks
  (title not empty, amount > 0)
              │
              ▼
  provider.addExpense(expense)  ← ExpenseProvider method
              │
              ▼
  DatabaseHelper.insert(expense)  ← HTTP layer
              │
              ▼
  POST /api/expenses  ← HTTP request to backend
  Body: { "title":"Coffee", "amount":50, "category":"Food", ... }
              │
              ▼
  Express route handler receives request
              │
              ▼
  INSERT INTO expenses (...) VALUES (...)  ← SQL query
              │
              ▼
  MySQL saves row, returns new ID
              │
              ▼
  Server responds: { "id": 42 }
              │
              ▼
  DatabaseHelper got ID=42
              │
              ▼
  provider.loadExpenses() runs again  ← refresh all data
              │
              ▼
  GET /api/expenses  ← fetch updated list
              │
              ▼
  New list returned → _allExpenses updated
              │
              ▼
  notifyListeners()  ← all widgets watching provider rebuild
              │
              ▼
  Dashboard + TransactionsScreen + Analytics all update! ✓
```

## 14.2 Login Flow (JWT Authentication)

```
LoginScreen:
User enters email + password
              │
              ▼
  AuthProvider.login(email, password)
              │
              ▼
  AuthService.login(email, password)
              │
              ▼
  POST /api/auth/login
  Body: { "email": "...", "password": "..." }
              │
              ▼
  Server:
  1. Find user by email in MySQL
  2. bcrypt.compare(password, hash)  → true ✓
  3. jwt.sign({id, name, email}, SECRET, {expiresIn:'7d'})
  4. Return { token: "eyJ...", user: {...} }
              │
              ▼
  AuthProvider receives token + user
              │
              ▼
  SharedPreferences.setString('auth_token', token)
  (saved to phone storage)
              │
              ▼
  notifyListeners()
              │
              ▼
  Navigator → HomeScreen
```

## 14.3 Provider State Flow

```
       ┌──────────────────────────────┐
       │      ExpenseProvider         │
       │                              │
       │  _allExpenses: [...]         │
       │  _isLoading: false           │
       │  _filterType: .all           │
       │  _searchQuery: ""            │
       │                              │
       │  GETTERS:                    │
       │  filteredExpenses → filter + sort + search applied
       │  monthlyIncome → sum of income this month
       │  monthlyCategoryTotals → map for pie chart
       └──────────────┬───────────────┘
                      │ notifyListeners()
          ┌───────────┼───────────┐
          ▼           ▼           ▼
   Dashboard     Analytics   Transactions
    rebuilds      rebuilds     rebuilds
   (watches       (watches      (watches
   provider)      provider)     provider)
```

---

# 15. Flutter Packages Used

Packages = pre-built libraries you add to your project. Defined in `pubspec.yaml`.

## 15.1 provider (^6.1.2)
**What:** State management
**Why:** Share data across widgets without passing it manually
**Used for:** AuthProvider, ExpenseProvider

## 15.2 http (^1.2.2)
**What:** Make HTTP requests (GET, POST, PUT, DELETE)
**Why:** Flutter apps can't talk to MySQL directly — need to go through the API
**Used for:** All API calls in database_helper.dart and auth_service.dart

## 15.3 shared_preferences (^2.3.2)
**What:** Store small data on the device (like browser cookies)
**Why:** Remember login token between app restarts
**Used for:** Saving JWT token, user name, user email

## 15.4 fl_chart (^0.69.0)
**What:** Beautiful, interactive charts
**Why:** Pie charts, bar charts, line charts for analytics
**Used for:** ExpensePieChart, MonthlyBarChart in chart_widgets.dart

## 15.5 google_fonts (^6.2.1)
**What:** Use Google Fonts in Flutter
**Why:** Poppins font looks professional and modern
**Used for:** All text in the app uses Poppins

## 15.6 flutter_animate (^4.5.2)
**What:** Simple animations with extensions
**Why:** Fade-in animations on analytics widgets
**Used for:** `.animate().fadeIn(duration: 400.ms)` in analytics_screen.dart

## 15.7 pdf (^3.11.0) + printing (^5.13.1)
**What:** Generate PDF documents and print/share them
**Why:** Professional expense reports
**Used for:** PdfBillService generates and shares PDF reports

## 15.8 intl (^0.19.0)
**What:** Internationalization — date/number formatting
**Why:** Format dates as "12 March 2026", numbers as "₹1,00,000"
**Used for:** DateFormat, NumberFormat throughout the app

## 15.9 share_plus (^10.1.2)
**What:** Share files/text using the device's share sheet
**Why:** Share exported JSON or PDF files
**Used for:** JSON export in export_screen.dart

## 15.10 path_provider (^2.1.4)
**What:** Find the device's file system paths
**Why:** Know where to save exported files
**Used for:** Getting temp directory for saving files before sharing

---

# 16. Common Exam Questions & Answers

## Section A: Flutter & Dart

**Q1: What is Flutter? What are its advantages?**

> Flutter is Google's open-source UI toolkit for building natively compiled applications from a single Dart codebase. Advantages:
> - One codebase → Android + iOS + Web + Desktop
> - Fast development with Hot Reload (see changes instantly)
> - Beautiful UIs with customizable widgets
> - High performance (compiled to native code)
> - Large community and packages

---

**Q2: What is the difference between StatelessWidget and StatefulWidget?**

> - **StatelessWidget**: Immutable widget whose UI doesn't change after creation. Used for static UI elements. E.g., `WelcomeText`, `AppLogo`
> - **StatefulWidget**: Has mutable state that can change. Calls `setState()` to trigger UI rebuild. E.g., `LoginScreen` (changes loading state), `AddExpenseScreen` (changes form fields)
> - **In your project**: `SplashScreen`, `HomeScreen`, `_LoginScreenState`, `_AddExpenseScreenState` are all StatefulWidgets

---

**Q3: What is setState() and when do you use it?**

> `setState()` is a method in StatefulWidget's State class that tells Flutter: "My data changed, please rebuild the UI." You use it whenever you change a local variable that affects what's displayed.
> 
> Example from login_screen.dart:
> ```dart
> void _togglePassword() {
>   setState(() { _obscure = !_obscure; });
> }
> ```

---

**Q4: What is Provider and why is it used?**

> Provider is a state management package. It allows you to:
> 1. Store shared data in a central class (`ChangeNotifier`)
> 2. Any widget can listen to this class
> 3. When data changes, all listening widgets automatically rebuild
> 
> In SpendWise: `ExpenseProvider` holds all expenses. When you add/delete one, `notifyListeners()` is called, and Dashboard, Analytics, and Transactions all update automatically.

---

**Q5: What is async/await in Dart?**

> Async/await handles **asynchronous operations** — operations that take time (network calls, file I/O) without freezing the UI.
> - `async`: Marks a function as asynchronous
> - `await`: Pauses execution inside the async function until the operation completes
> 
> Without it, the network call would block the entire app (frozen screen). With async/await, Flutter continues running other things while waiting.

---

**Q6: What is BuildContext?**

> `BuildContext` represents where a widget is in the widget tree. It's used to:
> - Read providers: `context.watch<AuthProvider>()`
> - Navigate: `Navigator.of(context).push(...)`
> - Show dialogs/snackbars: `ScaffoldMessenger.of(context).showSnackBar(...)`
> - Access theme: `Theme.of(context)`

---

**Q7: What is a FutureBuilder?**

> `FutureBuilder` is a widget that builds itself based on the result of a `Future`. It shows different UI for loading, success, and error states.
> 
> Your project uses a simpler pattern — storing loading state in Provider and using `if (provider.isLoading)` in build method.

---

**Q8: What are Slivers and CustomScrollView?**

> Slivers are "lazy" scroll pieces that only build what's visible. `CustomScrollView` combines multiple slivers. Used in `DashboardScreen` to mix a fixed header, balance card, and scrollable list efficiently.

---

## Section B: Backend

**Q9: What is REST API?**

> REST (Representational State Transfer) is an architectural style for building web APIs. It uses standard HTTP methods (GET, POST, PUT, DELETE) to perform CRUD operations on resources.
> 
> In your project: `/api/expenses` is a REST resource. GET fetches, POST creates, PUT updates, DELETE removes.

---

**Q10: What is JWT and how does it work in your project?**

> JWT (JSON Web Token) is a compact, self-contained token for securely transmitting user identity.
> 1. User logs in → server verifies credentials
> 2. Server creates JWT with user data, signs with SECRET key
> 3. Flutter stores JWT in SharedPreferences
> 4. On next app open, JWT is loaded → user stays logged in (for 7 days)
> 5. If JWT expired → must log in again

---

**Q11: Why do we hash passwords with bcrypt?**

> Plain text passwords in the database are dangerous — if hacked, all accounts are compromised. bcrypt:
> - Converts password to an irreversible hash
> - Adds random "salt" so same password → different hash
> - Slow by design (makes brute force attacks hard)
> - `bcrypt.compare()` can verify password against hash without reversing

---

**Q12: What is CORS and why is it needed?**

> CORS (Cross-Origin Resource Sharing) is a browser security feature that blocks web pages/apps from making requests to a different domain/port.
> 
> The Flutter app runs on one port, the Express server on port 3000. Without `cors()` middleware, all API calls would be blocked. `app.use(cors())` tells the server to accept requests from any origin.

---

**Q13: What is a connection pool (db.js)?**

> Instead of opening/closing a database connection for EVERY request (slow), a connection pool maintains a set of pre-opened connections (max 10) and reuses them. This dramatically improves performance under load.

---

**Q14: What is middleware in Express?**

> Middleware is a function that runs between receiving a request and sending a response. The `app.use()` call registers middleware. In your project:
> - `cors()` → handles CORS headers
> - `express.json()` → parses JSON request body (so `req.body` works)

---

## Section C: Database

**Q15: What is the difference between users and expenses tables?**

> - `users` table: Stores account info (name, email, hashed password). One row per user.
> - `expenses` table: Stores financial transactions. Many rows per user (each expense/income is one row).
> 
> Note: In the current schema, expenses are NOT linked to users by a foreign key — any logged-in user sees all expenses. This is a simplification.

---

**Q16: What is AUTO_INCREMENT PRIMARY KEY?**

> - `PRIMARY KEY`: Unique identifier for each row — no two rows can have the same value
> - `AUTO_INCREMENT`: Database automatically assigns the next available number (1, 2, 3...). You don't need to specify the ID when inserting.

---

**Q17: What is an ENUM in MySQL?**

> ENUM limits a column to a predefined set of values. In expenses table:
> ```sql
> type ENUM('expense','income') NOT NULL
> ```
> This ensures `type` can ONLY be 'expense' or 'income'. Any other value causes an error. Prevents invalid data.

---

**Q18: What does LEFT(date, 7) do in your SQL?**

> `date` is stored as ISO string: `"2026-03-12T10:30:00.000"`
> `LEFT(date, 7)` takes the first 7 characters: `"2026-03"`
> 
> This is how you filter by month — comparing `LEFT(date, 7) = '2026-03'` finds all March 2026 records.

---

## Section D: Project Specific

**Q19: Explain the folder structure of your Flutter app.**

> - `models/` — Data classes (Expense)
> - `providers/` — State management (data stores)
> - `services/` — External service calls (API, PDF)
> - `database/` — HTTP client layer (talks to API)
> - `screens/` — Full-page UI screens
> - `widgets/` — Reusable smaller UI components
> - `core/` — App-wide constants (colors, categories, themes)

---

**Q20: How does adding an expense work end-to-end?**

> 1. User fills `AddExpenseScreen` form
> 2. Taps "Save Transaction" → validates form
> 3. `ExpenseProvider.addExpense(expense)` called
> 4. `DatabaseHelper.insert(expense)` makes POST HTTP request
> 5. Express server receives request at `POST /api/expenses`
> 6. SQL: `INSERT INTO expenses (...)` runs
> 7. MySQL saves, returns new ID
> 8. Server responds `{id: 42}`
> 9. Provider calls `loadExpenses()` to refresh data
> 10. `notifyListeners()` — all screens auto-update

---

**Q21: What is SharedPreferences and how is it used?**

> SharedPreferences stores small key-value data persistently on the device (survives app restarts). Used in SpendWise to store:
> - `auth_token` — the JWT for authentication
> - `user_name` — display name
> - `user_email` — email address
> 
> When the app opens, `AuthProvider.loadFromPrefs()` reads these values to auto-login the user.

---

**Q22: What is the difference between `final` and `const` in Dart?**

> - `final`: Value set once at runtime, can't change after. E.g., `final result = await http.get(...)` — value is known only when code runs.
> - `const`: Value known at compile time (before running). E.g., `const String appName = "SpendWise"` — this is baked into the app binary. More efficient. Widgets with `const` are never rebuilt unnecessarily.

---

**Q23: Why does your app use `IndexedStack` instead of switching screens?**

> `IndexedStack` keeps all tab screens alive in memory. If you switched screens by pushing/popping, each tab would reset its scroll position and reload data when revisited. `IndexedStack` preserves state — your scroll position in Transactions tab stays when you switch to Analytics and back.

---

**Q24: What is Glassmorphism? Where is it used?**

> Glassmorphism is a UI design trend using a frosted glass effect — semi-transparent background with blur. In SpendWise, the bottom navigation bar uses:
> - `BackdropFilter(filter: ImageFilter.blur(...))` — blurs content behind
> - `Container` with white at low opacity (0.12) — semi-transparent white
> - A subtle white border
> 
> This creates the illusion of frosted glass.

---

**Q25: What is the Expense.copyWith() method?**

> `copyWith()` creates a new Expense object with some fields changed and others kept from the original. Used when editing an expense:
> ```dart
> final updated = originalExpense.copyWith(amount: 100.0);  
> // keeps all other fields, only changes amount
> ```
> This follows **immutability** — rather than modifying the original, create a new one.

---

## Section E: Architecture & Design

**Q26: What design pattern does your app use?**

> The app uses **MVVM** (Model-View-ViewModel) inspired architecture:
> - **Model**: `Expense` class in `models/expense.dart`
> - **View**: Screen and widget files in `screens/` and `widgets/`
> - **ViewModel**: Provider classes in `providers/`
> 
> Also uses **Repository pattern**: `DatabaseHelper` and `AuthService` abstract the API layer. Screens don't know HOW data is fetched — they just ask the Provider.

---

**Q27: What is the purpose of the normalise() function in expenses.js?**

> MySQL returns DECIMAL columns as strings (e.g., "50.00" instead of 50.0). The `normalise()` function converts the `amount` field to a proper JavaScript number using `parseFloat()`. Without this, the Flutter app would receive amounts as strings, causing type errors.

---

**Q28: How does search work in TransactionsScreen?**

> 1. User types in search bar
> 2. `provider.setSearch(query)` is called on every keystroke
> 3. In ExpenseProvider: `_searchQuery = query; notifyListeners();`
> 4. `filteredExpenses` getter filters `_allExpenses`:
>    - Checks if title, category, or notes contains the search string
>    - Case-insensitive (`.toLowerCase()`)
> 5. TransactionsScreen auto-rebuilds with filtered results (it watches provider)

---

**Q29: What are the different charts used in your app?**

> All charts use the `fl_chart` package:
> 1. **LineChart** (Dashboard): Shows spending trend over 7 or 30 days (x=day, y=amount spent)
> 2. **PieChart** (Analytics → Categories): Shows expense breakdown by category with percentages
> 3. **BarChart** (Analytics → Overview): Shows income vs expense per month over 6 months

---

**Q30: What happens if the server is offline when the app starts?**

> `ExpenseProvider.loadExpenses()` calls `DatabaseHelper.getAll()` which makes an HTTP request. If the server is down:
> - `http.get()` throws an exception (connection refused)
> - The `try/catch` in `loadExpenses()` catches it
> - `debugPrint('Error loading expenses: $e')` logs the error
> - `_allExpenses` remains empty — app shows empty state
> - Similar in AuthProvider: returns "Connection failed. Is the server running?" error message

---

# QUICK REFERENCE CHEAT SHEET

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPENDWISE CHEAT SHEET                         │
├─────────────────────────────────────────────────────────────────┤
│ PORT:        Backend runs on http://localhost:3000              │
│ DATABASE:    MySQL → spendwise → tables: users, expenses        │
│ AUTH:        JWT token, expires 7 days, stored in SharedPrefs   │
│ AUTH SECRET: spendwise_jwt_secret_2026 (from .env)             │
├─────────────────────────────────────────────────────────────────┤
│ API ENDPOINTS:                                                   │
│   POST   /api/auth/register  → signup                          │
│   POST   /api/auth/login     → login, returns JWT              │
│   GET    /api/expenses       → get all                         │
│   POST   /api/expenses       → create                          │
│   PUT    /api/expenses/:id   → update                          │
│   DELETE /api/expenses/:id   → delete                          │
│   GET    /api/expenses/analytics/category-totals → pie data    │
│   GET    /api/expenses/analytics/monthly-totals  → bar data    │
├─────────────────────────────────────────────────────────────────┤
│ CATEGORIES (expense):  Food&Dining, Transportation, Shopping,  │
│   Entertainment, Health, Bills&Utilities, Education, Travel,   │
│   Others                                                        │
│ CATEGORIES (income):   Salary, Freelance, Investment, Others   │
├─────────────────────────────────────────────────────────────────┤
│ KEY DART CONCEPTS:                                              │
│   final = set once at runtime                                   │
│   const = set at compile time                                   │
│   ? = nullable (can be null)                                    │
│   async/await = asynchronous operations                         │
│   => = arrow function (one-liner)                               │
│   .. = cascade (chain calls on same object)                     │
├─────────────────────────────────────────────────────────────────┤
│ KEY FLUTTER CONCEPTS:                                           │
│   Widget = every UI element                                     │
│   StatelessWidget = cannot change                               │
│   StatefulWidget = can change (setState)                        │
│   build() = returns UI                                          │
│   context = widget's position in tree                          │
│   Provider = state management                                   │
│   notifyListeners() = trigger UI rebuild                        │
│   Navigator.push() = go to new screen                          │
│   Navigator.pop() = go back                                     │
└─────────────────────────────────────────────────────────────────┘
```

---

# HOW TO START THE PROJECT

## Start Backend
```bash
cd Backend
npm install        # install dependencies (first time only)
node server.js     # start server
# or
npm run dev        # with auto-restart on changes (nodemon)
```

## Start Frontend
```bash
cd Frontend
flutter pub get    # install Flutter packages (first time only)
flutter run        # run on emulator/device
flutter run -d chrome  # run in browser (web)
```

## Start MySQL
Make sure MySQL is running and you've set up the database:
```sql
mysql -u root -p
source /path/to/schema.sql;
```

---

*This guide was written to help you understand every part of the SpendWise project. Good luck with your exam presentation!*
