# Liability model
class Liability < ActiveRecord::Base
  include Activity
  validates :title, presence: true, length: { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z]+\z/ }
  validates :description, presence: true, length: { minimum: 1, maximum: 50 }
  validates :amount, presence: true, numericality: true
  scope :shod, ->(id) { where(id: id).take }
end
