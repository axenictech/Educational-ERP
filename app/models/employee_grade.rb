class EmployeeGrade < ActiveRecord::Base
  include Activity
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, format: { with: /\A[a-z A-Z+-]+\z/, message: 'only allows letter' }

  validates :priority,  numericality: { only_integer: true, greater_than: 0, less_than: 20 }, uniqueness: true
  validates :max_hours_day, numericality: { only_integer: true, greater_than_equal: 0, less_than: 20 }

  validates :max_hours_week,  numericality: { only_integer: true, greater_than_equal: 0, less_than: 30 }
  scope :is_status, -> { where(status: true).order(:name) }
  scope :not_status, -> { where(status: false).order(:name) }
  scope :shod, ->(id) { where(id: id).take }

  HUMANIZED_ATTRIBUTES = {
    max_hours_week: 'Max periods per week',
    max_hours_day: 'Max periods per day'
  }

  private

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
