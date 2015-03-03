# PlacementExams5Controller
class PlacementExamsController < ApplicationController
  before_action :set_placement_exam, only: [:show, :edit, :update, :destroy]

  # this method used for get all placementexams and placementnews
  def index
    @placement_exam = PlacementExam.all
    @placement_news = PlacementNews.all
  end

  # this method used for get all company and placementnews
  def insert
    @companies = Company.all
    @placement_news = PlacementNews.all
  end

  # this method used for applay exam
  def apply_exam
    @companies = Company.all
    @placement_news = PlacementNews.all
  end

  # this method is used for create exam
  def create_exam
    @exam = PlacementExam.new
    @company = Company.all
    @placement_exam = PlacementExam.new
  end

  # this method is used for insert exam, create instance of placement exam
  # pass all required parameter from private method then call save method
  # on instance of PlacementExam,then create weightage on each question until
  # percentage not equal to 100
  def insert_exam
    question_type = params[:question_type]
    percentage = params[:percentages]
    if percentage.map(&:to_i).sum == 100
      @placement_exam = PlacementExam.new(placement_exam_params)
      @placement_exam.save
      i = 0
      question_type.each do |q|
        Weightage.create(question_type_id: q,
                         placement_exam_id: @placement_exam.id,
                         percentage: percentage[i])
        i += 1
      end
      redirect_to create_exam_placement_exams_path
      flash[:notice] = t('placement_exam_created')
    else
      render 'create_exam'
      flash[:alert] = t('placement_exam_error')
    end
  end

  # this method is used for display question paper
  def question_paper
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:p_id])
  end

  # this method is used for save placement exam and caluclatr result
  # for perticular student and store result
  def save_test
    @test = params[:question]
    @placement_exam = PlacementExam.find(params[:placement_exam_id])
    @student = Student.find(params[:student_id])
    @score = PlacementExam.calculateres(@test, @placement_exam.id, @student)
  end

  def exam
  end
  # this method used hold all placementexam
  def placement_tpo
    @placement_exams = PlacementExam.all
  end

  #this method used for display setting
  def setting_index
  end

  # this method used for get new placement exam
  def new
    @placement_exam = PlacementExam.new
  end

  # this method used for edit placement exam
  def edit
  end

  # create placement exam instance and pass required parameters
  # from private method and
  # call save method on placement exams instance
  def create
    @placement_exam = PlacementExam.new(placement_exam_params)
    @placement_exam.save
  end

  # this method used for update placement exam,
  # call update method on instance of placament exam and pass required
  # params
  def update
    if @placement_exam.update(placement_exam_params)
      redirect_to @placement_exam
      flash[:notice] = 'Placement exam was successfully updated.'
    else
      render 'edit'
    end
  end

  # this method used for destroy placement exam,
  # first find placement exam which to be destroy
  # call destroy method on instance of placement exam
  def destroy
    @placement_exam.destroy
    redirect_to placement_exams_path
    flash[:notice] = 'Placement exam was successfully destroyed.'
  end

  # this method hold all question type
  def question_type
    @type = params[:type]
  end

  # this method is ued for display conduct exam and display exam time
  def disp_time
    @placement_exam = PlacementExam.find(params[:exam_id])
    @company = Company.find(params[:company_id])
    @questions = Company.conduct_exam(@company, @placement_exam)
    @time = @placement_exam.timeperiod.strftime('%M').to_i
  end

  # this method is used to publish result 
  def publish_result
    @placement_exam = PlacementExam.all
  end

  # This method is used to display result
  # find out company,find out placementexam and then get score
  # for that placement exam
  def display_result
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:p_id])
    @student_score = StudentScore.where(placement_exams_id: @placement_exam)
  end

  # this method used for display qualified students for perticular
  # company an dcreate placement news for qualified students
  def qualify_student
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:exam_id])
    qualify_student = params[:qualify]
    title = "congratulations you are  short \
              listed for next round of " + @company.name
    qualify_student.each do |i|
      @student = StudentScore.where(student_id: i, placement_exams_id: @placement_exam).take.update(is_qualify: true)
      content = Student.find(i).full_name
      PlacementNews.create(title: title, content: content)
    end
    flash[:notice] = 'Student short-listed successfully'
    redirect_to placement_exams_path
  end

  # this method check for qualified students
  def qualified_student
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:exam_id])
    @score = StudentScore.where(placement_exams_id: @placement_exam)
    @student_score = @score.where(is_qualify: true)
  end

  private

  def set_placement_exam
    @placement_exam = PlacementExam.find(params[:id])
  end

  def placement_exam_params
    params.require(:exam).permit!
  end
end
