# GeneralSetting Controller
class GeneralSettingsController < ApplicationController
  # create GeneralSetting object and pass required parameters
  # create_general_setting action is
  # saving our new general_setting to the database.
  # and perform authorization
  def new
    @general_setting = current_user.general_setting
    authorize! :read, @general_setting
  end

  # upadate method update a GeneralSetting,
  # and it accepts a hash containing the attributes that you want to update.
  def update
    @general_setting = GeneralSetting.shod(params[:id])
    if @general_setting.update(general_setting_params)
      flash[:notice] = t('setting_update')
      redirect_to dashboard_home_index_path
    else
      render 'new'
    end
  end

  private

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def general_setting_params
    params.require(:general_setting).permit!
  end
end
