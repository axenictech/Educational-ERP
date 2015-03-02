class GradingLevelsController < ApplicationController
  before_filter :find_batch, only: [:new, :create]
  before_filter :find_grade, only: [:edit, :update, :destroy]

  # find all batches from database,and perform authorization
  def index
    @batches ||= Batch.includes(:course).all
    authorize! :read, @batches.first
  end

  # create GradingLevel object,
  # make association of Batch and GradingLevel,and perform authorization
  def new
    @grading_level = GradingLevel.new
    @grading_level1 = @batch.grading_levels.build
    authorize! :create, @grading_level
  end

  # create GradingLevel object and pass required parameters
  # from private method params_grade and
  # create action is saving our new GradingLevel to the database.

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

  # find GradingLevel which we want to edit and pass it to update method
  # and perform authorization
  def edit
    authorize! :update, @grading_level1
  end

  # upadate method update a GradingLevel,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    @grading_levels ||= @batch.grading_levels
    @grading_level1.update(params_grade)
    flash[:notice] = t('grade_update')
  end

  # find GradingLevel which we want to destroy,
  # destroy method deleting that GradingLevels from the
  # database and perform authorization

  def destroy
    authorize! :delete, @grading_level1
    @grading_level1.destroy
    flash[:notice] = t('grade_delete')
    redirect_to grading_levels_path
  end

  # find batch,
  # get all grading_level of that batch, and perform authorization
  def select
    @batch = Batch.shod(params[:batch][:id])
    @grading_levels ||= @batch.grading_levels
    authorize! :read, @batch
  end

  private

  # find batch
  def find_batch
    @batch = Batch.shod(params[:batch_id])
  end

  # find batch and grading levels
  def find_grade
    @batch = Batch.shod(params[:batch_id])
    @grading_level1 = @batch.grading_levels.shod(params[:id])
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def params_grade
    params.require(:grading_level).permit!
  end
end
