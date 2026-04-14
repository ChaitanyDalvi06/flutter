const Employee = require("../models/Employee");

const createEmployee = async (data) => {
  return await Employee.create(data);
};

const getAllEmployees = async () => {
  return await Employee.find();
};

const getEmployeeById = async (id) => {
  return await Employee.findById(id);
};

module.exports = { createEmployee, getAllEmployees, getEmployeeById };
