# BatchesOnlineExam model
class BatchesOnlineExam < ActiveRecord::Base
  include Activity
  belongs_to :batch
  belongs_to :online_exam
  scope :shod, ->(id) { where(id: id).take }
end
