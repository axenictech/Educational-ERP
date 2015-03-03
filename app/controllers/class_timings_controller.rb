# ClassTimings Controller
# set the class timing for timetable module
class ClassTimingsController < ApplicationController
  # Get all Batches from database, and perform authorization
  def index
    @batches ||= Batch.includes(:course).all
    authorize! :read, ClassTiming
  end

  # create class timing object,get selected batch and association of that
  # batch with our class timing object, and perform authorization
  def new
    @batch = Batch.shod(params[:batch_id])
    @class_timing = ClassTiming.new
    @class_timing1 = @batch.class_timings.build
    authorize! :create, @class_timing
  end

  # create class timing object and pass required parameters
  # from private method params_class and
  # create action is saving our new class timing to the database.
  def create
    @batch = Batch.shod(params[:batch_id])
    @class_timings ||= @batch.class_timings.order('start_time ASC')
    @class_timing1 = @batch.class_timings.new(params_class)
    @class_timing1.save
    flash[:notice] = t('class_timing_create')
  end

  # find class timing which we want to destroy,
  # destroy method deleting that class timing from the
  # database and perform authorization
  def destroy
    @batch = Batch.shod(params[:batch_id])
    @class_timing1 = @batch.class_timings.shod(params[:id])
    authorize! :destroy, @class_timing1
    @class_timing1.destroy
    flash[:notice] = t('class_timing_delete')
    redirect_to class_timings_path
  end

  # find class timing which we want to edit and pass it to update method
  # and perform authorization
  def edit
    @batch = Batch.shod(params[:batch_id])
    @class_timing1 = @batch.class_timings.shod(params[:id])
    authorize! :update, @class_timing1
  end

  # upadate method update a class timing,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    @batch = Batch.shod(params[:batch_id])
    @class_timings ||= @batch.class_timings.order('start_time ASC')
    @class_timing1 = @batch.class_timings.shod(params[:id])
    @class_timing1.update(params_class)
    flash[:notice] = t('class_timing_update')
  end

  # get selected batch and
  # list all our class timings for that batch,and perform authorization
  def select
    @batch = Batch.shod(params[:batch][:id])
    @class_timings ||= @batch.class_timings.order('start_time ASC')
    authorize! :read, @class_timings.first
  end

  private

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def params_class
    params.require(:class_timing).permit!
  end
end
