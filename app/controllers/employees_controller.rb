# employee controller perform all operation of employee such
# as employee creation ,payslip,subject allocation and so on...
class EmployeesController < ApplicationController
  # These call backs used for code optimization once we write
  # callback as before filter it automatically all private methods
  # in to calling method,call backs generally used for code reusability

  before_filter :grade, only: \
  [:edit_grade, :update_grade, :destroy_grade]
  before_filter :category, only:
  [:edit_category, :update_category, :destroy_category]
  before_filter :department, only: \
  [:edit_department, :update_department, :destroy_department]
  before_filter :position, only: \
  [:edit_position, :update_position, :destroy_position]
  before_filter :bank_fields, only: \
  [:edit_bank_field, :update_bank_field, :destroy_bank_field]

  # employee setting generally used for getting all information
  # of employee such as grade,position,department,bank details..
  def settings
    authorize! :create, @employee
  end

  # check employee category is active or inactive
  # we can add employee category
  def emp_category
    @categories1 ||= EmployeeCategory.is_status
    @categories2 ||= EmployeeCategory.not_status
  end

  # check employee department category is active or inactive
  def emp_department
    @departments1 ||= EmployeeDepartment.is_status
    @departments2 ||= EmployeeDepartment.not_status
  end

  # check employee position is active or inactive
  def emp_position
    @positions1 ||= EmployeePosition.is_status
    @positions2 ||= EmployeePosition.not_status
  end

  # check employee bank field is active or inactive
  def bank_field
    @bank_fields1 ||= BankField.is_status
    @bank_fields2 ||= BankField.not_status
  end

  # check employee payroll category is active or inactive
  def pay_category
    @payroll_categories1 ||= PayrollCategory.not_deduction
    @payroll_categories2 ||= PayrollCategory.is_deduction
  end

  # check employee grade is active or inactive
  def emp_grade
    @grade1 ||= EmployeeGrade.is_status
    @grade2 ||= EmployeeGrade.not_status
  end

  # add new employee category here,create new
  # instance of EmployeeCategory,perform authorization
  def new_category
    @employee_category_new = EmployeeCategory.new
    emp_category
    authorize! :create, @employee_category_new
  end

  # create employee category and pass required params
  # from private method and save employee category
  def add_category
    @employee_category_new = EmployeeCategory.new
    @employee_category = EmployeeCategory.new(category_params)
    flash[:notice] = t('emp_category') if @employee_category.save
    emp_category
  end

  # edit employee category,first find category which to be edit
  # and transfer controll to update_category method and perform authorization
  def edit_category
    authorize! :create, @employee_category
  end

  # update employee category,first find category which to be update
  # call update method on instance of employee category
  def update_category
    @employee_category_new = EmployeeCategory.new
    flash[:notice] = t('emp_update_category') if \
    @employee_category.update(category_params)
    emp_category
  end

  # destroy employee category,first find category which to be destroy
  # call destroy method on instance of employee category
  def destroy_category
    authorize! :delete, @employee_category
    @employee_category_new = EmployeeCategory.new
    flash[:notice] = t('emp_delete_category') if @employee_category.destroy
    redirect_to dashboard_home_index_path
    emp_category
  end

  # add new employee department here,create new
  # instance of EmployeeDepartment,perform authorization
  def new_department
    @employee_department_new = EmployeeDepartment.new
    emp_department
    authorize! :create, @employee_department_new
  end

  # create employee department and pass required params
  # from private method and save employee department
  def add_department
    @employee_department_new = EmployeeDepartment.new
    @employee_department = EmployeeDepartment.new(department_params)
    flash[:notice] = t('add_emp_dept') if @employee_department.save
    emp_department
  end

  # edit employee department,first find department which to be edit
  # and transfer controll to update_category method and perform authorization
  def edit_department
    authorize! :update, @employee_department
  end

  # update employee departement,first find department which to be update
  # call update method on instance of employee departemnt
  def update_department
    @employee_department_new = EmployeeDepartment.new
    flash[:notice] = 'update_dept' if \
    @employee_department.update(department_params)
    emp_department
  end

  # destroy employee department,first find department which to be destroy
  # call destroy method on instance of employee department
  def destroy_department
    authorize! :delete, @employee_department
    @employee_department_new = EmployeeDepartment.new
    flash[:notice] = t('destroy_dept') if @employee_department.destroy
    redirect_to dashboard_home_index_path
    emp_department
  end

  # add new employee position here,create new
  # instance of Employee position,perform authorization
  def new_position
    @employee_position_new = EmployeePosition.new
    emp_position
    authorize! :create, @employee_position_new
  end

  # create employee position instance and pass required params
  # from private method and save employee position
  def add_position
    @employee_position_new = EmployeePosition.new
    @employee_position = EmployeePosition.new(position_params)
    flash[:notice] = t('add_pos') if @employee_position.save
    emp_position
  end

  # edit employee position,first find position which to be edit
  # and transfer controll to update_position method and perform authorization
  def edit_position
    authorize! :update, @employee_position
  end

  # update employee departement,first find department which to be update
  # call update method on instance of employee departemnt
  def update_position
    @employee_position_new = EmployeePosition.new
    flash[:notice] = t('up_pos') if @employee_position.update(position_params)
    emp_position
  end

  # destroy employee position,first find department which to be destroy
  # call destroy method on instance of employee position
  def destroy_position
    authorize! :delete, @employee_position
    @employee_position_new = EmployeePosition.new
    flash[:notice] = t('dest_pos') if @employee_position.destroy
    redirect_to dashboard_home_index_path
    emp_position
  end

  # add new employee bank field here,create new
  # instance of Employee bank field ,perform authorization
  def new_bank_field
    @bank_field_new = BankField.new
    bank_field
    authorize! :create, @bank_field_new
  end

  # create employee bank field instance and pass required params
  # from private method and save employee position
  def add_bank_field
    @bank_field_new = BankField.new
    @bank_field = BankField.new(bank_field_params)
    flash[:notice] = 'Bank field created Successfully' if @bank_field.save
    bank_field
  end

  # edit employee bank field,first find bank field which to be edit
  # and transfer controll to update_bank_field method and perform authorization
  def edit_bank_field
    authorize! :update, @bank_field
  end

  # update employee bank field,first find department which to be update
  # call update method on instance of employee departemnt
  def update_bank_field
    @bank_field_new = BankField.new
    flash[:notice] = t('up_bank') if @bank_field.update(bank_field_params)
    bank_field
  end

  # destroy employee position,first find department which to be destroy
  # call destroy method on instance of employee bank field
  def destroy_bank_field
    authorize! :delete, @bank_field
    @bank_field_new = BankField.new
    flash[:notice] = 'Bank field deleted Successfully' if @bank_field.destroy
    redirect_to dashboard_home_index_path
    bank_field
  end

  # add new payroll category field here,create new
  # instance of payroll category ,perform authorization
  def new_payroll_category
    @payroll_category_new = PayrollCategory.new
    pay_category
    authorize! :create, @payroll_category_new
  end

  # create payroll category instance and pass required params
  # from private method and save payroll category
  def add_payroll_category
    @payroll_category_new = PayrollCategory.new
    @payroll_category = PayrollCategory.new(payroll_category_params)
    flash[:notice] = t('add_pay') if @payroll_category.save
    pay_category
  end

  # edit payroll category,first find payroll category which to be edit
  # and transfer controll to update_payroll category method
  # and perform authorization
  def edit_payroll_category
    @payroll_category = PayrollCategory.shod(params[:id])
    authorize! :update, @payroll_category
  end

  # update payroll category,first find payroll category which to be update
  # call update method on instance of payroll category
  def update_payroll_category
    @payroll_category_new = PayrollCategory.new
    @payroll_category = PayrollCategory.shod(params[:id])
    flash[:notice] = t('up_pay') if \
    @payroll_category.update(payroll_category_params)
    pay_category
  end

  # destroy payroll category,first find payroll category which to be destroy
  # call destroy method on instance of payroll category
  def destroy_payroll_category
    authorize! :delete, @payroll_category
    @payroll_category = PayrollCategory.shod(params[:id])
    @payroll_category_new = PayrollCategory.new
    flash[:notice] = t('dest_pay') if @payroll_category.destroy
    redirect_to dashboard_home_index_path
    pay_category
  end

  # this method for find active payroll category from PayrollCategory
  # create new instance of payroll category call proc active
  def active_payroll_category
    @payroll_category_new = PayrollCategory.new
    @payroll_category = PayrollCategory.shod(params[:id])
    @payroll_category.active
    pay_category
    authorize! :create, @payroll_category
  end

  # this method for find inactive payroll category from PayrollCategory
  # create new instance of payroll category and call proc inactive
  def inactive_payroll_category
    @payroll_category_new = PayrollCategory.new
    @payroll_category = PayrollCategory.shod(params[:id])
    @payroll_category.inactive
    pay_category
    authorize! :create, @payroll_category
  end

  # add new employe grade field here,create new
  # instance of employee grade ,perform authorization call
  # emp grade method that contain active and inactive grade
  def new_grade
    @employee_grade_new = EmployeeGrade.new
    emp_grade
    authorize! :create, @employee_grade_new
  end

  # create employee grade instance and pass required params
  # from private method and save employee grade
  def add_grade
    @employee_grade_new = EmployeeGrade.new
    @employee_grade = EmployeeGrade.new(grade_params)
    flash[:notice] = t('emp_grade') if @employee_grade.save
    emp_grade
  end

  # edit EmployeeGrade,first find EmployeeGrade which to be edit
  # and transfer controll to update_grade  method
  # and perform authorization
  def edit_grade
    authorize! :update, @employee_grade
  end

  # update mployeeGrade,first find mployeeGrade which to be update
  # call update method on instance of mployeeGrade
  def update_grade
    @employee_grade_new = EmployeeGrade.new
    flash[:notice] = t('up_grade') if @employee_grade.update(grade_params)
    emp_grade
  end

  # destroy payroll category,first find payroll category which to be destroy
  # call destroy method on instance of payroll category
  def destroy_grade
    authorize! :delete, @employee_grade
    @employee_grade_new = EmployeeGrade.new
    flash[:notice] = t('dest_grade') if @employee_grade_new.destroy
    redirect_to dashboard_home_index_path
    emp_grade
  end

  # this method for employee admision ,create new instance of employee
  # create instance for all employee departments ,call instance method emp_no
  # that caluclate admission no of employee ,perform authorization
  def admission1
    @employee = Employee.new
    @empdept = EmployeeDepartment.all
    @date = Date.today.strftime('%Y%m%d')
    @employee.emp_no
    authorize! :create, @employee
  end

  # create method used for create new employee,
  # create new instance of employee and pass hash as an require argument
  # using private method and call save method on instance of employee
  # if employee save then redirect to admission2 page or render same page again
  def create
    @empdept = EmployeeDepartment.all
    @employee = Employee.new(employee_params)
    if @employee.save
      flash[:notice] = "Employee details added for #{@employee.first_name}"
      redirect_to admission2_employees_path(@employee)
    else
      render 'admission1'
    end
  end

  # display admission2 page  for same employee
  def admission2
    @employee = Employee.shod(params[:format])
    authorize! :update, @employee
  end

  # this method used for update employee information ,
  # find employee from params of id  and pass hash as an require argument
  # to update method using private method and call update method on instance of employee
  # if employee save then redirect to admission3 page or render same page again
  def admission2_create
    @employee = Employee.shod(params[:format])
    if @employee.update(employee_params)
      flash[:notice] = "Additional details added for #{@employee.first_name}"
      redirect_to admission3_employees_path(@employee)
    else
      render 'admission2'
    end
    authorize! :update, @employee
  end

  # this method used for
  def admission3
    @employee = Employee.shod(params[:format])
    @bank_fields ||= BankField.all
    authorize! :update, @employee
  end

  # This method used for create employee information of bank field,
  # find employee from params of id and call class method bankdetails and pass
  # employee and bank details as an argument
  # redirect to edit privileges and perform athorization

  def admission3_create
    @employee = Employee.find(params[:format])
    @bank_fields ||= BankField.all
    if request.post?
      EmployeeBankDetail.bankdetails(@employee, params[:bank_details])
    end
    redirect_to edit_privilege_employees_path(@employee)
    authorize! :update, @employee
  end

  # This method used for display all privileges ,find
  # employee whose privileges to set and perform authorization
  def edit_privilege
    @employee = Employee.shod(params[:format])
    @privilege_tags ||= PrivilegeTag.all
    authorize! :update, @employee
  end

  # This method is used for update employee privileges
  # find employee whose privileges to set, then find user for appropriate
  # employee and call instance method privilege_update ,this method contain
  # logic for set privilege to user
  def update_privilege
    @employee = Employee.shod(params[:format])
    @user = User.find_by_employee_id("#{@employee.id}")
    privilege_tag = params[:privilege]
    PrivilegeUser.privilege_update(privilege_tag, @user)
    redirect_to admission4_employees_path(@employee)
  end

  # this merhod used for select reporting manager
  def admission4
    @employee = Employee.shod(params[:format])
    authorize! :update, @employee
  end

  # This method is used to search reporting manager from various criteria
  # by calling class method search2 ,search2 method contain logic for searching
  def search
    @employee = Employee.shod(params[:format])
    @reporting_man ||= Employee.search2(params[:advance_search]\
      , params[:search])
    authorize! :read, @employee
  end

  # this method is used for update reporting manager name
  def update_reporting_manager_name
    @employee = Employee.shod(params[:id])
    @reporting_manager = Employee.shod(params[:reporting_manager_id])
    authorize! :update, @employee
  end

  # this method is used for update reporting manager
  # by calling update method on instannce of employee and
  # pass hash as argument to be updated
  def update_reporting_manager
    @employee = Employee.shod(params[:id])
    @employee.update(employee_params)
    redirect_to profile_employees_path(@employee)
  end

  # This method is used for change and update reporting manager
  # find reporting manager from employee and transfer to the
  # update reporting manager
  def change_reporting_manager
    @employee = Employee.shod(params[:format])
    @reporting_manager = Employee.shod(@employee\
    .reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
    authorize! :update, @employee
  end

  # This method is used for display profile of employee
  # display all information of employee containing reporting manager
  def profile
    @employee = Employee.shod(params[:format])
    @reporting_manager = Employee.shod(@employee\
    .reporting_manager_id).first_name unless @employee.reporting_manager_id.nil?
    authorize! :read, @employee
  end

  # edit employee profile,first find employee which to be edit
  # and transfer controll to update_profile method and perform authorization
  def edit_profile
    @employee = Employee.shod(params[:format])
    authorize! :read, @employee
  end

  # update employee profile ,first find employee which record to be update
  # and transfer controll to profile page
  def update_profile
    @employee = Employee.shod(params[:format])
    if @employee.update(employee_params)
      redirect_to profile_employees_path(@employee)
    else
      render 'edit_profile'
    end
  end

  # update employee profile ,first find employee which record to be update
  # and transfer controll to profile page
  def update_edit_profile
    @employee = Employee.shod(params[:format])
    if @employee.update(employee_params)
      redirect_to profile_employees_path(@employee)
      flash[:notice] = t('Personal_details') + ' ' + @employee.first_name
    else
      render 'edit_personal_profile'
    end
  end

  # update employee address profile ,first find employee which
  # record to be update and transfer controll to profile page
  def  update_edit_address_profile
    @employee = Employee.shod(params[:format])
    if @employee.update(employee_params)
      redirect_to profile_employees_path(@employee)
      flash[:notice] = t('Address_details') + ' ' + @employee.first_name
    else
      render 'edit_address_profile'
    end
  end

  # update employee contact profile ,first find employee which
  # record to be update and transfer controll to profile page
  def  update_edit_contact_profile
    @employee = Employee.shod(params[:format])
    if @employee.update(employee_params)
      redirect_to profile_employees_path(@employee)
      flash[:notice] = t('Contact_details') + ' ' + @employee.first_name
    else
      render 'edit_contact_profile'
    end
  end

  # This method is used for subject assignment,
  # list all batches including courses
  def subject_assignment
    @batches = Batch.includes(:course).all
  end

  # This method is used for assigning subject,
  # list all subject on selected batch
  def assign_subject
    @batch = Batch.shod(params[:subject_assignment][:id])
    @subject = @batch.subjects.all
  end

  # this method is used for display assigned subject
  def assign_subject_disp
    @subject = Subject.shod(params[:subject_assignment][:subject_id])
  end

  # this method is used to display all employees list for selected department
  # find the assigned employees from employeesubject by
  # calling scope assign emp
  def list_emp
    @department = EmployeeDepartment.shod(params[:subject_assignment][:id])
    @employees = @department.employees.all
    @subject = Subject.shod(params[:format])
    @assigned_employees = EmployeeSubject.assign_emp(@subject)
  end

  # This method used for assign employees to perticular subject
  # find all employees of perticular department
  # find out subject, call assign method that contain logic
  # assign employee to subject
  def assign_employee
    @department = EmployeeDepartment.shod(params[:department_id])
    @employee = Employee.shod(params[:id])
    @employees = @department.employees.all
    @subject = Subject.shod(params[:format])
    assign
    authorize! :update, @employee
  end

  # this method is used to diplay list of all assigned employees
  def assign
    @assigned_employee = EmployeeSubject.ass_emp(@employee, @subject)
    @assigned_employees = EmployeeSubject.ass_emp1(@subject)
  end

  # this method is used for remove employee assignment to subject
  # list employees of selected  department and subject, select
  # employee to remove and call remove_employee2 method
  def remove_employee
    @department = EmployeeDepartment.shod(params[:department_id])
    @employee = Employee.shod(params[:id])
    @subject = Subject.shod(params[:format])
    remove_employee2
    authorize! :read, @employee
  end

  # find out all employee of selected departments,
  # find out assigned employees and call instance method dest that
  # remove employee from asssigned employees list
  def remove_employee2
    @employees = @department.employees.all
    @assigned_employee = EmployeeSubject.rem_emp(@employee, @subject)
    @assigned_employee.dest(@employee, @subject)
    @assigned_employees = EmployeeSubject.rem_emp2(@subject)
  end

  # This method is used for search employee,
  # hold the list of all department
  def search_employee
    @department ||= EmployeeDepartment.all
  end

  # This method is used for search employee on various criteria
  # by calling class method on search2
  def search_emp
    @employee = Employee.search2(params[:advance_search], params[:search])
    authorize! :read, Employee
  end

  # this method display all employee of selectd department
  def allemp
    @department = EmployeeDepartment.shod(params[:viewall][:id])
    @employees ||= @department.employees.all
  end

  # This method is used for search employee on more number criteria
  # by calling two class method on employee adv_search and adv_search2
  def advance_search_emp
    @employees = Employee.adv_search(params[:search])
    @search = Employee.adv_search2(params[:search])
    authorize! :read, @employee
  end

  # This method is used for make pdf of advance search result,
  # find employee whose pdf to display,
  # for displaying pdf use pdf format and render advance
  # search result page again
  def advance_search_result_pdf
    @employees = params[:employees]
    @search = params[:search]
    @general_setting = GeneralSetting.first
    render 'advance_search_result_pdf', layout: false
  end

  # This method used for getting list of all employee department
  def select_employee_department
    @department ||= EmployeeDepartment.all
  end

  # this method hold the list of all employees of selectd department
  def department_employee_list
    @department = EmployeeDepartment.shod(params[:select_department][:id])
    @employees ||= @department.employees.all
  end

  # This method used for display monthly payslip categories,
  # first find employee whose payroll categories to be display,
  # then find all payroll categories belongs to that employee
  def monthly_payslip
    @employee = Employee.shod(params[:format])
    @independent_categories ||= PayrollCategory.all
    authorize! :update, @employee
  end

  # This method is used for payslip generation of all employees,then
  # hold list of all employees in single instance ,then hold
  # list of all employee whose salery slip already created and
  # call on instance method one click that contain logic for
  # payslip calculation
  def one_click_payslip_generate
    salary_date = params[:payslip][:joining_date].to_date
    @employees ||= Employee.all
    already_created = MonthlyPayslip.all.pluck(:employee_id)
    @employees.one_click(@employees, already_created, salary_date)
    one_click_pay(salary_date)
  end

  # this method is used in one click payslip generate
  # for redirecting to next page and perform authorization
  def one_click_pay(salary_date)
    redirect_to payslip_employees_path
    flash[:notice] = "#{t('one')}" + \
      ":#{salary_date.strftime('%B')}" + "#{t('one_click')}"
    authorize! :update, @employee
  end

  # payroll category method is used to find employee payroll
  # and perform authorization
  def payroll_category
    @employee = Employee.shod(params[:format])
    authorize! :update, @employee
  end

  # This method is used to calculate payslip of single employee,
  # first find employee whose payslip to be generate,
  # then find salery date of employee and call crate monthly payslip2 method
  def create_monthly_payslip
    @employee = Employee.shod(params[:format])
    @salary_date = Date.parse(params[:salery_slip][:salery_date])
    create_monthly_payslip2
    authorize! :update, @employee
  end

  # This method is used to caculate payslip caluculate
  #  salary date and joining date  ad then call instance method
  # create payslip that contan logic of claucation of paylip
  def create_monthly_payslip2
    unless @salary_date.to_date < @employee.joining_date.to_date
      flag = @employee.create_payslip(@employee, @salary_date)
      paysli(flag, @employee)
    end
    redirect_to monthly_payslip_employees_path(@employee)
  end

  # this method is used for display payslip generated or updated
  # on th basis of flag,flag calculation done in create payslip method
  def paysli(flag, employee)
    if flag == 0
      flash[:notice] = 'Payslip of ' + employee.first_name + "#{t('p')}"
    else
      flash[:notice] = 'Payslip of ' + employee.first_name + "#{t('paysli')}"
    end
  end

  # employee structure method is used to define and update salary payroll
  # of selected employee,get amount and payroll category of selectd employee
  # and call emp and update payroll method to update the payroll amount
  # on percentage of payroll category ,update payroll method  contain
  # auto update payroll logic
  def employee_structure
    @salary_date = params[:salery_date]
    @employee = Employee.find(params[:employee_id])
    @independent_categories = PayrollCategory.all
    @amount = params[:amount]
    @payroll_category = params[:id]
    @salary = Employee.emp(@employee, @payroll_category, @amount, @salary_date)
    @employee.update_payroll(@payroll_category, @amount, @salary_date)
    authorize! :update, @employee
  end

  # This method is used for create payslip category
  #  of individual employee , first find employee whose category to be create
  #  then get salary date and call class method create_category
  # and then call save method on created_category instance
  def create_payslip_category
    @employee = Employee.shod(params[:format])
    @salary_date = (params[:salary_date])
    @created_category = IndividualPayslipCategory\
                        .create_category(@employee, params[:payslip])
    @created_category.save
    redirect_to monthly_payslip_employees_path(@employee)
    authorize! :update, @employee
  end

  # This method used for select month and hold all
  # salary dates of monthly payslip
  def select_month
    @salary_dates = MonthlyPayslip.all
    @department = params[:view_payslip][:id]
  end

  def one_click_payslip_revert
    @salary_date = params[:payslip][:joining_date].to_date
    @b = MonthlyPayslip.where(salary_date: @salary_dates).pluck(:salary_date)
    one_click_payslip_revert2
    redirect_to employees_payslip_path
  end

  def one_click_payslip_revert2
    return if @b[0].present?
    return if @b[0] == @salary_date.strftime('%b')
    flash[:notice] = 'Payslip of ' + @employee.first_name + "#{t('pay')}"
  end

  # This method is used for display payslip,
  # find department and display all employees of selectd department
  # whose payslip to be display
  def view_payslip
    @salary_dates = MonthlyPayslip.all
    @department = EmployeeDepartment.shod(params[:format])
    @employees = @department.employees
  end

  # This method is used to display payslip profile by selecting
  # salary date and finding employee whose payslp profile to be display
  def view_payslip_profile
    @salary_dates = MonthlyPayslip.all
    @employee = Employee.find(params[:format])
  end

  # this method is used for display employee payslip
  # select the month and display all pyroll category amount of selectd
  # employee
  def view_employee_payslip
    @payslip = MonthlyPayslip.view(params[:salary_date], params[:employee_id])
    @independent_categories = PayrollCategory.all
  end

  # This method is used for display employee individual payslip pdf,
  #  find monthly payslip whose pdf to be displayed
  #  indepedant categories hold all payroll category and display amount
  #  for perticular category
  def employee_individual_payslip_pdf
    @general_setting = current_user.general_setting
    @payslip = MonthlyPayslip.shod(params[:payslip])
    @independent_categories = PayrollCategory.all
    render 'employee_individual_payslip_pdf', layout: false
  end

  # this method is used for displaying general profile,
  # find employee whose profile  to be displayed,
  # find reporting manager for selectd employee
  def genral_profile
    @employee = Employee.shod(params[:format])
    @reporting_manager = Employee.rep_man(@employee)
    authorize! :read, @employee
  end

  # this method used for display general profile of archived employee
  # find employee whose profile  to be displayed form ArchivedEmployee
  def genral_profile_archived
    @employee = ArchivedEmployee.shod(params[:format])
    authorize! :read, @employee
  end

  # this method used for display personal profile,
  # find employee whose profile  to be displayed
  def personal_profile
    @employee = Employee.shod(params[:format])
    @country = Country.per(@employee)
    authorize! :read, @employee
  end

  # this method used for display personal profile of archived employee,
  # then find employee whose profile to be displayed
  def personal_profile_archived
    @employee = ArchivedEmployee.shod(params[:format])
    @country = Country.per(@employee)
    authorize! :read, @employee
  end

  # this method used for display address profile of employee,
  # then find employee whose profile to be displayed and find home country
  # and office country from Country table
  def address_profile
    @employee = Employee.shod(params[:format])
    @home_country = Country.home_country(@employee)
    @office_country = Country.office_country(@employee)
    authorize! :read, @employee
  end

  # this method used for display address profile of archived employee,
  # then find employee whose profile to be displayed and find home country
  # and office country from Country table
  def address_profile_archived
    @employee = ArchivedEmployee.shod(params[:format])
    @home_country = Country.home_country(@employee)
    @office_country = Country.office_country(@employee)
    authorize! :read, @employee
  end

  # this method used for display contact profile of employee,
  # then find employee whose profile to be displayed
  def contact_profile
    @employee = Employee.shod(params[:format])
    authorize! :read, @employee
  end

  # this method used for display contact profile of archived employee,
  # then find employee whose profile to be displayed
  def contact_profile_archived
    @employee = ArchivedEmployee.shod(params[:format])
    authorize! :read, @employee
  end

  # this method is used for display bank info of employee,
  # then find employee whose bank info to be displayed
  def bank_info
    @employee = Employee.shod(params[:format])
    @bank_details = EmployeeBankDetail.bank_details(@employee)
    authorize! :read, @employee
  end

  # this method is used for display bank info of archived employee,
  # then find archived employee whose bank info to be displayed
  def bank_info_archived
    @employee = ArchivedEmployee.shod(params[:format])
    @bank_details = EmployeeBankDetail.bank_details(@employee)
    authorize! :read, @employee
  end

  # this method is used for find employee payroll of selected employe
  def emp_payroll
    @emp = Employee.shod(params[:format])
    @payslip = MonthlyPayslip.where(employee_id: @emp.id).take
    authorize! :read, @emp
  end

  # this method is used for find employee whome to be remove
  def remove
    @employee = Employee.shod(params[:format])
    authorize! :read, @employee
  end

  # this method is used for change employee to former employee
  def change_to_former
    @employee = Employee.shod(params[:format])
    authorize! :update, @employee
  end

  # this method is used for create archived employee,first
  # find the employee then destroy all subject belongs to that employee and
  # call method  create_archived_employee2
  def create_archived_employee
    @employee = Employee.shod(params[:format])
    return unless request.post?
    EmployeeSubject.destroy_all(employee_id: @employee.id)
    create_archived_employee2
  end

  # This method is used to create archived employee,first destroy employee
  # whome to be archived and then transfer it to ArchivedEmployee database
  def create_archived_employee2
    @archived_empsloyee = @employee.archived_employee
    @employee.destroy
    flash[:notice] = 'Employee' + "#{@employee.first_name}" + "#{t('archived')}"
    redirect_to archived_employee_profile_employees_path(@employee)
  end

  # This method is used for display archived employee profile,
  # first find the employee whose profile to be display
  def archived_employee_profile
    @employee = ArchivedEmployee.shod(params[:format])
    authorize! :read, @employee
  end

  # This method is used for destroy employee completly from database,
  # first find employee and call destroy on employee instance
  def delete_employee
    authorize! :delete, @employee
    @employee = Employee.shod(params[:format])
    @employee.destroy
    flash[:notice] = "#{t('all')}" + " #{@employee.first_name}" + "#{t('del')}"
    redirect_to @employee
  end

  # This method is used to display employee profile, first find
  # employee if employee is nil then find employee record in archived employee
  def employee_profile
    @employee = Employee.where(id: params[:employee_id]).take
    @employee = ArchivedEmployee.where(id: params[:employee_id]).take \
    if @employee.nil?
    @reporting_manager = Employee.report(@employee)
    @general_setting = GeneralSetting.first
    render 'employee_profile', layout: false
  end

  # This method is used to display employee profile pdf, first find
  # employee if employee is nil then find employee record in archived employee
  #  and render same page to display pdf
  def personal_profile_pdf
    @employee = Employee.where(id: params[:employee_id]).take
    @employee = ArchivedEmployee.where(id: params[:employee_id]).take\
    if @employee.nil?
    @country = Country.per(@employee)
    @general_setting = GeneralSetting.first
    render 'personal_profile_pdf', layout: false
  end

  # This method is used to display employee address profile pdf, first find
  # employee if employee is nil then find employee record in archived employee
  # then find out home country and office country from country database and
  # render same page to display pdf
  def address_profile_pdf
    @employee = Employee.where(id: params[:employee_id]).take
    @employee = ArchivedEmployee.where(id: params[:employee_id]).take \
    if @employee.nil?
    @home_country = Country.home_country(@employee)
    @office_country = Country.office_country(@employee)
    @general_setting = GeneralSetting.first
    render 'address_profile_pdf', layout: false
  end

  # This method is used to display employee contact profile pdf, first find
  # employee if employee is nil then find employee record in archived
  # employee and render same page to display pdf
  def contact_profile_pdf
    @employee = Employee.where(id: params[:employee_id]).take
    @employee = ArchivedEmployee.where(id: params[:employee_id]).take \
    if @employee.nil?
    @general_setting = GeneralSetting.first
    render 'contact_profile_pdf', layout: false
  end

  # This method is used to display bank info pdf, first find
  # employee if employee is nil then find employee record in archived
  # employee and render same page to display pdf
  def bank_info_pdf
    @employee = Employee.where(id: params[:employee_id]).take
    @employee = ArchivedEmployee.where(id: params[:employee_id]).take \
    if @employee.nil?
    @bank_details = EmployeeBankDetail.where(employee_id: @employee.id)
    @general_setting = GeneralSetting.first
    render 'bank_info_pdf', layout: false
  end

  # This method is used for search result pdf first find employee and
  # render same page again to diaplay pdf
  def emp_search_result_pdf
    @employees = params[:employees]
    @search = params[:search]
    render 'emp_search_result_pdf', layout: false
  end

  # This method is ued to edit employee personal profile
  def edit_personal_profile
    @employee = Employee.shod(params[:format])
    authorize! :read, @employee
  end

  # This method is ued to edit employee addres profile
  def edit_address_profile
    @employee = Employee.shod(params[:format])
    authorize! :read, @employee
  end

  # This method is ued to edit employee contact profile
  def edit_contact_profile
    @employee = Employee.shod(params[:format])
    authorize! :read, @employee
  end

  # This method is ued to edit employee bank field
  def edit_bank_info
    @employee = Employee.shod(params[:format])
    @bank_info ||= @employee.employee_bank_details.includes(:bank_field).all
    authorize! :read, @employee
  end

  # This method is ued to update employee bank deatails
  # call class method up on EmployeeBankdetail
  # that contain logic for update employee bank deatils and call
  # update bank details2
  def update_bank_details
    @employee = Employee.shod(params[:format])
    params[:banks].each_pair do |k, v|
      @bank_info = EmployeeBankDetail.up(@employee, k)
      @bank_info.update(bank_info: v[:bank_info])
    end
    update_bank_details2
    authorize! :read, @employee
  end

  # this method is used to just redirecting to employee profile
  def update_bank_details2
    redirect_to profile_employees_path(@employee)
    flash[:notice] = "#{t('bank')}" + " #{@employee.first_name}"
  end

  #  this method is used to hold payslip of selected employee
  def emp_payslip
    @salary_dates = MonthlyPayslip.all
    @emp = Employee.shod(params[:format])
    @payslip = MonthlyPayslip.where(employee_id: @emp.id).take
  end

  private

  def employee_params
    params.require(:employee).permit!
  end

  def category_params
    params.require(:employee_category).permit(:name, :prefix, :status)
  end

  def department_params
    params.require(:employee_department).permit!
  end

  def position_params
    params.require(:employee_position).permit!
  end

  def grade_params
    params.require(:employee_grade).permit!
  end

  def bank_field_params
    params.require(:bank_field).permit(:name, :status)
  end

  def payroll_category_params
    params.require(:payroll_category).permit!
  end

  def grade
    @employee_grade = EmployeeGrade.shod(params[:id])
  end

  def category
    @employee_category = EmployeeCategory.shod(params[:id])
  end

  def department
    @employee_department = EmployeeDepartment.shod(params[:id])
  end

  def position
    @employee_position = EmployeePosition.shod(params[:id])
  end

  def bank_fields
    @bank_field = BankField.shod(params[:id])
  end
end
