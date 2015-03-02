# BatchTransfer Controller
class BatchTransfersController < ApplicationController
  # get all courses from database
  # create new object of course,
  # and perform authorization
  def index
    @courses ||= Course.all
    @course = Course.new
    authorize! :read, @course
  end

  # find course which we selected,
  # and perform authorization
  def select
    @course = Course.shod(params[:batch_transfer][:id])
    authorize! :read, @course
  end

  # find batch which we selected, get all students in that batch
  # and perform authorization
  def transfer
    @batch = Batch.shod(params[:id])
    @batchs ||= Batch.includes(:course).all
    @students ||= @batch.students
    authorize! :read, @batch
  end

  # get all students of that batch
  # this method is use for select all student in one click
  # and perform authorization
  def assign_all
    @batch = Batch.shod(params[:format])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  # get all students of that batch
  # this method is use for deselect all student in one click
  # and perform authorization
  def remove_all
    @batch = Batch.shod(params[:format])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  # this method is used to transfer student
  # from one batch to another batch
  # and perform authorization
  def student_transfer
    @batch = Batch.shod(params[:transfer][:batch_id])
    @batch.trans(params[:students], params[:transfer][:id], @batch)
    student_transfer2
    authorize! :create, @batch
  end

  # redirect to transfer page
  def student_transfer2
    flash[:notice] = t('batch_transfer')
    redirect_to transfer_batch_transfer_path(@batch)
  end

  # get all students of that batch
  # and perform authorization
  def graduation
    @batch = Batch.shod(params[:id])
    @students ||= @batch.students
    authorize! :read, @batch
  end

  # this method is used to graduate student
  # student are moved from Student to ArchivedStudent
  # and perform authorization
  def former_student
    @batch = Batch.shod(params[:graduate][:batch_id])
    @batch.graduate(params[:students], params[:graduate][:status_description])
    former_student2
    authorize! :create, @batch
  end

  # redirect to graduation page
  def former_student2
    flash[:notice] = t('graduate')
    redirect_to graduation_batch_transfer_path(@batch)
  end
end
