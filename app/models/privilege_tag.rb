# PrivilegeTag model
class PrivilegeTag < ActiveRecord::Base
  include Activity
  has_many :privileges
  scope :shod, ->(id) { where(id: id).take }
end
