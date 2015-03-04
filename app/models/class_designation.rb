# ClassDesignation model
class ClassDesignation < ActiveRecord::Base
  include Activity
  belongs_to :course
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9" "-]+\Z/ }
  validates :marks, presence: true, numericality: true
  scope :shod, ->(id) { where(id: id).take }
end
