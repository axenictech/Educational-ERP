# Privilege model
class Privilege < ActiveRecord::Base
  include Activity
  has_many :privilege_users
  has_many :users, through: :privilege_users
  belongs_to :privilege_tag
  scope :shod, ->(id) { where(id: id).take }
end
