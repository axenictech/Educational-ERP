# ExamReport Controller
class ExamReportsController < ApplicationController
  def exam_wise_report
    @batches ||= Batch.includes(:course).all
    unless Batch.first.nil?
      @exam_groups ||= Batch.first.exam_groups
      @batches ||= Batch.includes(:course).all
      @exam_groups ||= Batch.first.exam_groups
      authorize! :read, @exam_groups.first
   end
  end

  def select
    @course = Course.shod(params[:exam][:course_id])
    @batches ||= @course.batches
    authorize! :read, ExamGroup
  end

  def select_batch
    @batch = Batch.shod(params[:batch_select][:id])
    @exam_groups ||= @batch.exam_groups
    authorize! :read, @exam_groups.first
  end

  def generate_exam_report
    if params[:exam_group_select][:id].present?
      @exam_group = ExamGroup.shod(params[:exam_group_select][:id])
      generate_exam_report2
    else
      generate_exam_report3
    end
    authorize! :read, @exam_group
  end

  def generate_exam_report2
    @batch = @exam_group.batch
    @student = @batch.students.first
  end

  def generate_exam_report3
    flash[:alert] = t('exam_report_error')
    @batches ||= Batch.includes(:course).all
    @exam_groups ||= Batch.first.exam_groups
    render 'exam_wise_report'
  end

  def exam_wise_students_report
    @exam_group = ExamGroup.shod(params[:exam_group_id])
    @batch = @exam_group.batch
    @students ||= @batch.students
    @general_setting = GeneralSetting.first
    render 'exam_wise_students_report', layout: false
  end

  def exam_wise_consolidated_report
    @exam_group = ExamGroup.shod(params[:exam_group_id])
    @batch = @exam_group.batch
    @general_setting = GeneralSetting.first
    render 'exam_wise_consolidated_report', layout: false
  end

  def student_exam_report
    @exam_group = ExamGroup.shod(params[:id])
    @student = Student.shod(params[:format])
    authorize! :read, @exam_group
  end

  def consolidated_report
    @exam_group = ExamGroup.shod(params[:id])
    @batch = @exam_group.batch
    authorize! :read, @exam_group
  end

  def subject_wise_report
    @batches ||= Batch.includes(:course).all
    @subjects ||= Batch.first.subjects unless Batch.first.nil?
    @batches ||= Batch.includes(:course).all
    @subjects ||= Batch.first.subjects unless Batch.first.nil?
    authorize! :read, ExamGroup
  end

  def choose_batch
    @batch = Batch.shod(params[:batch_choose][:id])
    @subjects ||= @batch.subjects
    authorize! :read, ExamGroup
  end

  def generate_subject_report
    if params[:subject_select][:id].present?
      @subject = Subject.shod(params[:subject_select][:id])
      generate_subject_report2
    else
      generate_subject_report3
    end
    authorize! :read, @exam_groups.first
  end

  def generate_subject_report2
    @batch = @subject.batch
    @exam_groups ||= @batch.result_published
    @students ||= @batch.students
  end

  def generate_subject_report3
    flash[:alert] = t('subject_report_error')
    @batches ||= Batch.includes(:course).all
    @subjects ||= Batch.first.subjects
    render 'subject_wise_report'
  end

  def subject_wise_students_report
    @subject = Subject.shod(params[:id])
    @batch = @subject.batch
    @exam_groups ||= @batch.result_published
    @students ||= @batch.students
    @general_setting = GeneralSetting.first
    render 'subject_wise_students_report', layout: false
  end

  def grouped_exam_report
    @batches ||= Batch.includes(:course).all
    authorize! :read, ExamGroup
  end

  def generate_grouped_report
    if params[:batch_option][:id].present?
      @batch = Batch.shod(params[:batch_option][:id])
      generate_grouped_report2
    else
      generate_grouped_report3
    end
    authorize! :read, ExamGroup
  end

  def generate_grouped_report2
    @students ||= @batch.students
    @student = @batch.students.first
    @exam_groups ||= @batch.result_published
    @subjects ||= @batch.subjects
  end

  def generate_grouped_report3
    flash[:alert] = t('group_error')
    @batches ||= Batch.includes(:course).all
    render 'grouped_exam_report'
  end

  def grouped_exam_students_report
    @batch = Batch.shod(params[:batch_id])
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
    @subjects ||= @batch.subjects
    @general_setting = GeneralSetting.first
    render 'grouped_exam_students_report', layout: false
  end

  def student_report
    @batch = Batch.shod(params[:id])
    @exam_groups ||= @batch.result_published
    @student = Student.shod(params[:student_id])
    @subjects ||= @batch.subjects
    authorize! :read, @exam_groups.first
  end
  
  def archived_student_report

    @courses=Course.all
    @batches=Course.first.batches.all if Course.first

    @courses = Course.all
    @batches = Course.first.batches.all unless Course.first.nil?

  end

  def select_course
    @course = Course.find(params[:course_select][:id])
    @batches = @course.batches.all
  end

  def generate_archived_report
    if request.get?
      if params[:batch_select][:id].present?
        @batch = Batch.find(params[:batch_select][:id])
        @students = @batch.archived_students.all
        @student = @batch.archived_students.last
        @exam_groups = @batch.exam_groups.where(result_published: true)
        @subjects = @batch.subjects.all
      else
        flash[:notice_arch] = 'Please select batch'
        @courses = Course.all
        @batches = Course.first.batches.all
        render 'archived_student_report'
      end
    end
  end

  # def archived_students_exam_report
  #   @batch = Batch.find(params[:batch_id])
  #   @students = @batch.archived_students.all
  #   @exam_groups = @batch.exam_groups.where(result_published: true)
  #   @subjects = @batch.subjects.all
  #   @general_setting = GeneralSetting.first
  #   render 'archived_students_exam_report', layout: false
  # end

  # def archived_student
  #   @student = ArchivedStudent.find(params[:student_id])
  #   @batch = @student.batch
  #   @exam_groups = @batch.exam_groups.where(result_published: true)
  #   @subjects = @batch.subjects.all
  # end

  # # def archived_student_report
  # #   @courses ||= Course.all
  # #   @batches ||= Course.first.batches unless Course.first.nil?
  # #   authorize! :read, ExamGroup
  # # end

  # # def select_course
  # #   @course = Course.shod(params[:course_select][:id])
  # #   @batches ||= @course.batches
  # #   authorize! :read, ExamGroup
  # # end

  # # def generate_archived_report
  # #   if params[:batch_select][:id].present?
  # #     @batch = Batch.shod(params[:batch_select][:id])
  # #     generate_archived_report2
  # #   else
  # #     generate_archived_report3
  # #   end
  # #   authorize! :read, ExamGroup
  # # end

  # # def generate_archived_report2
  # #   @students ||= @batch.archived_students 
  # #   @student = @batch.archived_students.first 
  # #   p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  # #   p @student
  # #   @exam_groups ||= @batch.result_published
  # #   @subjects ||= @batch.subjects
  # # end

  # # def generate_archived_report3
  # #   flash[:alert] = t('group_error')
  # #   @courses ||= Course.all
  # #   @batches ||= Course.first.batches
  # #   render 'archived_student_report'
  # # end

  def archived_students_exam_report
    @batch = Batch.shod(params[:id])
    @students ||= @batch.archived_students
    @exam_groups ||= @batch.result_published
    @subjects ||= @batch.subjects
    @general_setting = GeneralSetting.first
    render 'archived_students_exam_report', layout: false
  end

  def archived_student
    @student = ArchivedStudent.shod(params[:id])
    @batch = @student.batch
    @exam_groups ||= @batch.result_published
    @subjects ||= @batch.subjects
    authorize! :read, @exam_groups.first
  end

  def consolidated_archived_report
    @batch = Batch.shod(params[:id])
    @exam_groups ||= @batch.exam_groups
    authorize! :read, @exam_groups.first
  end

  def exam_group_wise_report
    @exam_group = ExamGroup.shod(params[:exam_group_option][:id])
    @batch = @exam_group.batch
    authorize! :read, @exam_group
  end

  def archived_students_consolidated_report
    @batch = Batch.shod(params[:id])
    @exam_groups ||= @batch.result_published
    @general_setting = GeneralSetting.first
    render 'archived_students_consolidated_report', layout: false
  end

  def student_ranking_per_subject
    @batches ||= Batch.includes(:course).all

    @subjects ||= Batch.last.subjects unless @subjects.nil?
    authorize! :read, ExamGroup
  end

  def rank_report_batch
    @batch = Batch.shod(params[:rank_report][:batch_id])
    @subjects ||= @batch.subjects
    authorize! :read, ExamGroup
  end

  def generate_ranking_report
    if params[:rank_report][:subject_id].present?
      @subject = Subject.shod(params[:rank_report][:subject_id])
      generate_ranking_report2
    else
      generate_ranking_report3
    end
    authorize! :read, ExamGroup
  end

  def generate_ranking_report2
    @batch = @subject.batch
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
  end

  def generate_ranking_report3
    flash[:alert] = t('subject_rank_errror')
    @batches ||= Batch.includes(:course).all
    @subjects ||= Batch.last.subjects
    render 'student_ranking_per_subject'
  end

  def subject_wise_ranking_report
    @subject = Subject.shod(params[:id])
    @batch = @subject.batch
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
    @general_setting = GeneralSetting.first
    render 'subject_wise_ranking_report', layout: false
  end

  def student_ranking_per_batch
    @batches ||= Batch.includes(:course).all
    authorize! :read, ExamGroup
  end

  def generate_student_ranking_report
    if params[:rank_report][:batch_id].present?
      @batch = Batch.shod(params[:rank_report][:batch_id])
      generate_rank_report2
    else
      generate_rank_report3
    end
    authorize! :read, ExamGroup
  end

  def generate_rank_report2
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
    @subjects ||= @batch.subjects
  end

  def generate_rank_report3
    flash[:alert] = t('batch_rank_error')
    @batches ||= Batch.includes(:course).all
    render 'student_ranking_per_batch'
  end

  def batch_wise_ranking_report
    @batch = Batch.shod(params[:batch_id])
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
    @subjects ||= @batch.subjects
    @general_setting = GeneralSetting.first
    render 'batch_wise_ranking_report', layout: false
  end

  def student_ranking_per_course
    @courses ||= Course.all
    authorize! :read, ExamGroup
  end

  def generate_student_ranking_report2
    if params[:rank_report][:course_id].present?
      @course = Course.shod(params[:rank_report][:course_id])
      @batches ||= @course.batches
    else
      generate_course_report
    end
    authorize! :read, ExamGroup
  end

  def generate_course_report
    flash[:alert] = t('course_rank_error')
    @courses ||= Course.all
    render 'student_ranking_per_course'
  end

  def course_wise_ranking_report
    @course = Course.shod(params[:course_id])
    @batches ||= @course.batches
    @general_setting = GeneralSetting.first
    render 'course_wise_ranking_report', layout: false
  end

  def student_ranking_per_school
    @courses ||= Course.all
    @students ||= Student.all
    @exam_groups ||= ExamGroup.result_published
    authorize! :read, @exam_groups.first
  end

  def school_wise_ranking_report
    @courses ||= Course.all
    @students ||= Student.all
    @exam_groups ||= ExamGroup.result_published
    @general_setting = GeneralSetting.first
    render 'school_wise_ranking_report', layout: false
  end

  def student_ranking_per_attendance
    @batches ||= Batch.includes(:course).all
    authorize! :read, ExamGroup
  end

  def generate_student_ranking_report3
    @batches ||= Batch.includes(:course).all
    @start_date = params[:rank_report][:start_date].to_date
    @end_date = params[:rank_report][:end_date].to_date
    if @start_date < @end_date
      @batch = Batch.shod(params[:rank_report][:batch_id])
      generate_attendance_report
    else
      generate_attendance_report2
    end
    authorize! :read, ExamGroup
  end

  def generate_attendance_report
    @students ||= @batch.students
    @weekdays ||= @batch.weekdays
    @batch_events ||= @batch.batch_events.includes(:event)
  end

  def generate_attendance_report2
    flash[:alert] = t('attendance_error')
    render 'student_ranking_per_attendance'
  end

  def attendance_wise_ranking_report
    @batch = Batch.shod(params[:batch_id])
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    attendance_wise_ranking_report2
  end

  def attendance_wise_ranking_report2
    @students ||= @batch.students
    @weekdays ||= @batch.weekdays
    @general_setting = GeneralSetting.first
    render 'attendance_wise_ranking_report', layout: false
  end

  def generate_view_transcripts
    if params[:transcript][:batch_id].present?
      @batch = Batch.shod(params[:transcript][:batch_id])
      generate_view_transcripts2
    else
      generate_view_transcripts3
    end
    authorize! :read, @exam_groups.first
  end

  def generate_view_transcripts2
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
    @student = @batch.students.first
  end

  def generate_view_transcripts3
    flash[:alert] = t('group_error')
    render 'view_transcripts'
  end

  def student_view_transcripts
    @student = Student.shod(params[:id])
    @batch = @student.batch
    @exam_groups ||= @batch.result_published
    @students ||= @batch.students
    authorize! :read, @exam_groups.first
  end

  def students_transcripts_report
    @batch = Batch.shod(params[:batch_id])
    @students ||= @batch.students
    @exam_groups ||= @batch.result_published
    @general_setting = GeneralSetting.first
    render 'students_transcripts_report', layout: false
  end
end
