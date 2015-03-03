# EmployeeAttendancesController
class EmployeeAttendancesController < ApplicationController
  # check EmplyeeLeaveType active or inactive
  def checkstatus
    @active_leaves = EmployeeLeaveType.status
    @inactive_leaves = EmployeeLeaveType.nostatus
  end

  # get beginning of month and end of month
  def date_operation
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
  end

  # create leave type object,and perform authorization
  def new_leave_type
    @new_leave_type = EmployeeLeaveType.new
    @employee ||= Employee.all
    checkstatus
    authorize! :create, @new_leave_type
  end

  # create employee leave type object and pass required parameters
  # from private method params_leave and
  # create action is saving our new employee leave type to the database.
  def	add_leave_type
    @new_leave_type = EmployeeLeaveType.new
    @new_leave_type1 = EmployeeLeaveType.new(params_leave)
    @employee ||= Employee.all
    if @new_leave_type1.save
      @new_leave_type1.add_leave(@new_leave_type1, @employee)
      flash[:notice] = 'Employee Leave type created successfully!'
    end
    checkstatus
  end

  # find employee leavetype which we want to destroy,
  # destroy method deleting that leave type from the
  # database and perform authorization
  def destroy_leave_type
    authorize! :delete, @new_leave_type
    @new_leave_type = EmployeeLeaveType.new
    @leave_type = EmployeeLeaveType.find(params[:id])
    @attendance = EmployeeAttendance.dest_leave(@leave_type)
    @leave_count = EmployeeLeave.dest_leave(@leave_type)
    EmployeeAttendance.destroy_leave(@attendance, @leave_type, @leave_count)
    flash[:notice] = 'Leave type deleted succesfully'
    checkstatus
    redirect_to dashboard_home_index_path
  end

  # find leave type which we want to edit and pass it to update_leave_type
  # method and perform authorization
  def edit_leave_type
    @edit_leave_type = EmployeeLeaveType.find(params[:id])
    authorize! :update, @edit_leave_type
  end

  # upadate method update a leave type,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update_leave_type
    params.permit!
    @new_leave_type = EmployeeLeaveType.new
    @leave_type = EmployeeLeaveType.find(params[:id])
    @leave_count = EmployeeLeave.dest_leave(@leave_type)
    @leave_type.up(@leave_type, @leave_count, params[:employee_leave_type])
    flash[:notice] = 'Employee Leave type updated successfully!'
    checkstatus
  end

  # get all EmployeeDeparment from database
  # and created employee leaves for the employee which we created
  # after the employee leave type,and perform authorization
  def attendence_register
    @deparments = EmployeeDepartment.all
    @emp = Employee.att_reg
    Employee.att_leave(@emp)
    authorize! :create, @leave
  end

  # find the selected department and all employees in that department
  # and perform authorization
  def select
    @deparment = EmployeeDepartment.find(params[:department][:id])
    @employees ||= @deparment.employees.all
    @today = Date.today
    date_operation
    authorize! :read, EmployeeAttendance
  end

  # display employee Attendance register for all months
  # and perform authorization
  def display
    @deparment = EmployeeDepartment.find(params[:id])
    @employees ||= @deparment.employees.all
    @today = params[:nextdate].to_date
    date_operation
    authorize! :read, EmployeeAttendance
  end

  # create EmployeeAttendance object and find the
  # employee and date for which we want to add leave
  # and perform authorization
  def new_attendance
    @attendance = EmployeeAttendance.new
    @employee = Employee.find(params[:id])
    @date = params[:attendance_date]
    @leave_types ||= EmployeeLeaveType.all
    authorize! :create, @attendance
  end

  # create EmployeeAttendance object and pass required parameters
  # from private method params_attendance,
  def create
    @attendance = EmployeeAttendance.new(params_attendance)
    @employee = Employee.find(params[:employee_attendance][:employee_id])
    @leave_types = EmployeeLeaveType.all
    @leave_count = EmployeeLeave.where(employee_id: @employee.id)
    @date = params[:employee_attendance][:attendance_date]
    create2
    date_operation
  end

  # create2 action is saving our new employee leave to
  # the database.
  def create2
    @leave_types = EmployeeLeaveType.all
    @leave_count = EmployeeLeave.where(employee_id: @employee.id)
    @attendance.create_att(@attendance)
    @deparment = @employee.employee_department
    @employees = @deparment.employees.all
    @today = @date.to_date
  end

  # find EmployeeAttendance which we want to edit and pass it to update_att
  # method and perform authorization
  def edit_attendance
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @reset_count = EmployeeLeave.edit_att(@attendance)
    authorize! :update, @attendance
  end

  # find EmployeeAttendance which we want to update and pass it to update_cal
  # method
  def update_att
    params.permit!
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @date = @attendance.attendance_date
    @reset_count = EmployeeLeave.edit_att(@attendance)
    update_cal
  end

  # upadate_cal method update a EmployeeAttendence,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update_cal
    p = params[:employee_attendance]
    @reset_count.update_attendance(@reset_count, @attendance, p)
    @deparment = @employee.employee_department
    @employees = @deparment.employees.all
    @today = @date.to_date
    date_operation
  end

  # find EmployeeAttendance which we want to destroy,
  # destroy method deleting that Attendence from the
  # database and perform authorization
  def destroy_attendance
    authorize! :destroy, @attendance
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @reset_count = EmployeeLeave.edit_att(@attendance)
    @reset_count.destroy_att(@reset_count, @attendance)
    @date = @attendance.attendance_date
    dest_att
  end

  # use to destroy employee attendence
  def dest_att
    @deparment = @employee.employee_department
    @employees = @deparment.employees.all
    @today = @date.to_date
    date_operation
  end

  # find all EmployeeDeparments from database
  # and perform authorization
  def attendance_report
    @deparments ||= EmployeeDepartment.all
    authorize! :read, EmployeeAttendance
  end

  # find EmployeeDeparment we selected and also find employee
  # leave type and related employee in that department
  # and perform authorization
  def select_report
    @deparment = EmployeeDepartment.find(params[:department][:id])
    @leave_types ||= EmployeeLeaveType.all
    @employees ||= @deparment.employees.all
    authorize! :read, EmployeeAttendance
  end

  # find Employees and employee leave type and all report to genretaed pdf
  def attendance_report_pdf
    @deparment = EmployeeDepartment.find(params[:id])
    @leave_types ||= EmployeeLeaveType.all
    @employees ||= @deparment.employees.all
    @general_setting = GeneralSetting.first
    render 'attendance_report_pdf', layout: false
  end

  # find employee we selected and find all EmployeeLeaveType of that
  # employee and display employee leave of that employee
  # and perform authorization
  def report_info
    @employee = Employee.find(params[:id])
    @attendance_report = EmployeeAttendance.find_by_employee_id(@employee.id)
    @leave_types ||= EmployeeLeaveType.all
    @leave_count = EmployeeLeave.where(employee_id: @employee)
    authorize! :create, @attendance_report
  end

  # get all Employee Leave from database and update its leave_count
  # to max_leave count of employeeLeaveType
  def update_employee_leave_reset_all
    @leave_count ||= EmployeeLeave.all
    f = EmployeeLeave.leave_reset(@leave_count)
    flash[:notice] = 'Leave count reset successful for all employees' if f == 1
  end

  # get all EmployeeDepartmentfrom database
  def employee_leave_reset_by_department
    @deparments ||= EmployeeDepartment.all
  end

  # find EmployeeDepartment which we selected and get all
  # employee in that department
  def select_department
    @deparments = EmployeeDepartment.find(params[:department][:id])
    @employees ||= @deparments.employees.all
  end

  # find EmployeeDepartment which we selected and get all
  # employee in that department
  # use for select all employee in one click
  def assign_all
    @department = EmployeeDepartment.find(params[:format])
    @employees ||= @department.employees.all
  end

  # find EmployeeDepartment which we selected and get all
  # employee in that department
  # use for deselect all employee in one click
  def remove_all
    @department = EmployeeDepartment.find(params[:format])
    @employees ||= @department.employees.all
  end

  # get all Employee we selected from database and update its leave_count
  # to max_leave count of employeeLeaveType
  def update_department_leave_reset
    EmployeeAttendance.department_leave_reset(params[:employees])
    redirect_to employee_leave_reset_by_department_employee_attendances_path
    flash[:notice] = 'Department Wise Leave Reset Successfull'
  end

  # search employee for Reset Employee Leave for that employee
  # and perform authorization
  def search_emp
    @employee = Employee.search2(params[:advance_search], params[:search])
    authorize! :read, Employee
  end

  # find employee which we selected
  def employee_leave_detail
    @employee = Employee.find_by_id(params[:id])
    @leave_count = EmployeeLeave.leave_detail(@employee)
  end

  # get Employee we selected from database and update its leave_count
  # to max_leave count of employeeLeaveType
  def employee_wise_leave_reset
    @employee = Employee.find_by_id(params[:id])
    @employee.leave_reset(@employee)
    redirect_to employee_leave_detail_employee_attendance_path
  end

  private

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def params_leave
    params.require(:employee_leave_type).permit!
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def params_attendance
    params.require(:employee_attendance).permit!
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def params_leave_taken
    params.require(:employee_leave).permit!
  end
end
