# Exam Controller perform the operation on exam like read,
# create, update, delete.
class ExamsController < ApplicationController
  # Create the new form for add the subject for exams.
  # Add the subject for selected exam group.
  # only the subject display which have true value for create exams.
  def new
    @exam_group = ExamGroup.shod(params[:format])
    @batch = @exam_group.batch
    @subjects = @batch.subjects.where(no_exams: false)
    @exam = @exam_group.exams.build
    authorize! :create, @exam_group
  end

  # This action actually save the exam in database.
  def create
    @exam_group = ExamGroup.shod(params[:exam_group_id])
    @batch = @exam_group.batch
    @subjects = @batch.subjects.where(no_exams: false)
    @exam = @exam_group.exams.new(params_exam)
    exam_create
  end

  # This action is the subpart of the action 'create'.
  def exam_create
    if @exam.save
      flash[:notice] = t('create_exam')
      redirect_to exams_exam_group_path(@exam.exam_group)
    else
      render 'new'
    end
  end

  # Fetch the selected exam record from database for edit.
  def edit
    @exam = Exam.shod(params[:id])
    @exam_group = @exam.exam_group
    @batch = @exam.exam_group.batch
    @subjects = @batch.subjects.where(no_exams: false)
    authorize! :update, @exam
  end

  # This action is update the exam record in database using update method.
  def update
    @exam = Exam.shod(params[:id])
    if @exam.update(params_exam)
      flash[:notice] = t('update_exam')
      redirect_to exams_exam_group_path(@exam.exam_group)
    else
      render 'edit'
    end
  end

  # @students array for storing the marks for selected batch and
  # again selected exam group.
  # Sorting the student marks according to exam grade.
  def exam_score
    @exam = Exam.shod(params[:id])
    @students = []
    students ||= @exam.exam_group.batch.students.all
    @students = @exam.select_subject(@students, students, @exam)
    @exam_grade ||= @exam.exam_group.batch.grading_levels.all
    authorize! :update, @exam
  end

  # This action update the exam score of the students.
  # @exam object store the particular exam id for which exam score is insert.
  # Find out all the exam group for particular exam.
  # Find out all batches for particular exam group.
  # For assing the grades for students as per marks.
  def update_exam_score
    @exam = Exam.shod(params[:id])
    @exam_group = @exam.exam_group
    @batch = @exam_group.batch
    grades = @exam.exam_group.batch.grading_levels.order(min_score: :asc)
    @temps = params[:exams][:exam]
    @exam.score_exam(@temps, @batch, @exam, @exam_group, grades)
    exam
  end

  # This provide the exam grade and subject for students.
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

  # This method delete the selected exam record using destroy method.
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
