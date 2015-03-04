# EmployeeSaleryStructure model
class EmployeeSaleryStructure < ActiveRecord::Base
  include Activity
  belongs_to :employee
  belongs_to :payroll_category
  scope :shod, ->(id) { where(id: id).take }

  # method for calculate employee salary strcture on payroll and amount
  # if already created then update salarystrcture else create 
  def self.emp(emp, payroll, amount)
    salary = EmployeeSaleryStructure.where(employee_id: emp.id, payroll_category_id: payroll).take
    if salary.nil?
      EmployeeSaleryStructure.create(employee_id: emp.id, payroll_category_id: payroll, amount: amount)
    else
      salary.update(amount: amount)
    end
  end
end
