const router = require("express").Router();
const controller = require("../controllers/payroll.controller");

router.post("/generate", controller.generatePayroll);
router.get("/:employeeId", controller.getEmployeePayroll);

module.exports = router;
