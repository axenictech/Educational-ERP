class Attendence < ActiveRecord::Base
  belongs_to :student
  belongs_to :time_table_entry
  belongs_to :batch
  belongs_to :subject
  validates :reason, presence: true, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-zA-Z0-9._" "-]+\Z/ }
  scope :shod, ->(id) { where(id: id).take }
end
