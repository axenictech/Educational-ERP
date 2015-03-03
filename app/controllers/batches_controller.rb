# Batches Controller
class BatchesController < ApplicationController
  before_filter :find_batch, only: \
  [:display, :edit, :update, :delete, :assign_employee, :remove_employee]

  # get all courses from database,and perform authorization
  def index
    @courses ||= Course.all
    authorize! :read, @courses.first
  end

  # find course which we selected
  # and build asoociation of course and batch
  # and perform authorization
  def new
    @course = Course.shod(params[:course_id])
    @batch = @course.batches.build
    authorize! :create, @batch
  end

  # create batch object and pass required parameters
  # from private method postparam and
  # create action is saving our new Batch to the database.
  def create
    @course = Course.shod(params[:course_id])
    @batch = @course.batches.new(postparam)
    if @batch.save
      flash[:notice] = t('batch_create')
      redirect_to course_path(@course)
    else
      render 'new'
    end
  end

  # find batch which we selected, find all students in that batch
  # and perform authorization
  def display
    @batch = Batch.shod(params[:id])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  # find the course  which we selected and perform authorization
  def select
    @course = Course.shod(params[:course][:id])
    authorize! :read, @batch
  end

  # find Batch which we want to edit and pass it to update method
  # and perform authorization
  def edit
    authorize! :update, @batch
  end

  # upadate method update a Batch,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    if @batch.update(postparam)
      flash[:notice] = t('batch_update')
      redirect_to course_path(@batch.course)
    else
      render 'edit'
    end
  end

  # find Batch which we want to destroy,
  # destroy method deleting that Batch from the
  # database and perform authorization
  def destroy
    authorize! :delete, @batch
    @batch.destroy
    flash[:notice] = t('batch_delete')
    redirect_to course_path(@batch.course)
  end

  # find batch which we selected
  # get all department from database
  # and perform authorization
  def assign_tutor
    @batch = Batch.shod(params[:format])
    @departments = EmployeeDepartment.all
    authorize! :read, @batch
  end

  # this method is used to assign employee to perticular batch
  # first find batch and department then call instance method assign employee
  # on department instance ,this method display employee and
  def assign_tutorial
    @batch = Batch.shod(params[:format])
    @department = EmployeeDepartment.shod(params[:assign_tutor][:id])
    @employees ||= @department.assign_employee(@batch)
    @assign_employees ||= @department.ass_emp(@batch)
    authorize! :read, @batch
  end

  # this method is used for assign employees to batches
  # first find employee and call instance method assign on employee instance,
  # this method contain logic for assign selected employee  selectd batch
  def assign_employee
    @employee = Employee.shod(params[:format])
    @assign_employees ||= @employee.assign(@batch, params[:format])
    @department = @employee.employee_department
    @employees ||= @department.assign_employee(@batch)
    authorize! :read, @batch
  end

  # this method is used for remove employees from batches
  # first find employee and call instance method remove on employee instance,
  # this method contain logic for assign selected employee  selectd batch
  def remove_employee
    @employee = Employee.shod(params[:format])
    @assign_employees ||= @employee.remove(@batch, params[:format])
    @department = @employee.employee_department
    @employees ||= @department.assign_employee(@batch)
    authorize! :read, @batch
  end

  private

  # find batch which we selected
  def find_batch
    @batch = Batch.shod(params[:id])
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def postparam
    params.require(:batch).permit!
  end
end
