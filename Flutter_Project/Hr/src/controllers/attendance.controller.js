const attendanceService = require("../services/attendance.service");

exports.markAttendance = async (req, res) => {
  const attendance = await attendanceService.markAttendance(req.body);
  res.json({
    message: "Attendance marked successfully",
    attendance
  });
};

exports.getEmployeeAttendance = async (req, res) => {
  const attendance = await attendanceService.getByEmployee(req.params.employeeId);
  res.json(attendance);
};
