# EmployeeAttendancesController
class EmployeeAttendancesController < ApplicationController
  def checkstatus
    @active_leaves = EmployeeLeaveType.status
    @inactive_leaves = EmployeeLeaveType.nostatus
  end

  def date_operation
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
  end

  def new_leave_type
    @new_leave_type = EmployeeLeaveType.new
    @employee ||= Employee.all
    checkstatus
    authorize! :create, @new_leave_type
  end

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

  def edit_leave_type
    @edit_leave_type = EmployeeLeaveType.find(params[:id])
    authorize! :update, @edit_leave_type
  end

  def update_leave_type
    params.permit!
    @new_leave_type = EmployeeLeaveType.new
    @leave_type = EmployeeLeaveType.find(params[:id])
    @leave_count = EmployeeLeave.dest_leave(@leave_type)
    @leave_type.up(@leave_type, @leave_count, params[:employee_leave_type])
    flash[:notice] = 'Employee Leave type updated successfully!'
    checkstatus
  end

  def attendence_register
    @deparments = EmployeeDepartment.all
    @emp = Employee.att_reg
    Employee.att_leave(@emp)
    authorize! :create, @leave
  end

  def select
    @deparment = EmployeeDepartment.find(params[:department][:id])
    @employees ||= @deparment.employees.all
    @today = Date.today
    date_operation
    authorize! :read, EmployeeAttendance
  end

  def display
    @deparment = EmployeeDepartment.find(params[:id])
    @employees ||= @deparment.employees.all
    @today = params[:nextdate].to_date
    date_operation
    authorize! :read, EmployeeAttendance
  end

  def new_attendance 
    @attendance = EmployeeAttendance.new
    @employee = Employee.find(params[:id])
    @date = params[:attendance_date]
    @leave_types ||= EmployeeLeaveType.all
    authorize! :create, @attendance
  end

  def create
    @attendance = EmployeeAttendance.new(params_attendance)
    @employee = Employee.find(params[:employee_attendance][:employee_id])
    @leave_types=EmployeeLeaveType.all
    @leave_count=EmployeeLeave.where(employee_id: @employee.id)
    @date = params[:employee_attendance][:attendance_date]
    create2
    date_operation
  end

  def create2
     @leave_types=EmployeeLeaveType.all
     @leave_count=EmployeeLeave.where(employee_id: @employee.id)
     @attendance.create_att(@attendance)
     @deparment = @employee.employee_department
     @employees = @deparment.employees.all
     @today = @date.to_date
  end

  def edit_attendance
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @reset_count = EmployeeLeave.edit_att(@attendance)
    authorize! :update, @attendance
  end

  def update_att
    params.permit!
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @date = @attendance.attendance_date
    @reset_count = EmployeeLeave.edit_att(@attendance)
    update_cal
  end

  def update_cal
    p = params[:employee_attendance]
    @reset_count.update_attendance(@reset_count, @attendance, p)
    @deparment = @employee.employee_department
    @employees = @deparment.employees.all
    @today = @date.to_date
    date_operation
  end

  def destroy_attendance
    authorize! :destroy, @attendance
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @reset_count = EmployeeLeave.edit_att(@attendance)
    @reset_count.destroy_att(@reset_count, @attendance)
    @date = @attendance.attendance_date
    dest_att
  end

  def dest_att
    @deparment = @employee.employee_department
    @employees = @deparment.employees.all
    @today = @date.to_date
    date_operation
  end

  def attendance_report
    @deparments ||= EmployeeDepartment.all
    authorize! :read, EmployeeAttendance
  end

  def select_report
    @deparment = EmployeeDepartment.find(params[:department][:id])
    @leave_types ||= EmployeeLeaveType.all
    @employees ||= @deparment.employees.all
    authorize! :read, EmployeeAttendance
  end

  def attendance_report_pdf
    @deparment = EmployeeDepartment.find(params[:id])
    @leave_types ||= EmployeeLeaveType.all
    @employees ||= @deparment.employees.all
    @general_setting = GeneralSetting.first
    render 'attendance_report_pdf', layout: false
  end

  def report_info
    @employee = Employee.find(params[:id])
    @attendance_report = EmployeeAttendance.find_by_employee_id(@employee.id)
    @leave_types ||= EmployeeLeaveType.all
    @leave_count = EmployeeLeave.where(employee_id: @employee)
    authorize! :create, @attendance_report
  end

  def update_employee_leave_reset_all
    @leave_count ||= EmployeeLeave.all
    f = EmployeeLeave.leave_reset(@leave_count)
    flash[:notice] = 'Leave count reset successful for all employees' if f == 1
  end

  def employee_leave_reset_by_department
    @deparments ||= EmployeeDepartment.all
  end

  def select_department
    @deparments = EmployeeDepartment.find(params[:department][:id])
    @employees ||= @deparments.employees.all
  end

  def assign_all
    @department = EmployeeDepartment.find(params[:format])
    @employees ||= @department.employees.all
  end

  def remove_all
    @department = EmployeeDepartment.find(params[:format])
    @employees ||= @department.employees.all
  end

  def update_department_leave_reset
    EmployeeAttendance.department_leave_reset(params[:employees])
    redirect_to employee_leave_reset_by_department_employee_attendances_path
    flash[:notice] = 'Department Wise Leave Reset Successfull'
  end

  def search_emp
    @employee = Employee.search2(params[:advance_search], params[:search])
    authorize! :read, Employee
  end

  def employee_leave_detail
    @employee = Employee.find_by_id(params[:id])
    @leave_count = EmployeeLeave.leave_detail(@employee)
  end

  def employee_wise_leave_reset
    @employee = Employee.find_by_id(params[:id])
    @employee.leave_reset(@employee)
    redirect_to employee_leave_detail_employee_attendance_path
  end

  private

  def params_leave
    params.require(:employee_leave_type).permit!
  end

  def params_attendance
    params.require(:employee_attendance).permit!
  end

  def params_leave_taken
    params.require(:employee_leave).permit!
  end
end
