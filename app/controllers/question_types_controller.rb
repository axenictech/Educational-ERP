# QuestionTypes Controller
class QuestionTypesController < ApplicationController
  before_action :set_question_type, only: [:edit, :update, :destroy]

  # get all question types
  def new
    @question_type = QuestionType.new
    @question_types = QuestionType.all
  end

  # method for edit question type
  def edit
  end

  # This method used for create QuestionType,
  # create QuestionType instance  and pass required params
  # from private method and call save method on QuestionType instance
  def create
    @question_types = QuestionType.all
    @question_type = QuestionType.new(question_type_params)
    if @question_type.save
      redirect_to new_question_type_path
      flash[:notice] =  'question type was successfully created.'
    else
      render 'new'
    end
  end

  # this method used for update QuestionType,first
  # find QuestionType which to be update
  # call update method on instance of QuestionType
  def update
    if @question_type.update(question_type_params)
      redirect_to new_question_type_path
      flash[:notice] =  'question type was successfully updated.'
    else
      render 'new'
    end
  end

  
  # this method used for destroyQuestionType ,
  # first find QuestionType which to be destroy
  # call destroy method on instance of QuestionType
  def destroy
    @question_type.destroy
    redirect_to new_question_type_path
    flash[:notice] =  'question type was successfully destroyed.'
  end

  private

  def set_question_type
    @question_type = QuestionType.find(params[:id])
  end

  def question_type_params
    params.require(:question_type).permit!
  end
end
