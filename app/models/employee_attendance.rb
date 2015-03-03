# EmployeeAttendance
class EmployeeAttendance < ActiveRecord::Base
  include Activity
  belongs_to :employee
  belongs_to :employee_leave_type
  belongs_to :EmployeeDepartment

  validates :employee_leave_type_id, presence: true
  validates :reason, presence: true, length: \
   { minimum: 1, maximum: 50 }, format: \
   { with: /\A[a-z A-Z 0-9]+\z/, message: 'only allows letters' }
  scope :shod, ->(id) { where(id: id).take }
  # find employee attendences where leave type is as we pass in parameter
  scope :dest_leave, ->(leave) { where(employee_leave_type_id: leave.id) }

  # destroy employee attendences
  def self.destroy_leave(a, l, lc)
    if a.blank?
      l.destroy
      lc.each(&:destroy)
    end
  end

  # if EmployeeAttendences save the leave is add for
  # that employee in EmployeeLeave
  def create_att(att)
    if att.save
      emp_leave = EmployeeLeave.edit_att(att)
      unless  emp_leave.nil?
        if att.is_half_day
          leave_taken = emp_leave.leave_taken.to_f + (0.5)
          emp_leave.update(leave_taken: leave_taken)
        else
          leave_taken = emp_leave.leave_taken.to_f + (1)
          emp_leave.update(leave_taken: leave_taken)
        end
      end
    end
  end

  def report(emp, lt)
    lt.each do |l|
      leave_count = EmployeeAttendance.where(employee_id: emp.id, \
                                             employee_leave_type_id: l.id).size
    end
  end

  # get max_leave_count from employee leave type and and update leave count
  # of employee leave to max_leave_count
  def self.department_leave_reset(emp)
    emp.each do |c|
      leave_count = EmployeeLeave.where(employee_id: c)
      leave_count.each do |e|
        leave_type = EmployeeLeaveType.find_by_id(e.employee_leave_type_id)
        default_leave_count = leave_type.max_leave_count
        available_leave = default_leave_count.to_f
        leave_taken = 0
        e.update(leave_taken: leave_taken, leave_count: available_leave)
      end
    end
  end
end
