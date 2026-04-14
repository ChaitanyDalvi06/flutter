const Payroll = require("../models/Payroll");
const Attendance = require("../models/Attendance");
const { calculatePayroll } = require("../utils/payrollCalculator");
const { DEFAULT_WORKING_DAYS_PER_MONTH } = require("../config/constants");

exports.runPayroll = async (employee, month, year) => {
  const workingDays = DEFAULT_WORKING_DAYS_PER_MONTH;

  const attendanceRecords = await Attendance.find({
    employeeId: employee._id
  });

  const presentDays = attendanceRecords.filter(
    (a) => a.status === "PRESENT"
  ).length;

  const absentDays = workingDays - presentDays;

  const { perDaySalary, payableSalary } = calculatePayroll(
    employee.salary,
    workingDays,
    presentDays
  );

  const payroll = await Payroll.create({
    employeeId: employee._id,
    month,
    year,
    workingDays,
    presentDays,
    absentDays,
    perDaySalary,
    payableSalary
  });

  return payroll;
};

exports.getEmployeePayroll = async (employeeId) => {
  return await Payroll.find({ employeeId }).sort({ year: -1, month: -1 });
};
