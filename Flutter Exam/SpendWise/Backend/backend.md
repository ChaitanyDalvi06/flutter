# Backend README (Simple)

## What this is
This is the Node.js + Express API for SpendWise.
It handles authentication, expense APIs, and MySQL database operations.

## Tech used
- Node.js
- Express.js
- MySQL (mysql2/promise)
- bcryptjs (password hashing)
- jsonwebtoken (JWT auth token)
- dotenv (environment variables)
- cors (allow frontend requests)

## Main folder structure
- server.js: app startup, middleware, route registration
- db.js: MySQL connection pool
- routes/auth.js: register + login APIs
- routes/expenses.js: expense CRUD + analytics APIs
- schema.sql: database and expenses table creation
- package.json: dependencies and scripts

## Main API routes
### Auth
- POST /api/auth/register
- POST /api/auth/login

### Expenses
- GET /api/expenses
- POST /api/expenses
- PUT /api/expenses/:id
- DELETE /api/expenses/:id
- GET /api/expenses/total?type=expense|income
- GET /api/expenses/analytics/category-totals
- GET /api/expenses/analytics/monthly-totals
- GET /api/expenses/analytics/daily-totals

## How backend works (simple flow)
1. Server starts on port 3000
2. Middleware runs (cors + express.json)
3. Request hits a route
4. Route validates input
5. Route runs SQL query through pool
6. Response is returned as JSON

## Authentication flow
1. Register/Login request comes from app
2. Password is hashed/verified using bcrypt
3. JWT token is created after successful login
4. Token and user info are sent to frontend

## Database
- Database name: spendwise
- Tables used:
  - users (created from server startup check)
  - expenses (created from schema.sql)

## How to run backend
1. Open terminal in Backend folder
2. Install packages:

```bash
npm install
```

3. Create .env file with DB details:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=spendwise
JWT_SECRET=your_secret
PORT=3000
```

4. Start server:

```bash
npm run dev
```

or

```bash
npm start
```

## Quick exam line
"Backend is built with Express and MySQL. It provides REST APIs for auth and expenses, secures passwords with bcrypt, and returns JSON data to the Flutter app."
