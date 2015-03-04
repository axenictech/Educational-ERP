# GroupBatch model
class GroupBatch < ActiveRecord::Base
  include Activity
  belongs_to :batch_group
  scope :shod, ->(id) { where(id: id).take }
end
