# QuestionDatabasesController
class QuestionDatabasesController < ApplicationController
  
  # this method for get all quesions  
  def new
    @que = QuestionDatabase.new
    @ques = QuestionDatabase.all
  end

  # this method used for edit questions
  def edit
  end

  # This method used for create QuestionDatabase,
  # create QuestionDatabase instance  and pass required params
  # from private method and call save method on QuestionDatabase instance
  def create
    @ques = QuestionDatabase.all
    answer = params[:is_answer]
    @que = QuestionDatabase.new(question_type_params)
    if @que.save
      QuestionDatabase.create_que(params[:question][:option], @que, answer)
      redirect_to new_question_database_path
      flash[:notice] =  'question was successfully created.'
    else
      render 'new'
    end
  end

  # this method used for update QuestionDatabase,first
  # find QuestionDatabase which to be update
  # call update method on instance of QuestionDatabase
  def update
    if @que.update(question_type_params)
      redirect_to new_question_database_path
      flash[:notice] =  'question was successfully updated.'
    else
      render 'new'
    end
  end

  # this method used for destroy QuestionDatabase,
  # first find placementnews which to be destroy
  # call destroy method on instance of QuestionDatabase
  def destroy
    @que.destroy
    redirect_to new_question_database_path
    flash[:notice] =  'question was successfully destroyed.'
  end

  # this methods hold all options
  def option
    @option = params[:id].to_i
  end

  private

  def set_question_type
    @que = questionDatabase.find(params[:id])
  end

  def question_type_params
    params.require(:question_database).permit(:question_type_id, \
                                              :question, :no_of_option)
  end
end
