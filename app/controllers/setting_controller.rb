# Setting Controller
class SettingController < ApplicationController
  # Method for display index page for setting,
  # and perform authorization
  def index
    authorize! :read, GeneralSetting
  end

  # Method for display setting for course batch,
  # and perform authorization
  def course_batch
    authorize! :read, GeneralSetting
  end
end
