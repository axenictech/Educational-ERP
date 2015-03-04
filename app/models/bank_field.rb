# BankField model
class BankField < ActiveRecord::Base
  include Activity
  validates :name, presence: true,
                   length: { minimum: 1, maximum: 50 }, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }
  scope :is_status, -> { where(status: true).order(:name) }
  scope :not_status, -> { where(status: false).order(:name) }
  scope :shod, ->(id) { where(id: id).take }
end
