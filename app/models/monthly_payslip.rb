# MonthlyPayslip model
class MonthlyPayslip < ActiveRecord::Base
  include Activity
  belongs_to :employee
  scope :shod, ->(id) { where(id: id).take }

  # method for approve salary ,first update is_approved to true
  # then create instance of FinanceTransactionCategory assign all
  # information to FinanceTransactionCategory and save
  def approve_salary
    update(is_approved: true)
    employee = self.employee
    category = FinanceTransactionCategory.find_by_name('Salary')
    t = category.finance_transactions.new
    t.title = "#{employee.first_name + ' ' + employee.last_name}"
    t.description = "Employee Salary Month:- #{salary_date.strftime('%B %Y')}"
    t.amount = amount
    t.transaction_date = Date.today
    t.save
  end

  # return monthlypaslip of employee from salary date
  def self.view(s, e)
    where(salary_date: s, employee_id: e).take
  end
end
