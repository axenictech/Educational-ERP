# GradingLevel model
class GradingLevel < ActiveRecord::Base
  include Activity
  belongs_to :batch
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9+_" "-]+\Z/ }
  validates :min_score, presence: true, numericality: { only_integer: true, less_than: 100 }
  validates :description, presence: true, length: { minimum: 1, maximum: 30 }
  scope :shod, ->(id) { where(id: id).take }
end
