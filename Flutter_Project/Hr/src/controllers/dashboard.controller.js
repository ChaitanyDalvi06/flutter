const dashboardService = require("../services/dashboard.service");

exports.getOverview = async (req, res) => {
  const data = await dashboardService.getOverview();
  res.json(data);
};
