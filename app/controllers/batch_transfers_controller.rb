# BatchTransfer Controller
class BatchTransfersController < ApplicationController
  def index
    @courses ||= Course.all
    @course = Course.new
    authorize! :read, @course
  end

  def select
    @course = Course.shod(params[:batch_transfer][:id])
    authorize! :read, @course
  end

  def transfer
    @batch = Batch.shod(params[:id])
    @batchs ||= Batch.includes(:course).all
    @students ||= @batch.students
    authorize! :read, @batch
  end

  def assign_all
    @batch = Batch.shod(params[:format])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  def remove_all
    @batch = Batch.shod(params[:format])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  def student_transfer
    # @batch = Batch.shod(params[:transfer][:batch_id])
    # @batch.trans(params[:students], params[:transfer][:id])
    # student_transfer2
    # authorize! :create, @batch
   
    @batch = Batch.find(params[:transfer][:batch_id])
    @subject = @batch.subjects
    @exam_group = @batch.result_published
    transfer_batch_id = params[:transfer][:id]
    students = params[:students]
    if students.present?
      students.each  do |student|
        @subject.each do |subject|
          @exam_group.each do |exam_group|
           unless  @subject.nil?
            exam = Exam.find_by_subject_id_and_exam_group_id(subject.id,exam_group.id)
             unless exam.nil?
               exam_score = ExamScore.find_by_student_id_and_exam_id(student,exam.id)
            unless exam_score.nil?
            StudentLog.create(subject_id:subject.id,batch_id:@batch.id,student_id:student,exam_group_id:exam_group.id,mark:exam_score.marks,maximum_marks: exam.maximum_marks)
            end
           end
         end
       end
          end

        @student = Student.find(student)
        @student.update(batch_id: transfer_batch_id)
      end
      flash[:notice_transfer] = 'Students transfer successfully'
    else
      flash[:notice_transfer] = 'Please select student'
    end
    redirect_to transfer_batch_transfer_path(@batch)
    authorize! :create, @batch
  end

  # def student_transfer2
  #   flash[:notice] = t('batch_transfer')
  #   redirect_to transfer_batch_transfer_path(@batch)
  # end

  def graduation
    @batch = Batch.shod(params[:id])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  def former_student
    @batch = Batch.shod(params[:graduate][:batch_id])
    @batch.graduate(params[:students], params[:graduate][:status_description])
    former_student2
    authorize! :create, @batch
  end

  def former_student2
    flash[:notice] = t('graduate')
    redirect_to graduation_batch_transfer_path(@batch)
  end
end
