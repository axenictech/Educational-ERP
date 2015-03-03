class FinanceDonation < ActiveRecord::Base
  include Activity
  belongs_to :finance_transaction
  validates :donor, presence: true, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/ }
  validates :description, presence: true, length: { minimum: 1, maximum: 50 }
  validates :amount, presence: true, numericality: true
  validates :transaction_date, presence: true
  scope :shod, ->(id) { where(id: id).take }
  
  # This action called by finance controller for save the data into
  # finance transaction table when donor is created.
  def create_transaction
    category = FinanceTransactionCategory.find_by_name('Donation')
    transaction = category.finance_transactions.create(title: donor\
      , description: description, amount: amount\
      , transaction_date: transaction_date)
    update(finance_transaction_id: transaction.id)
  end

  # This action called by finance controller for update the data into
  # finance transaction table whin donor is updated.
  def update_transaction
    finance_transaction.update(title: donor, description: description\
      , amount: amount, transaction_date: transaction_date)
  end
end
