# Exam Controller
class ExamsController < ApplicationController
  def new
    @exam_group = ExamGroup.shod(params[:format])
    @batch = @exam_group.batch
    @subjects = @batch.subjects.where(no_exams: false)
    @exam = @exam_group.exams.build
    authorize! :create, @exam_group
  end

  def create
    @exam_group = ExamGroup.shod(params[:exam_group_id])
    @batch = @exam_group.batch
    @subjects = @batch.subjects.where(no_exams: false)
    @exam = @exam_group.exams.new(params_exam)
    exam_create
  end

  def exam_create
    if @exam.save
      flash[:notice] = t('create_exam')
      redirect_to exams_exam_group_path(@exam.exam_group)
    else
      render 'new'
    end
  end

  def edit
    @exam = Exam.shod(params[:id])
    @exam_group = @exam.exam_group
    @batch = @exam.exam_group.batch
    @subjects = @batch.subjects.where(no_exams: false)
    authorize! :update, @exam
  end

  def update
    @exam = Exam.shod(params[:id])
    if @exam.update(params_exam)
      flash[:notice] = t('update_exam')
      redirect_to exams_exam_group_path(@exam.exam_group)
    else
      render 'edit'
    end
  end

  def exam_score
    @exam = Exam.shod(params[:id])
    @students = []
    students ||= @exam.exam_group.batch.students.all
    @students = @exam.select_subject(@students, students, @exam)
    @exam_grade ||= @exam.exam_group.batch.grading_levels.all
    authorize! :update, @exam
  end

  def update_exam_score
    @exam = Exam.shod(params[:id])
    @exam_group = @exam.exam_group
    @batch = @exam_group.batch
    grades = @exam.exam_group.batch.grading_levels.order(min_score: :asc)
    @temps = params[:exams][:exam]
    @exam.score_exam(@temps, @batch, @exam, @exam_group, grades)
    exam
  end

  def exam
    if @errors.nil?
      redirect_to exam_score_exam_path(@exam)
    else
      @students = []
      students ||= @exam.exam_group.batch.students.all
      @students = @exam.select_subject(@students, students, @exam)
      @exam_grade ||= @exam.exam_group.batch.grading_levels.all
      render 'exam_score'
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    authorize! :delete, @exam
    @exam.destroy
    redirect_to exams_exam_group_path(@exam.exam_group)
  end

  private

  def params_exam
    params.require(:exam).permit!
  end
end
