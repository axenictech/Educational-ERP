# ExamScore model
class ExamScore < ActiveRecord::Base
  include Activity
  belongs_to :student
  belongs_to :exam
  belongs_to :grading_level
  validates :marks, numericality: true, allow_blank: true
  validates :remarks, length: { minimum: 1, maximum: 30 }, format: \
  { with: /\A[a-zA-Z0-9._" "-\/]+\Z/ }, allow_blank: true
  validate :marks_cant_be_greater_than_maximum_marks
  validate :marks_cant_be_negative
  scope :shod, ->(id) { where(id: id).take }
  scope :exrep, ->(ex, st) { where(exam_id: ex.id, student_id: st).take }
  scope :score, ->(s, e) { where(student_id: s, exam_id: e).take }
  
  # this validation is for exam_score,
  # exam_score of particular student shuold not be negative
  def marks_cant_be_negative
    if  marks.present? && marks < 0
      errors.add(:marks, 'cannot be negative')
    end
  end
  
  # this validation is for exam_score,
  # exam_score of particular student should
  # not be grater than maximum marks of that exam
  def marks_cant_be_greater_than_maximum_marks
    unless exam.exam_group.exam_type == 'Grades'
      if  marks.present? && marks > exam.maximum_marks
        errors.add(:marks, 'cannot be greater than maximum marks')
      end
    end
  end

  # This action calculate the percentage and manage the floating point.
  def calculate_percentage
    '%0.2f' % (marks.to_f * 100 / exam.maximum_marks.to_f)
  end
end
