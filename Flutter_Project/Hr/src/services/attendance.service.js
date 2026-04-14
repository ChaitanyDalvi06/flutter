const Attendance = require("../models/Attendance");

const markAttendance = async (data) => {
  return await Attendance.create(data);
};

const getByEmployee = async (employeeId) => {
  return await Attendance.find({ employeeId }).sort({ date: -1 });
};

module.exports = { markAttendance, getByEmployee };
