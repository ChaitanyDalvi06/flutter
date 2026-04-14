const router = require("express").Router();
const controller = require("../controllers/dashboard.controller");

router.get("/overview", controller.getOverview);

module.exports = router;
