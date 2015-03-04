# StudentExam model
class StudentExam < ActiveRecord::Base
  include Activity
  belongs_to :placement_exams
  belongs_to :students
end
