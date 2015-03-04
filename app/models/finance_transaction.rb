# FinacneTransaction model
class FinanceTransaction < ActiveRecord::Base
  include Activity
  belongs_to :finance_transaction_category
  has_one :finance_donation
  belongs_to :finance_fee
  validates :title, presence: true, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/ }
  validates :description, presence: true, length: { minimum: 1, maximum: 50 }
  validates :amount, presence: true, numericality: true
  validates :transaction_date, presence: true
  validates :finance_transaction_category_id, presence: true
  scope :shod, ->(id) { where(id: id).take }
  scope :list, ->(s, e) \
  { includes(:finance_transaction_category).where(transaction_date: s..e) }
end
