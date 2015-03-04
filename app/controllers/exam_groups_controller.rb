# ExamGroupsController perform the operation on exams
# like create exam, display exam schedule, manage student marks.
class ExamGroupsController < ApplicationController
  # This action display a starting page with drop down list of course.
  def index
    @courses ||= Course.all
  end

  # In this action @batches object is store the batchse list
  # for selected course.
  def select
    @course = Course.shod(params[:course][:id])
    @batches ||= @course.batches.all
  end

  # Create the @exam_group object build with batch for store in database.
  def new
    @batch = Batch.shod(params[:format])
    @exam_group = @batch.exam_groups.build
    @course = @batch.course
  end

  # Retrieve the selected batch details from database in @batch object.
  # Create new object @exam_group for storing user inputed details and save
  # in database.
  def create
    @batch = Batch.shod(params[:format])
    @exam_group = @batch.exam_groups.new(params_exam_group)
    @exam_group.save
    @subjects = @batch.exam
    @exam_group.exams.build
  end

  # This action fetch the exam group record from database
  # for update
  def edit
    @exam_group = ExamGroup.shod(params[:id])
    @batch = @exam_group.batch
  end

  # This action update the exam group record with update method
  # for selected record.
  def update
    @exam_group = ExamGroup.shod(params[:id])
    @exam_group.update(params_exam_group)
    @batch = @exam_group.batch
    @subjects = @batch.subjects.exam
    @exam_group.exams.build
  end

  # Fetch the exam group id throw shod method and store into @exam_group
  # store the exams attributes in the object a.
  # Convert the start time and end time into date format for validation
  # Insert the exam into the database.
  def exam_group_create
    @exam_group = ExamGroup.shod(params[:id])
    a = params[:exam_group][:exams_attributes]
    a.each do |s|
      @flag = true
      start_time = s[1][:start_time].to_date
      end_time = s[1][:end_time].to_date
      if start_time >= @exam_group.batch.start_date && end_time <= @exam_group.batch.end_date
        @flag = false
      end
    end
    if @flag == false
      @exam_group.update(params_exam_group)
      @exam_group.update_exam(@exam_group, params[:no_create])
    else
      @exam_group.errors.add(:exam_date, 'is not in range of batch date')
    end
  end

  # This action fetch the exam groups records from database and
  # display in table.
  def show
    @batch = Batch.shod(params[:id])
    @exam_groups ||= @batch.exam_groups.all
    @course = @batch.course
  end

  # @exam_group object store the user selected exam group id.
  # @exams fetch the only subject field for specific examgroup.
  def exams
    @exam_group = ExamGroup.shod(params[:id])
    @exams ||= @exam_group.exams.all.includes(:subject)
    @course = @exam_group.batch.course
  end

  # This action provide @batches object for generate the drop down list data
  # for selected course.
  def previous_exam
    @course = Course.shod(params[:course][:id])
    @batches = @course.batches.all
  end

  # This action provide @course object for generate the drop down list.
  def previous_exam_data
    @courses ||= Course.all
  end

  # @batch object store the selected batch id by user.
  # Fetch the exam group record for selected batch with only result published.
  def previous_exam_group
    @batch = Batch.shod(params[:batch][:id])
    @exam_groups = @batch.exam_groups.where(result_published: true)
  end

  # @exam_group object store the exam group id of user selected record.
  # @exams array store the previous exam details.
  def previous_exam_details
    @exams = []
    @exam_group = ExamGroup.shod(params[:exam_group][:id])
    @exams = @exam_group.exam_details(@exam_group)
  end

  # Store the user selected batch details in @batch object.
  # Fetch the exam group details for the selected batch in @exam_groups.
  def connect_exam
    @batch = Batch.shod(params[:format])
    @exam_groups = @batch.exam_groups.all
  end

  # This action provide the exam groups record for selected batch
  # assign all operation.
  def assign_all
    @batch = Batch.shod(params[:id])
    @exam_groups = @batch.exam_groups.all
  end

  # This action provide the exam groups record for selected batch
  # for remove all operation.
  def remove_all
    @batch = Batch.shod(params[:id])
    @exam_groups = @batch.exam_groups.all
  end

  # This action change the status of exam group record for published.
  def publish_exam
    @date = Date.today
    @exam_group = ExamGroup.shod(params[:format])
    @exam_group.update(is_published: true)
    @exam_group.exams.each(&:create_exam_event)
    @batch = @exam_group.batch
    @exam_groups ||= @batch.exam_groups.all
  end

  # This action update the exam group record.
  # When exam result is published then its update the record.
  def publish_result
    @exam_group = ExamGroup.shod(params[:format])
    if @exam_group.is_published?
      flag = @exam_group.publish(@exam_group)
      publish_res(flag)
    else
      flash[:alert] = 'Exam scheduled not published'
    end
    redirect_to exams_exam_group_path(@exam_group)
  end

  # This action is subpart of the publish_action.
  # It displays the flash message and update the record.
  def publish_res(flag)
    if flag == true
      flash[:alert] = 'Exam results cannot be published'
    else
      @exam_group.update(result_published: true)
      flash[:notice] = 'Result published successfully'
    end
  end

  # This action is used to delete the selected exam group record
  # using destroy method.
  def destroy
    @exam_group = ExamGroup.shod(params[:id])
    authorize! :delete, @exam_group
    batch = @exam_group.batch
    @exam_group.destroy
    flash[:notice] = 'Exam Group deleted successfully!'
    redirect_to exam_group_path(batch)
  end

  # This action display the previous exam scores of failed student.
  def previous_exam_scores
    @exam = Exam.shod(params[:format])
    @exam_scores = @exam.is_failed
    # authroize! :update, @exam
  end

  # This action is update the exam score using update method for
  # selected exam.
  def update_exam_score
    @exam = Exam.shod(params[:id])
    @exam_group = @exam.exam_group
    @batch = @exam_group.batch
    @exam.update_exam_scr(@exam, @exam_group, @batch, params[:exams][:exam])
    redirect_to previous_exam_scores_exam_groups_path(@exam.id)
  end

  private

  def params_exam_group
    params.require(:exam_group).permit!
  end
end
