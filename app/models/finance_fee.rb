class FinanceFee < ActiveRecord::Base
  include Activity
  belongs_to :finance_fee_collection
  belongs_to :student
  has_many :finance_transactions
  has_many :finance_fines
  scope :shod, ->(id) { where(id: id).take }
  def create_fine(fine)
    date = Date.today
    finance_fines.create(fine: fine, fine_date: date)
  end

  # This action called from finance controller. this action save the record
  # into the finance fee table when student pay fee.
  def create_transaction(amount, fine)
    student = self.student
    collection = finance_fee_collection
    category = FinanceTransactionCategory.find_by_name('Fees')
    t = category.finance_transactions.new
    t.title = "#{student.first_name + ' ' + student.last_name}"
    t.description = "#{collection.name + ' ' + collection.start_date.to_s}"
    t.amount = amount
    t.transaction_date = Date.today
    t.student_id = student.id
    t.finance_fee_id = id
    t.fine_included = fine
    t.save
  end

  # This action perform the addition operation on payment.
  # Transaction amount is added into the payment
  def payment
    payment = 0
    transactions = finance_transactions
    unless transactions.nil?
      transactions.each do |t|
        payment += t.amount
      end
    end
    payment
  end
end
