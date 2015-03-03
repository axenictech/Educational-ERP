class QusetionsController < ApplicationController
  before_action :set_qusetion, only: [:show, :edit, :update, :destroy]

  # method for GET qusetions
  def index
    @qusetions = Qusetion.all
  end

  # method for show qusetions
  def show
  end

  # method for GET new qusetions
  def new
    @qusetion = Qusetion.new
  end

  # method for  edit qusetions
  def edit
  end

  # This method used for create Question,
  # create Question instance  and pass required params
  # from private method and call save method on Question instance
  def create
    @qusetion = Qusetion.new(qusetion_params)

    respond_to do |format|
      if @qusetion.save
        format.html { redirect_to @qusetion, notice: 'Qusetion was successfully created.' }
        format.json { render :show, status: :created, location: @qusetion }
      else
        format.html { render :new }
        format.json { render json: @qusetion.errors, status: :unprocessable_entity }
      end
    end
  end

  # this method used for update Question,first
  # find Question which to be update
  # call update method on instance of Question
  def update
    respond_to do |format|
      if @qusetion.update(qusetion_params)
        format.html { redirect_to @qusetion, notice: 'Qusetion was successfully updated.' }
        format.json { render :show, status: :ok, location: @qusetion }
      else
        format.html { render :edit }
        format.json { render json: @qusetion.errors, status: :unprocessable_entity }
      end
    end
  end

  # this method used for destroy Question ,
  # first find Question which to be destroy
  # call destroy method on instance of Question
  def destroy
    @qusetion.destroy
    respond_to do |format|
      format.html { redirect_to qusetions_url, notice: 'Qusetion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_qusetion
    @qusetion = Qusetion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def qusetion_params
    params.require(:qusetion).permit(:question, :question_type_id, :question_count)
  end
end
