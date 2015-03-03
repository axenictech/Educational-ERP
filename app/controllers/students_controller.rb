# Students Controller magange the operation of student admission,
# guardian details, previous year details and profile.
class StudentsController < ApplicationController

  def index
    @students ||= Student.list
    authorize! :create, Student
  end

  # In this action @batches, @countries, @categories object fetch the data
  # for drop down list in the form. @student is the new object create for
  # store the new student admission details in database. set_admission_no
  # method is used to generate the unique admission number for each student.
  def admission1
    @student = Student.new
    @student.admission_no = Student.set_admission_no
    @batches ||= Batch.all.includes(:course)
    @countries ||= Country.all
    @categories ||= Category.all
    authorize! :create, @student
  end

  # This action save the student record in the database. before save the
  # record email id is convert into small case alphabet.
  def create
    @student = Student.new(student_params)
    @batches ||= Batch.all.includes(:course)
    temp_email = params['student']['email']
    downcase_email = temp_email.downcase
    @student.email = downcase_email
    if @student.save
      flash[:notice] = t('student_admission1')
      redirect_to admission2_students_path(@student)
    else
      @countries ||= Country.all
      @categories ||= Category.all
      render 'admission1'
    end
  end

  def show
    @student = Student.shod(params[:id])
    authorize! :read, @student
  end

  # This action create the new object of store the guardion details
  # for adjecent student. Build the student object with guardian object.
  def admission2
    @student = Student.shod(params[:format])
    @guardian = @student.guardians.build
    @countries ||= Country.all
    authorize! :create, @student
  end

  # This action display the successfull message of guardian add successfully
  # for adjecent student.
  def admission2_1
    @student = Student.shod(params[:format])
    authorize! :create, @student
  end

  # This action is fetch the selected student record and display the
  # form for select emergency contact of guardian.
  def admission3
    @student = Student.shod(params[:format])
    authorize! :create, @student
  end

  def edit
    @student = Student.shod(params[:id])
    @batches ||= Batch.includes(:course).all
    authorize! :update, @student
  end

  def update
    @student = Student.shod(params[:id])
    if @student.update(student_params)
      flash[:notice] = t('student_update')
      redirect_to profile_student_path(@student)
    else
      @batches ||= Batch.includes(:course).all
      render 'edit'
    end
  end

  # This action is perform the operation for update immediate contact
  # for selected student.
  def update_immediate_contact
    @student = Student.shod(params[:id])
    @student.update(student_params)
    @guardian = Guardian.shod(@student.immediate_contact)
    @guardian.create_user_account
    redirect_to previous_data_students_path(@student)
  end

  def edit_immediate_contact
    @student = Student.shod(params[:format])
    authorize! :update, @student
  end

  def update_immediatecontact
    @student = Student.shod(params[:id])
    @student.update(student_params)
    @guardian = Guardian.shod(@student.immediate_contact)
    @guardian.create_user_account
    redirect_to profile_student_path(@student)
  end

  # Create the new object for storing the previous institute details
  # for selected student.
  def previous_data
    @student = Student.shod(params[:format])
    @previous_data = StudentPreviousData.new
    authorize! :create, @student
  end

  def previous_data_create
    @student = Student.shod(params[:student_previous_data][:student_id])
    @previous_data = StudentPreviousData.create(previous_data_params)
    if @previous_data.save
      redirect_to profile_student_path(@student)
    else
      render '/students/previous_data'
    end
  end

  # Create the new object for store previous course subject details
  # for selected student.
  def previous_subject
    @student = Student.shod(params[:format])
    @previous_subject = StudentPreviousSubjectMark.new
    authorize! :create, @student
  end

  def previous_subject_create
    @previous_subject = StudentPreviousSubjectMark.create(params_subject)
    student = params[:student_previous_subject_mark][:student_id]
    @previous_subjects ||= StudentPreviousSubjectMark.where(student_id: student)
  end

  def view_all
    @batches ||= Batch.includes(:course).all
    authorize! :read, @batches.first
  end

  def select
    @batch = Batch.shod(params[:batch][:id])
    @students ||= @batch.students
    authorize! :read, @students.first
  end

  def profile
    @student = Student.shod(params[:id])
    @immediate_contact = Guardian.shod(@student.immediate_contact)
    authorize! :read, @student
  end

  def student_profile
    @student = Student.shod(params[:id])
    @immediate_contact = Guardian.shod(@student.immediate_contact)
    @student_previous_data = StudentPreviousData.data(@student.id)
    @student_previous_subject_marks = StudentPreviousSubjectMark.m(@student.id)
    @general_setting = GeneralSetting.first
    render 'student_profile', layout: false
  end

  def archived_profile
    @student = ArchivedStudent.shod(params[:id])
    id = @student.student_id
    @immediate_contact = Guardian.shod(@student.immediate_contact)
    @student_previous_data = StudentPreviousData.data(id)
    @student_previous_subject_marks ||= StudentPreviousSubjectMark.m(id)
    authorize! :read, @student
  end

  def archived_student_profile
    @student = ArchivedStudent.shod(params[:id])
    id = @student.student_id
    @immediate_contact = Guardian.shod(@student.immediate_contact)
    @student_previous_data = StudentPreviousData.data(id)
    @student_previous_subject_marks ||= StudentPreviousSubjectMark.m(id)
    @general_setting = GeneralSetting.first
    render 'student_profile', layout: false
  end

  def report
    @student = Student.shod(params[:format])
    @batch = @student.batch
    authorize! :read, @student
  end

  def reciept
    @student = Student.shod(params[:format])
    @general_setting = GeneralSetting.first
    @collection = @student.finance_fee_collections.take
    unless @collection.nil?
      @category = @collection.finance_fee_category
      @particulars ||= @collection.fee_collection_particulars
      @discounts ||= @collection.fee_collection_discounts
      @fee = @student.finance_fees.take
      @fines ||= @fee.finance_fines
    else
      flash[:notice] = "Collection not created for reciept"
      redirect_to profile_student_path(@student) 
    end
    authorize! :read, @student
  end

  def archived_report
    @student = ArchivedStudent.shod(params[:format])
    @batch = @student.batch
    @exam_groups ||= @batch.exam_groups
    authorize! :read, @student
  end

  def recent_exam_report
    @exam_group = ExamGroup.shod(params[:exam_group_id])
    @student = Student.shod(params[:student_id])
    @batch = @exam_group.batch
    authorize! :read, @student
  end

  def student_exam_report
    @exam_group = ExamGroup.shod(params[:exam_group_id])
    @student = Student.shod(params[:student_id])
    @batch = @exam_group.batch
    @general_setting = GeneralSetting.first
    render 'student_exam_report', layout: false
  end

  def subject_wise_report
    @subject = Subject.shod(params[:subject_id])
    @student = Student.shod(params[:student_id])
    @batch = @subject.batch
    @exam_groups ||= @batch.exam_groups
    authorize! :read, @student
  end

  def academic_report
    @subject = Subject.shod(params[:subject_id])
    @student = Student.shod(params[:student_id])
    @batch = @subject.batch
    @exam_groups ||= @batch.exam_groups
    @general_setting = GeneralSetting.first
    render 'academic_report', layout: false
  end

  def final_report
    @student = Student.shod(params[:format])
    @batch = @student.batch
    @exam_groups ||= @batch.exam_groups
    @subjects ||= @batch.subjects
    authorize! :read, @student
  end

  def student_final_report
    @student = Student.shod(params[:student_id])
    @batch = @student.batch
    @exam_groups ||= @batch.exam_groups
    @subjects ||= @batch.subjects
    @general_setting = GeneralSetting.first
    render 'student_final_report', layout: false
  end

  def transcript_report
    @student = Student.shod(params[:format])
    @batch = @student.batch
    @first = Batch.first.id
    @current = @batch.id - 1
    @student_log = StudentLog.where(student_id:@student)
    @exam_groups ||= @batch.exam_groups
    authorize! :read, @student
  end

  def student_transcript_report
    @student = Student.shod(params[:student_id])
    @batch = @student.batch
    @exam_groups ||= @batch.exam_groups
    @general_setting = GeneralSetting.first
    render 'student_transcript_report', layout: false
  end

  def archived_student_transcript_report
    @student = ArchivedStudent.shod(params[:student_id])
    @batch = @student.batch
    @exam_groups ||= @batch.exam_groups
    @general_setting = GeneralSetting.first
    render 'archived_student_transcript_report', layout: false
  end

  def attendance_report
    @student = Student.shod(params[:format])
    @batch = @student.batch
    @subjects ||= @batch.subjects
    authorize! :read, @student
  end

  def genrate_report
    @student = Student.shod(params[:report][:student_id])
    s_id = params[:report][:subject_id]
    @start_date = params[:report][:start_date]
    @end_date = params[:report][:end_date]
    @batch_events ||= @student.batch.batch_events
    @time_table_entries ||= TimeTableEntry.entries(s_id, @student.batch.id)
    authorize! :read, @student
  end

  def advanced_search
    @courses ||= Course.all
    @batches ||= Course.first.batches unless Course.first.nil?
    authorize! :read, @student
  end

  def batch_details
    @course = Course.shod(params[:id])
    @batches ||= @course.batches
    authorize! :read, @student
  end

  def advanced_student_search
    @students ||= Student.advance_search(params[:search], params[:batch]) unless params[:batch].nil?
    @search ||= Student.search_script(params[:search], params[:batch]) unless params[:batch].nil?
    authorize! :read, @student
  end

  def advanced_search_result
    @students ||= params[:students]
    @search ||= params[:search]
    @general_setting = GeneralSetting.first
    render 'advanced_search_result', layout: false
  end

  def elective
    @subject = Subject.shod(params[:id])
    @students ||= @subject.elective_group.batch.students
    authorize! :read, @student
  end

  def assign_all
    @subject = Subject.shod(params[:id])
    @students ||= @subject.elective_group.batch.students
    authorize! :read, @student
  end

  def remove_all
    @subject = Subject.shod(params[:id])
    @students ||= @subject.elective_group.batch.students
    authorize! :read, @student
  end

  def assign_elective
    @subject = Subject.shod(params[:student_subject][:subject_id])
    @subject.assign_subject(params[:students])
    flash[:notice] = t('assign_elective')
    redirect_to elective_student_path(@subject)
    authorize! :create, @student
  end

  def email
    @student = Student.shod(params[:format])
    authorize! :create, @student
  end

  def send_email
    subject = params[:subject]
    recipient = params[:email][:recipient]
    message = params[:message]
    if subject.empty? || recipient.empty? || message.empty?
      flash[:alert] = t('email_invalid')
      @student = Student.shod(params[:student_id])
      redirect_to email_students_path(@student)
    else
      @student = Student.shod(params[:student_id])
      @student.mail(subject, recipient, message)
      flash[:notice] = t('sent_email')
      redirect_to email_students_path(@student)
    end
  end

  def report_email
    @student = ArchivedStudent.shod(params[:format])
    authorize! :create, @student
  end

  def send_report_email
    @student = ArchivedStudent.shod(params[:student_id])
    @student.mail(params[:subject], recipient, message)
    redirect_to report_email_students_path(@student)
  end

  def generate_tc
    @student = ArchivedStudent.shod(params[:id])
    authorize! :create, @student
    @immediate_contact = Guardian.shod(@student.immediate_contact)
    @father = Guardian.discover(@student.id, 'father')
    @mother = Guardian.discover(@student.id, 'mother')
    @general_setting = GeneralSetting.first
    render 'generate_tc', layout: false
  end

  def remove
    @student = Student.shod(params[:format])
    authorize! :create, @student
  end

  def delete
    @student = Student.shod(params[:format])
  end

  def destroy
    @student = Student.shod(params[:id])
    authorize! :delete, @student
    @student.destroy
    redirect_to home_dashboard_path
  end

  def change_to_former
    @student = Student.shod(params[:format])
    @archived_student = ArchivedStudent.new
    authorize! :create, @student
  end

  def archived_student_create
    @student = Student.shod(params[:format])
    @archived_student = @student.archived_student
    @archived_student.update(status_description: \
      params[:archived_student][:status_description])
    s=StudentLog.where(student_id:@student)
    s.each do |m|
     StudentLog.destroy(m.id)
    end
    @student.destroy
    redirect_to archived_profile_student_path(@archived_student)
  end

  def dispguardian
    @student = Student.shod(params[:format])
    @guards ||= @student.guardians.includes(:country)
    authorize! :read, @student
  end

  def addguardian
    @student = Student.shod(params[:format])
    @guard = @student.guardians.build
    authorize! :read, @student
  end

  def archived_student_guardian
    @student = ArchivedStudent.shod(params[:format])
    @guards ||= Guardian.where(student_id: @student.student_id)
    authorize! :read, @student
  end

  private

  def student_params
    params.require(:student).permit!
  end

  def previous_data_params
    params.require(:student_previous_data).permit!
  end

  def params_subject
    params.require(:student_previous_subject_mark).permit!
  end
end
