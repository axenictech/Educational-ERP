# PlacementExam model
class PlacementExam < ActiveRecord::Base
  include Activity
  belongs_to :company
  has_many :weightages
  has_many :student_scores
  validates :company_id, presence: true
  validates :question_count,
            presence: true, numericality: { only_integer: true }

  # this method used for create exam and calculate result ,first create exam for
  # for student ,check answersheet and option for perticular question
  # count correct answer and wrong answer.insert  score of student into
  # StudentScore and calculate final result and return it
  def self.calculateres(test, exam, student)
    final_res = []
    question_types = []
    tot_question_types = []
    StudentExam.create(placement_exams_id: exam,
                       students_id: student.id)
    student_exam = StudentExam.where(students_id: student).take
    i = 0

    test.each do |t|
      StudentAnswerSheet.create(student_exams_id: student_exam.id,
                                question_databases_id: t[0],
                                options_id: t[1])
      ans = Option.where(question_database_id: t[0].to_i,
                         id: t[1].to_i).take

      if ans.is_answer == true
        i += 1
        question_types << ans.question_database.question_type_id
      end
    end
    result = PlacementExam.tot_per(question_types, exam)
    final_res << result
    StudentScore.create(placement_exams_id: exam,
                        student_id: student.id, score: i.to_f)
    score = StudentScore.where(student_id: student.id,
                               placement_exams_id: exam).take
    final_res << score.score

    final_res
  end

  # this method is used for calculate percentage of each
  # question type and return all question type and appropriate
  # percentage
  def self.tot_per(question_types, exam)
    result = []
    types = Weightage.where(placement_exam_id: exam)
    types.each do |i|

      total = i.placement_exam.question_count.to_f
      ans = question_types.select { |o| o == i.question_type_id }.count.to_f
      if total == 0
        per = 0
      else
        per = (ans * 100 / total)
      end
      result << [i.question_type.que_type, per]
    end

    result
  end
end
