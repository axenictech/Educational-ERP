# StudentLog model
class StudentLog < ActiveRecord::Base
  belongs_to :student
  belongs_to :subject
  belongs_to :exam_group
  belongs_to :batch
end
