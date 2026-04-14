const employeeService = require("../services/employee.service");

exports.addEmployee = async (req, res) => {
  const employee = await employeeService.createEmployee(req.body);
  res.json({
    message: "Employee added successfully",
    employee
  });
};

exports.getEmployees = async (req, res) => {
  const employees = await employeeService.getAllEmployees();
  res.json(employees);
};

exports.getEmployeeById = async (req, res) => {
  const employee = await employeeService.getEmployeeById(req.params.id);
  if (!employee) {
    return res.status(404).json({ message: "Employee not found" });
  }
  res.json(employee);
};
