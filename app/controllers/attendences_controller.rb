# Attendences Controller
class AttendencesController < ApplicationController
  def index
    authorize! :read, Attendence
  end

  def attendence_register
    @batches ||= Batch.includes(:course).all
    authorize! :read, Attendence
  end

  def select_subject
    @batch = Batch.shod(params[:batch][:id])
    @subjects ||= @batch.subjects
    authorize! :read, Attendence
  end

  def select
    @subject = Subject.shod(params[:subject][:id])
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @subject.batch)
    @today = Date.today
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
    authorize! :read, Attendence
  end

  def display
    @subject = Subject.shod(params[:id])
    @students ||= @subject.batch.students
    @today = params[:next].to_date
    display2
    authorize! :read, Attendence
  end

  def display2
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @subject.batch)
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
  end

  def new_attendence
    @attendence = Attendence.new
    @student = Student.shod(params[:id])
    @date = params[:month_date]
    @time_table_entry_id = params[:time_table_entry_id]
    @subject_id = params[:subject_id]
    authorize! :create, @attendence
  end

  def create
    @subject_id = params[:subject_id]
    @today = params[:attendence][:month_date].to_date
    @attendence = Attendence.new(attendence_params)
    @attendence.save
    @attendence.update(subject_id: @subject_id)
    @subject = Subject.shod(params[:subject_id])
    create2
  end

  def create2
    @students ||= @subject.batch.students
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @subject.batch)
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
  end

  def edit_attendence
    @attendence = Attendence.find(params[:id])
    @student = Student.shod(@attendence.student_id)
    @subject_id = params[:subject_id]
    @today = params[:date]
    authorize! :update, @attendence
  end

  def update_attendence
    @attendence = Attendence.shod(params[:id])
    @attendence.update(attendence_params)
    @today = params[:date].to_date
    @subject = Subject.shod(params[:subject_id])
    update_attendence2
  end

  def update_attendence2
    @students ||= @attendence.batch.students
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @subject.batch)
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
  end

  def delete_attendence
    @subject = Subject.shod(params[:subject_id])
    @batch = Batch.shod(params[:batch])
    @attendence = Attendence.shod(params[:id])
    authorize! :delete, @attendence
    @today = params[:date].to_date
    delete_attendence2
  end

  def delete_attendence2
    @attendence.destroy
    @students ||= @batch.students
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @batch)
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
    redirect_to attendence_register_attendences_path
  end

  def select_batch
    @batch = Batch.shod(params[:batch][:id])
    @subjects ||= @batch.subjects
    authorize! :read, Attendence
  end

  def generate_report
    @subject = Subject.shod(params[:report][:subject_id])
    @start_date = params[:report][:start_date]
    @end_date = params[:report][:end_date]
    generate_report2
    authorize! :read, Attendence
  end

  def generate_report2
    @students ||= @subject.batch.students
    @batch_events ||= @subject.batch.batch_events
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @subject.batch)
  end

  def attendence_report
    @general_setting = GeneralSetting.first
    @subject = Subject.shod(params[:subject_id])
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    attendence_report2
  end

  def attendence_report2
    @batch = @subject.batch
    @students ||= @batch.students
    @batch_events ||= @batch.batch_events
    @time_table_entries ||= TimeTableEntry.attendance(@subject, @batch)
    render 'attendence_report', layout: false
  end

  private

  def attendence_params
    params.require(:attendence).permit(:forenoon, :afternoon, :reason, :month_date, :student_id, :time_table_entry_id, :batch_id, :subject_id)
  end
end
