# EmployeePosition model
class EmployeePosition < ActiveRecord::Base
  include Activity
  belongs_to :employee_category
  validates :name, presence: true,
                   length: { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/, message: 'allows Alphanumeric with _, ., -, /' }

  validates :employee_category, presence: true
  scope :is_status, -> { where(status: true).order(:name) }
  scope :not_status, -> { where(status: false).order(:name) }
  scope :shod, ->(id) { where(id: id).take }
end
