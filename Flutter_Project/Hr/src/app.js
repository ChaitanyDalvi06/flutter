const express = require("express");
const cors = require("cors");
const errorMiddleware = require("./middlewares/error.middleware");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/employees", require("./routes/employee.routes"));
app.use("/api/attendance", require("./routes/attendance.routes"));
app.use("/api/payroll", require("./routes/payroll.routes"));
app.use("/api/leaves", require("./routes/leave.routes"));
app.use("/api/dashboard", require("./routes/dashboard.routes"));

app.use(errorMiddleware);

module.exports = app;
