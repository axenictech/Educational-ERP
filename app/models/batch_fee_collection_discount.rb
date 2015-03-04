# BatchFeeCollectionDiscount model
class BatchFeeCollectionDiscount < ActiveRecord::Base
  include Activity
  scope :shod, ->(id) { where(id: id).take }
end
