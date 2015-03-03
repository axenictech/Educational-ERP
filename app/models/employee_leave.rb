# EmployeeLeave
class EmployeeLeave < ActiveRecord::Base
  include Activity
  belongs_to :employee_leave_type
  belongs_to :employee
  scope :shod, ->(id) { where(id: id).take }
  # find employee leave where leave type is as we pass in parameter
  scope :dest_leave, ->(leave) { where(employee_leave_type_id: leave.id) }
  # find employee from employee leave
  scope :leave_detail, ->(emp) { where(employee_id: emp.id) }

  def self.leave(new_leave, e)
    create(employee_id: e.id, employee_leave_type_id: new_leave.id, \
           leave_count: new_leave.max_leave_count)
  end

  # find EmployeeLeave
  def self.edit_att(att)
    find_by_employee_id_and_employee_leave_type_id(att.employee_id,\
                                                   att.employee_leave_type_id)
  end

  # update_attendance update EmployeeAttendence
  def update_attendance(count, att, p)
    unless count.nil?
      leaves_taken = count.leave_taken
      day_status = att.is_half_day
      leave_type = EmployeeLeaveType.leave_type(att)
    end
    if att.is_half_day
      half_day = true
    else
      half_day = false
    end
    if att.update(p)
      unless leave_type.nil?
        if att.employee_leave_type_id == leave_type.id
          unless day_status == att.is_half_day
            if half_day
              leave = leaves_taken.to_f + (0.5)
            else
              leave = leaves_taken.to_f - (0.5)
            end
            count.update(leave_taken: leave)
          end
        else
          if half_day
            leave = leaves_taken.to_f - (0.5)
          else
            leave = leaves_taken.to_f - (1.0)
          end
          count.update(leave_taken: leave)
          @new_reset_count = EmployeeLeave.find_by_employee_id_and_employee_leave_type_id(att.employee_id, att.employee_leave_type_id)
          leaves_taken = @new_reset_count.leave_taken
          if att.is_half_day
            leave = leaves_taken.to_f + (0.5)
            @new_reset_count.update(leave_taken: leave)
          else
            leave = leaves_taken.to_f + (1)
            @new_reset_count.update(leave_taken: leave)
         end
      end
    end
  end
  end

  # find EmployeeAttendance and EmployeeLeave related to that
  # employee which we want to destroy,
  # destroy_att method deleting that Attendence from the database
  def destroy_att(rc, att)
    unless  rc.nil?
      if rc.leave_taken != 0
        leaves_taken = rc.leave_taken
        unless leaves_taken.nil?
          if att.is_half_day
            leave = leaves_taken.to_d - (0.5)
          else
            leave = leaves_taken.to_d - (1)
          end
        end

      end
    end
    att.destroy
    unless  rc.nil?
      rc.update(leave_taken: leave)
    end
  end

  # get max_leave_count from employee leave type and and update leave count
  # of employee leave to max_leave_count
  def self.leave_reset(leave)
    flag = 0
    leave.each do |e|
      leave_type = EmployeeLeaveType.find_by_id(e.employee_leave_type_id)
      next if leave_type.nil?
      default_leave_count = leave_type.max_leave_count
      available_leave = default_leave_count.to_f
      leave_taken = 0
      if e.update(leave_taken: leave_taken, leave_count: available_leave, \
                  reset_date: Date.today)
        flag = 1
      end
    end
    flag
  end
end
