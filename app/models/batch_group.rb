# Batch Group Model
class BatchGroup < ActiveRecord::Base
  include Activity
  belongs_to :course
  has_many :group_batches, dependent: :destroy
  validates :name, presence: true, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-zA-Z0-9_" "-\/]+\Z/ }
  scope :shod, ->(id) { where(id: id).take }

  # get all selected batch and create BatchGroup
  # create_group_batch action is saving our BatchGroup to the database.
  def create_group_batch(batches, batch_group)
    batches.each  do |batch|
      GroupBatch.create(batch_group_id: batch_group.id, batch_id: batch)
    end
  end
end
