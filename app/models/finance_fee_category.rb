# FinanceFeeCategory model
class FinanceFeeCategory < ActiveRecord::Base
  include Activity
  has_and_belongs_to_many :batches
  has_many :finance_fee_particulars
  has_many :fee_discounts
  has_many :finance_fee_collections
  validates :name, presence: true, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/ }
  validates :description, presence: true, length: { minimum: 1, maximum: 50 }
  scope :shod, ->(id) { where(id: id).take }

  # This action is called by 'create_master_category' in
  # finance controller. when master categoy is insert then
  # batched fee category is also created.
  def fee_category(batches)
    return unless batches.present?
    batches.each do |b|
      BatchesFinanceFeeCategory.create(batch_id: b, finance_fee_category_id: id)
    end
  end

  # This action fetch the data from finance fee particular according
  # to batch id.
  def particulars(batch_id)
    finance_fee_particulars.where(batch_id: batch_id)
  end

  # This action fetch the data from finance fee discounts according
  # to batch id.
  def discounts(batch_id)
    fee_discounts.where(batch_id: batch_id)
  end
end
