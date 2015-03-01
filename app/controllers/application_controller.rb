# Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :set_current_user
  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_url, alert: t('authorize')
  end
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def set_current_user
    User.current = current_user
  end

  private

  def record_not_found
    render plain: '404 Not Found', status: 404
  end
end
