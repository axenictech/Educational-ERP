# Events Controller
class EventsController < ApplicationController
  def new
    @event = Event.new
    @start_date = params[:format]
    authorize! :create, @event
  end

  def create
    @event = Event.new(params_event)
    if @event.save
      flash[:notice] = 'Event created successfully'
      redirect_to event_path(@event)
    else
      render 'new'
    end
  end

  def show
    @event = Event.shod(params[:id])
    @batches ||= Batch.all
    @departments ||= EmployeeDepartment.all
    authorize! :read, @event
  end

  def showdep
    @departments ||= EmployeeDepartment.all
    authorize! :create, Event
  end

  def update
    @event = Event.shod(params[:event_id])
    if @event.create_event(params[:batches], params[:departments])
      flash[:notice] = 'Event confirmation successfully'
      redirect_to calender_index_path
    end
  end

  private

  def params_event
    params.require(:event).permit!
  end
end
