# FeeCollectionDiscountsStudent model
class FeeCollectionDiscountsStudent < ActiveRecord::Base
  include Activity
  belongs_to :student
  belongs_to :fee_collection_discount
  scope :shod, ->(id) { where(id: id).take }
end
