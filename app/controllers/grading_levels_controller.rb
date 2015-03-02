# GradingLevels Controller
class GradingLevelsController < ApplicationController
  before_filter :find_batch, only: [:new, :create]
  before_filter :find_grade, only: [:edit, :update, :destroy]
  
  # This method is used for Display all batches including courses
  def index
    @batches ||= Batch.includes(:course).all
    authorize! :read, @batches.first
  end

  # This method is used for get new grading level by
  # maintain association of batch and grading level
  def new
    @grading_level = GradingLevel.new
    @grading_level1 = @batch.grading_levels.build
    authorize! :create, @grading_level
  end

  # This method is used for creating gradin level,
  #  pass required params
  # from private method and save grading level
  def create
    @grading_levels ||= @batch.grading_levels
    @grading_level1 = @batch.grading_levels.new(params_grade)
    @grading_level1.save
    flash[:notice] = t('grade_create')
  end

  # this method is used to edit grading level
  def edit
    authorize! :update, @grading_level1
  end

  # edit grading level,first find grading_level which to be edit
  # and transfer controll to update method
  def update
    @grading_levels ||= @batch.grading_levels
    @grading_level1.update(params_grade)
    flash[:notice] = t('grade_update')
  end

  # This method is used for destroying grading level,
  # first find grading level to be deleted,
  # call destroy method on instance of grading level and perform authorization
  def destroy
    authorize! :delete, @grading_level1
    @grading_level1.destroy
    flash[:notice] = t('grade_delete')
    redirect_to grading_levels_path
  end

  # this method is used to select batch and hold all
  # grading levels of selected batch
  def select
    @batch = Batch.shod(params[:batch][:id])
    @grading_levels ||= @batch.grading_levels
    authorize! :read, @batch
  end

  private

  def find_batch
    @batch = Batch.shod(params[:batch_id])
  end

  def find_grade
    @batch = Batch.shod(params[:batch_id])
    @grading_level1 = @batch.grading_levels.shod(params[:id])
  end

  def params_grade
    params.require(:grading_level).permit!
  end
end
