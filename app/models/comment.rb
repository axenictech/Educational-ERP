# Comment model
class Comment < ActiveRecord::Base
  include Activity
  belongs_to :newscast
  belongs_to :user
  validates :statement, presence: true, length: { minimum: 1, maximum: 100 }
  scope :shod, ->(id) { where(id: id).take }
end
