# PlacementExamsController
class PlacementExamsController < ApplicationController
  before_action :set_placement_exam, only: [:show, :edit, :update, :destroy]

  def index
    @placement_exam = PlacementExam.all
    @placement_news = PlacementNews.all
  end

  def insert
    @companies = Company.all
    @placement_news = PlacementNews.all
  end

  def apply_exam
    @companies = Company.all
    @placement_news = PlacementNews.all
  end

  def create_exam
    @exam = PlacementExam.new
    @company = Company.all
    @placement_exam = PlacementExam.new
  end

  def insert_exam
    question_type = params[:question_type]
    percentage = params[:percentages]
    if percentage.map(&:to_i).sum == 100
      @placement_exam = PlacementExam.new(placement_exam_params)
      @placement_exam.save
      i = 0
      question_type.each do |q|
        Weightage.create(question_type_id: q, placement_exam_id: @placement_exam.id, percentage: percentage[i])
        i += 1
      end
      redirect_to create_exam_placement_exams_path
      flash[:notice] = t('placement_exam_created')
    else
      render 'create_exam'
      flash[:alert] = t('placement_exam_error')
    end
  end

  def question_paper
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:p_id])
  end

  def save_test
    @test = params[:question]
    @placement_exam = PlacementExam.find(params[:placement_exam_id])
    @student = Student.find(params[:student_id])
    @score = PlacementExam.calculateres(@test, @placement_exam.id, @student)
  end

  def exam
  end

  def placement_tpo
    @placement_exams = PlacementExam.all
  end

  def setting_index
  end

  def new
    @placement_exam = PlacementExam.new
  end

  def edit
  end

  def create
    @placement_exam = PlacementExam.new(placement_exam_params)
    @placement_exam.save
  end

  def update
    if @placement_exam.update(placement_exam_params)
      redirect_to @placement_exam
      flash[:notice] = 'Placement exam was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @placement_exam.destroy
    redirect_to placement_exams_path
    flash[:notice] = 'Placement exam was successfully destroyed.'
  end

  def question_type
    @type = params[:type]
  end

  def disp_time
    @placement_exam = PlacementExam.find(params[:exam_id])
    @company = Company.find(params[:company_id])
    @questions = Company.conduct_exam(@company, @placement_exam)
    @time = @placement_exam.timeperiod.strftime('%M').to_i
  end

  def publish_result
    @placement_exam = PlacementExam.all
  end

  def display_result
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:p_id])
    @student_score = StudentScore.where(placement_exams_id: @placement_exam)
  end

  def qualify_student
    @company = Company.find(params[:id])
    @placement_exam = PlacementExam.find(params[:exam_id])
    qualify_student = params[:qualify]
    title = "congratulations you are  short \
              listed for next round of " + @company.name
    qualify_student.each do |i|
      @student = StudentScore.where(student_id: i,placement_exams_id: @placement_exam).take.update(is_qualify: true)
      content = Student.find(i).full_name
      PlacementNews.create(title: title, content: content)
    end
    flash[:notice] = 'Student short-listed successfully'
    redirect_to placement_exams_path
  end

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
