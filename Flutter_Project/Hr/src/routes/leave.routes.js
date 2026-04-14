const router = require("express").Router();
const controller = require("../controllers/leave.controller");

router.post("/", controller.createLeave);
router.get("/", controller.getAllLeaves);
router.get("/employee/:employeeId", controller.getLeavesByEmployee);
router.get("/:id", controller.getLeaveById);
router.put("/:id", controller.updateLeave);

module.exports = router;
