# Batch Event model
class BatchEvent < ActiveRecord::Base
  include Activity
  belongs_to :batch
  belongs_to :event
  scope :shod, ->(id) { where(id: id).take }
end
