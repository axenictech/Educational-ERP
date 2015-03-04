# OnlineExamQuestion model
class OnlineExamQuestion < ActiveRecord::Base
  include Activity
  belongs_to :online_exam
  scope :shod, ->(id) { where(id: id).take }
end
