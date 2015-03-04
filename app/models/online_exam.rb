# OnlineExam model
class OnlineExam < ActiveRecord::Base
  include Activity
  # belongs_to :online_exam_group
  has_many :online_exam_questions
  has_and_belongs_to_many :batches
  scope :shod, ->(id) { where(id: id).take }
end
