# Home Controller
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  # this method id used for display index page
  def index
    redirect_to dashboard_home_index_path if current_user
  end

  # this method is used for display dashboard
  def dashboard
    @student = current_user.student
    @acts ||= UserActivity.order(created_at: :desc) if current_user.id == 1
  end

  # this method is used for record  user activity
  def user_activity
    @activity = UserActivity.shod(params[:id])
    @model ||= @activity.activity_model
  end
end
