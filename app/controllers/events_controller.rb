# Events Controller
class EventsController < ApplicationController
  
  # create event object
  # get date on whcih we want to create event
  def new
    @event = Event.new
    @start_date = params[:format]
    authorize! :create, @event
  end
  
  # create Event object and pass required parameters
  # from private method params_event and
  # create action is saving our new Event to the database.
  def create
    @event = Event.new(params_event)
    if @event.save
      flash[:notice] = 'Event created successfully'
      redirect_to event_path(@event)
    else
      render 'new'
    end
  end
  
  # this is used for create event for batches
  # get all batches from database
  def show
    @event = Event.shod(params[:id])
    @batches ||= Batch.all
    @departments ||= EmployeeDepartment.all
    authorize! :read, @event
  end
  
  # this is used for create event for departments
  # get all departments from database
  def showdep
    @departments ||= EmployeeDepartment.all
    authorize! :create, Event
  end
  
  # this method is used to create event for multipal batch and department
  def update
    @event = Event.shod(params[:event_id])
    if @event.create_event(params[:batches], params[:departments])
      flash[:notice] = 'Event confirmation successfully'
      redirect_to calender_index_path
    end
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.

  private
  
  def params_event
    params.require(:event).permit!
  end
end
