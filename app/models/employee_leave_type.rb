# EmployeeLeaveType
class EmployeeLeaveType < ActiveRecord::Base
  include Activity
  validates :name, presence: true, length: \
   { minimum: 1, maximum: 50 }, format: { with: /\A[a-zA-Z_" "-]+\Z/ }
  validates :code, presence: true, uniqueness: true, length: \
  { in: 1..10 }, format: { with: /\A[a-zA-Z0-9_" "-\/]+\Z/ }
  validates :max_leave_count, numericality: \
  { only_integer: true, greater_than: 1 }, length: { minimum: 1, maximum: 10 }
  scope :shod, ->(id) { where(id: id).take }
  scope :status, -> { where(status: true).order(:name) }
  scope :nostatus, -> { where(status: false).order(:name) }
  scope :dest_leave, ->(leave) { where(employee_leave_type_id: leave.id) }

  # when we create employee leave type we also create
  # that leave for all empoyee and save in EmployeeLeave database
  def add_leave(new_leave, emp)
    emp.each do |e|
      EmployeeLeave.create(employee_id: e.id, employee_leave_type_id: new_leave.id, leave_count: new_leave.max_leave_count)
    end
  end
  # update all employee leave associated with selected employee leave type
  def up(l, lc, param)
    return if l.update(param)
    lc.each do |la|
      la.update(leave_count: l.max_leave_count)
    end
  end

  def self.leave_type(att)
    find_by_id(att.employee_leave_type_id)
  end
end
