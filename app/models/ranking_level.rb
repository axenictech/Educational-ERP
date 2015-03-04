# RankingLeve model
class RankingLevel < ActiveRecord::Base
  include Activity
  belongs_to :course
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9+_" "-]+\Z/ }
  validates :marks, presence: true, numericality: { only_decimal: true, less_than: 100 }
  validates :subject_count, presence: true, numericality: { only_integer: true, less_than: 20 }
  scope :shod, ->(id) { where(id: id).take }
end
