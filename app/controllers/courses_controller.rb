# Course Controller
class CoursesController < ApplicationController
  before_filter :find_course, only: \
  [:show, :grouped_batches, :assign_all, :remove_all, :edit, :update, :destroy]

  # Get all Courses from database, and perform authorization
  def index
    @courses ||= Course.all
    authorize! :read, @courses.first
  end

  # create new object of Course and Batch, make association
  # between course and batch,and perform authorization
  def new
    @course = Course.new
    @batch = Batch.new
    @course.batches.build
    authorize! :create, @course
  end

  # create Course object and pass required parameters
  # from private method postparam and
  # create action is saving our new Course to the database.
  def create
    @course = Course.new(postparam)
    if @course.save
      flash[:notice] = t('course_created')
      redirect_to courses_path
    else
      render 'new'
    end
  end

  # find all batches from database
  # and perform authorization
  def show
    @batch = @course.batches.shod(params[:id])
    @batches ||= @course.batches.includes(:course)
    authorize! :read, @course
  end

  # find all batches of selected course,
  # find all batch_groups of that course,
  # create new BatchGroup object,
  # and perform authorization
  def grouped_batches
    @batches ||= @course.batches
    @batch_groups ||= @course.batch_groups
    @batch_group = BatchGroup.new
    authorize! :create, @course
  end

  # find course which we selected
  def create_batch_group
    @course = Course.shod(params[:batch_group][:course_id])
    if params[:batches].present?
      create_batch_group2(params[:batch_group][:name], params[:batches])
    else
      create_batch_group3
    end
  end

  # create BatchGroup object and pass required parameters
  # create_batch_group2 action is saving our BatchGroup to the database.
  def create_batch_group2(name, batches)
    @batch_group = BatchGroup.new(name: name, course_id: @course.id)
    if @batch_group.save
      @batch_group.create_group_batch(batches, @batch_group)
      flash[:notice] = t('batch_group_created')
      redirect_to grouped_batches_course_path(@course)
    else
      render '/courses/grouped_batches'
    end
    @batch_groups ||= @course.batch_groups
  end

  # redirect to grouped_batches page
  def create_batch_group3
    flash[:alert] = t('batch_select')
    redirect_to grouped_batches_course_path(@course)
  end

  # find BatchGroup which we want to edit and pass it to update method
  # and perform authorization
  def edit_batch_group
    @batch_group = BatchGroup.shod(params[:id])
    @course = @batch_group.course
    @batches ||= @course.batches
    authorize! :update, @course
  end

  # upadate method update a BatchGroup,
  # and it accepts a hash containing the attributes that you want to update.
  def update_batch_group
    @batch_group = BatchGroup.shod(params[:batch_group][:batch_group_id])
    @batch_group.update(name: params[:batch_group][:name])
    @course = @batch_group.course
    flash[:notice] = t('batch_group_updated')
  end

  # find BatchGroup which we want to destroy,
  # delete_batch_group method deleting that Course from the
  # database and perform authorization
  def delete_batch_group
    @batch_group = BatchGroup.shod(params[:id])
    authorize! :delete, @batch_group
    @batch_group.destroy
    flash[:notice] = t('batch_group_deleted')
    redirect_to grouped_batches_course_path(@batch_group.course)
  end

  # get all batches of that course
  # this method is use for select all batches in one click
  # and perform authorization
  def assign_all
    @batches ||= @course.batches
    authorize! :read, @course
  end

  # get all batches of that course
  # this method is use for deselect all batches in one click
  # and perform authorization
  def remove_all
    @batches ||= @course.batches
    authorize! :read, @course
  end

  # find Course which we want to destroy,
  # destroy method deleting that Course from the
  # database and perform authorization
  def destroy
    authorize! :delete, @course
    @course.destroy
    flash[:notice] = t('course_deleted')
    redirect_to courses_path
  end

  # find Course which we want to edit and pass it to update method
  # and perform authorization
  def edit
    authorize! :update, @course
  end

  # upadate method update a Course,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    @course.update(postparam)
    @courses ||= Course.all
    flash[:notice] = t('course_updated')
  end

  private

  # find the course
  def find_course
    @course = Course.shod(params[:id])
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def postparam
    params.require(:course).permit(:course_name, :section_name, :code, :grading_type, batches_attributes: [:name, :start_date, :end_date])
  end
end
