class GradingLevelsController < ApplicationController
  before_filter :find_batch, only: [:new, :create]
  before_filter :find_grade, only: [:edit, :update, :destroy]
  def index
    @batches ||= Batch.includes(:course).all
    authorize! :read, @batches.first
  end

  def new
    @grading_level = GradingLevel.new
    @grading_level1 = @batch.grading_levels.build
    authorize! :create, @grading_level
  end

  def create
    @grading_levels ||= @batch.grading_levels
    @grading_level1 = @batch.grading_levels.new(params_grade)
    @grading_level1.save
    flash[:notice] = t('grade_create')
  end

  def edit
    authorize! :update, @grading_level1
  end

  def update
    @grading_levels ||= @batch.grading_levels
    @grading_level1.update(params_grade)
    flash[:notice] = t('grade_update')
  end

  def destroy
    authorize! :delete, @grading_level1
    @grading_level1.destroy
    flash[:notice] = t('grade_delete')
    redirect_to grading_levels_path
  end

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
