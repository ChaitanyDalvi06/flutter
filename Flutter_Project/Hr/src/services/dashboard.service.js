const Employee = require("../models/Employee");
const Attendance = require("../models/Attendance");

const getOverview = async () => {
  const totalEmployees = await Employee.countDocuments();

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  const presentToday = await Attendance.countDocuments({
    date: { $gte: today, $lt: tomorrow },
    status: "PRESENT"
  });

  return { totalEmployees, presentToday };
};

module.exports = { getOverview };
