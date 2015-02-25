# ExamGroupsController
class ExamGroupsController < ApplicationController
  def index
    @courses ||= Course.all
  end

  def select
    @course = Course.shod(params[:course][:id])
    @batches ||= @course.batches.all
  end

  def new
    @batch = Batch.shod(params[:format])
    @exam_group = @batch.exam_groups.build
    @course = @batch.course
  end

  def create
    @batch = Batch.shod(params[:format])
    @exam_group = @batch.exam_groups.new(params_exam_group)
    @exam_group.save
    @subjects = @batch.exam
    @exam_group.exams.build
  end

  def edit
    @exam_group = ExamGroup.shod(params[:id])
    @batch = @exam_group.batch
  end

  def update
    @exam_group = ExamGroup.shod(params[:id])
    @exam_group.update(params_exam_group)
    @batch = @exam_group.batch
    @subjects = @batch.subjects.exam
    @exam_group.exams.build
  end

  def exam_group_create
    @exam_group = ExamGroup.shod(params[:id])
    @exam_group.update(params_exam_group)
    @exam_group.update_exam(@exam_group, params[:no_create])
  end

  def show
    @batch = Batch.shod(params[:id])
    @exam_groups ||= @batch.exam_groups.all
    @course = @batch.course
  end

  def exams
    @exam_group = ExamGroup.shod(params[:id])
    @exams ||= @exam_group.exams.all.includes(:subject)
    @course = @exam_group.batch.course
  end

  def previous_exam
    @course = Course.shod(params[:course][:id])
    @batches = @course.batches.all
  end

  def previous_exam_data
    @courses ||= Course.all
  end

  def previous_exam_group
    @batch = Batch.shod(params[:batch][:id])
    @exam_groups = @batch.exam_groups.where(result_published: true)
  end

  def previous_exam_details
    @exams = []
    @exam_group = ExamGroup.shod(params[:exam_group][:id])
    @exams = @exam_group.exam_details(@exam_group)
  end

  def connect_exam
    @batch = Batch.shod(params[:format])
    @exam_groups = @batch.exam_groups.all
  end

  def assign_all
    @batch = Batch.shod(params[:id])
    @exam_groups = @batch.exam_groups.all
  end

  def remove_all
    @batch = Batch.shod(params[:id])
    @exam_groups = @batch.exam_groups.all
  end

  def publish_exam
    @date = Date.today
    @exam_group = ExamGroup.shod(params[:format])
    @exam_group.update(is_published: true)
    @exam_group.exams.each(&:create_exam_event)
    @batch = @exam_group.batch
    @exam_groups ||= @batch.exam_groups.all
  end

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

  def publish_res(flag)
    if flag == true
      flash[:alert] = 'Exam results cannot be published'
    else
      @exam_group.update(result_published: true)
      flash[:notice] = 'Result published successfully'
    end
  end

  def destroy
    @exam_group = ExamGroup.shod(params[:id])
    authorize! :delete, @exam_group
    batch = @exam_group.batch
    @exam_group.destroy
    flash[:notice] = 'Exam Group deleted successfully!'
    redirect_to exam_group_path(batch)
  end

  def previous_exam_scores
    @exam = Exam.shod(params[:format])
    @exam_scores = @exam.is_failed
    # authroize! :update, @exam
  end

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
