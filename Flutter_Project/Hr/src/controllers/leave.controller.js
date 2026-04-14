const leaveService = require("../services/leave.service");

exports.createLeave = async (req, res) => {
  const leave = await leaveService.create(req.body);
  res.json({
    message: "Leave request submitted successfully",
    leave
  });
};

exports.getAllLeaves = async (req, res) => {
  const { status, employeeId } = req.query;
  const filter = {};
  if (status) filter.status = status;
  if (employeeId) filter.employeeId = employeeId;
  const leaves = await leaveService.findAll(filter);
  res.json(leaves);
};

exports.getLeavesByEmployee = async (req, res) => {
  const leaves = await leaveService.findByEmployee(req.params.employeeId);
  res.json(leaves);
};

exports.getLeaveById = async (req, res) => {
  const leave = await leaveService.findById(req.params.id);
  if (!leave) {
    return res.status(404).json({ message: "Leave not found" });
  }
  res.json(leave);
};

exports.updateLeave = async (req, res) => {
  const leave = await leaveService.updateById(req.params.id, req.body);
  if (!leave) {
    return res.status(404).json({ message: "Leave not found" });
  }
  res.json(leave);
};
