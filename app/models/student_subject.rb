# StudentSubject model
class StudentSubject < ActiveRecord::Base
  include Activity
  belongs_to :student
  belongs_to :subject
  scope :shod, ->(id) { where(id: id).take }
  scope :test, ->(s, e) { where(student_id: s.id, subject_id: e.exam.subject.id).take }
end
