const router = require("express").Router();
const controller = require("../controllers/employee.controller");

router.post("/", controller.addEmployee);
router.get("/", controller.getEmployees);
router.get("/:id", controller.getEmployeeById);

module.exports = router;
