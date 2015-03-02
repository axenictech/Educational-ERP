# Calender Controller
class CalenderController < ApplicationController
  # get todays date
  # get start_date and end_date of current month
  def index
    @show_month = Date.today
    @start_date = @show_month.beginning_of_month
    @start_date_day = @start_date.wday
    @last_day = @show_month.end_of_month
  end
  
  # get previous and next month of current date
  # get start_date and end_date of that  month
  def change
    @show_month = params[:id].to_date
    @start_date = @show_month.beginning_of_month
    @start_date_day = @start_date.wday
    @last_day = @show_month.end_of_month
  end
  
  # find the Event
  def event_view
    @event = Event.shod(params[:event_id])
  end
  
  # get all Events from database
  def view_events
    @events = Event.all
  end
  
  # find Event which we selected
  # find batches and employee_department of selected event
  def display_batch_department
    @event = Event.find(params[:format])
    @batches = @event.batches
    @departments = @event.employee_departments
  end
  
  # upadate method update a Even,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update_event
    authorize! :update, @event
    @event = Event.find(params[:id])
    return unless @event.update(params_event)
    flash[:notice] = 'Event updated successfully'
    redirect_to calender_index_path
  end
  
  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.

  private

  def params_event
    params.require(:event).permit!
  end
end
