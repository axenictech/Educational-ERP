# Options Controller
class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy]

  # this method used for display alloptions
  def index
    @options = Option.all
  end

  # this method used for show options
  def show
  end

  # this method used for  GET new options
  def new
    @option = Option.new
  end

  # This method is used for edit options
  def edit
  end

  # This method used for create options,
  # create option instance  and pass required params
  # from private method and call save method on option instance
  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html { redirect_to @option, notice: 'Option was successfully created.' }
        format.json { render :show, status: :created, location: @option }
      else
        format.html { render :new }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # this method used for update option,first find option which to be update
  # call update method on instance option
  def update
    respond_to do |format|
      if @option.update(option_params)
        format.html { redirect_to @option, notice: 'Option was successfully updated.' }
        format.json { render :show, status: :ok, location: @option }
      else
        format.html { render :edit }
        format.json { render json: @option.errors, status: :unprocessable_entity }
      end
    end
  end

  # this method used for destroy option,
  # first find option which to be destroy
  # call destroy method on instance of option
  def destroy
    @option.destroy
    respond_to do |format|
      format.html do
        redirect_to options_url,
                    notice: 'Option was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_option
    @option = Option.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def option_params
    params.require(:option).permit(:option, :is_answer, :question_id)
  end
end
