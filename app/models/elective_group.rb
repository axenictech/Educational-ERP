# ElectiveGroup model
class ElectiveGroup < ActiveRecord::Base
  include Activity
  belongs_to :batch
  has_many :subjects
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, format: \
  {  with: /\A[a-zA-Z0-9#+_" "-]+\Z/ }
  scope :shod, ->(id) { where(id: id).take }
end
