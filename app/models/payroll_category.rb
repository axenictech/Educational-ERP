# PayrollCategory model
class PayrollCategory < ActiveRecord::Base
  include Activity
  has_many :employee_salery_structures
  validates :name, presence: true, length: { minimum: 1, maximum: 35 }, format: { with: /\A[a-zA-Z' '-]+\Z/ }
  validates :percentage, numericality: { integer_and_decimal: true, greater_than: 0, less_than_equal: 100 }, allow_blank: true
  scope :is_deduction, -> { where(is_deduction: true).order(:name) }
  scope :not_deduction, -> { where(is_deduction: false).order(:name) }
  scope :shod, ->(id) { where(id: id).take }

  # update status of payroll category
  def active
    update(status: false)
  end

   # update status of payroll category
  def inactive
    update(status: true)
  end
end
