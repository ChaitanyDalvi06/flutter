# Frontend README (Simple)

## What this is
This is the Flutter app for SpendWise.
It shows UI screens, takes user input, and talks to the backend API.

## Tech used
- Flutter (UI framework)
- Dart (programming language)
- Provider (state management)
- HTTP package (API calls)
- fl_chart (charts)
- shared_preferences (save login token locally)
- pdf + printing + share_plus (export reports)

## Main folder structure
- lib/main.dart: app entry point
- lib/core/: app theme and constants
- lib/models/: data models (Expense)
- lib/providers/: app state (auth + expenses)
- lib/services/: auth and PDF services
- lib/database/database_helper.dart: API requests for expenses
- lib/screens/: all app screens
- lib/widgets/: reusable UI components

## Main screens
- Splash: app start animation
- Login / Signup: authentication
- Home: main container with bottom nav
- Dashboard: balance + recent transactions + trend
- Analytics: chart-based insights
- Transactions: search, filter, sort list
- Settings: profile + export + logout
- Add Expense: add/edit income or expense

## How frontend works (simple flow)
1. App starts in main.dart
2. Providers are initialized
3. Splash decides: go to Login or Home
4. User actions call Provider methods
5. Provider calls API helper/service
6. Backend returns JSON
7. UI updates automatically

## State management
- AuthProvider: login, register, token/user info
- ExpenseProvider: expense list, filtering, sorting, totals, charts
- notifyListeners() refreshes UI when data changes

## API base URLs used
- Auth: http://localhost:3000/api/auth
- Expenses: http://localhost:3000/api/expenses

## How to run frontend
1. Open terminal in Frontend folder
2. Run:

```bash
flutter pub get
flutter run
```

For web:

```bash
flutter run -d chrome
```

## Important note
Backend must be running first, otherwise API calls will fail.

## Quick exam line
"Frontend is built with Flutter and Provider. It handles UI, local state, and API communication with the Node.js backend using JSON over HTTP."
