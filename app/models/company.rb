# Company Model
class Company < ActiveRecord::Base
  include Activity
  validates :name, presence: true, length: { \
    minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9" "-]+\Z/ }
  validates :criteria, presence: true, length: { minimum: 1, maximum: 9000 }

  # this method used for conduct exam ,first find tot question
  # find weightage for each question ,calculate percentage,caluclate
  # question limit for this exam and return question
  def self.conduct_exam(_company, exam)
    questions = []
    @questions = []
    tot_que = exam.question_count
    exam.weightages.each do |i|
      pr = Weightage.where(question_type_id: i.question_type_id,
                           placement_exam_id: exam.id).take.percentage
      quest = (tot_que.to_i * pr.to_i) / 100
      questions << [i.question_type_id, quest]
    end
    questions.each do |q|
      ques = QuestionDatabase.where(question_type_id: q[0]).limit(q[1])
      ques.each do |que|
        @questions << que
      end
    end
    @questions
  end
end
