# EmployeeCategory model
class EmployeeCategory < ActiveRecord::Base
  include Activity
  has_many :employee_positions
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9_" "-]+\Z/ }\
  , length: { minimum: 1, maximum: 50 }
  validates :prefix, presence: true, format: { with: /\A[a-zA-Z0-9]+\Z/ }\
  , length: { minimum: 1, maximum: 20 }
  scope :shod, ->(id) { where(id: id).take }
  scope :is_status, -> { where(status: true).order(:name) }
  scope :not_status, -> { where(status: false).order(:name) }
end
