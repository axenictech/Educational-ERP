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
    @batch = Batch.shod(params[:transfer][:batch_id])
    @batch.trans(params[:students], params[:transfer][:id],@batch)
    student_transfer2
    authorize! :create, @batch
  end

  def student_transfer2
    flash[:notice] = t('batch_transfer')
    redirect_to transfer_batch_transfer_path(@batch)
  end

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
