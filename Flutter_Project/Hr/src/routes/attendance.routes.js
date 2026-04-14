const router = require("express").Router();
const controller = require("../controllers/attendance.controller");

router.post("/mark", controller.markAttendance);
router.get("/:employeeId", controller.getEmployeeAttendance);

module.exports = router;
