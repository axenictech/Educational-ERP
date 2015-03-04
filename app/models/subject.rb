# Subject model
class Subject < ActiveRecord::Base
  include Activity
  belongs_to :batch
  belongs_to :elective_group
  has_many :timetable_entries, foreign_key: 'subject_id'
  has_many :employee_subjects
  has_many :employees, through: :employee_subjects
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9#&+_" "-]+\Z/ }
  validates_length_of :name, minimum: 1, maximum: 80
  validates :code, presence: true, length: \
  { minimum: 1, maximum: 10 }, format: { with: /\A[a-zA-Z0-9_" "-]+\Z/ }
  validates :max_weekly_classes, presence: true, length: \
  { maximum: 2 }, numericality: { only_integer: \
  true, less_than: 20, greater_than: 0 }
  scope :shod, ->(id) { where(id: id).take }
  scope :exam, -> { where(no_exams: false) }

  # Method used for assign subject to student,
  # first find out studentsubject destroy all student subject if present else
  # create student subject
  def assign_subject(students)
    batch = elective_group.batch
    student_subject = StudentSubject.where(subject_id: id)
    if students.present?
      student_subject.each(&:destroy) unless student_subject.empty?
      students.each  do |s|
        StudentSubject.create(batch_id: batch.id, subject_id: id, student_id: s)
      end
    else
      student_subject.each(&:destroy)
    end
  end

  # return subject name by concating name and code
  def subject_name
    [name, code].join(' ')
  end

  # return exam score for student of selectd exam
  def exam_scores(exam)
    ExamScore.where(exam_id: exam, student_id: id).take
  end

  # return full name by concating first name and last name
  def full_name
    [first_name, last_name].join(' ')
  end

  # def valid?(student)
  #   student ? id2 = student.student_id : id2 = 1
  #   result = true
  #   unless elective_group_id.nil?
  #     result = false if StudentSubject.where(student_id: id2\
  #     , subject_id: id).take.nil?
  #   end
  #   result
  # end
end
