# Option model
class Option < ActiveRecord::Base
  include Activity
  belongs_to :question
  belongs_to :question_database
  # validates :is_answer, presence: true
end
