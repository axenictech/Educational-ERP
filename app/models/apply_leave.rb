# Apply leave
class ApplyLeave < ActiveRecord::Base
  include Activity
  scope :shod, ->(id) { where(id: id).take }
end
