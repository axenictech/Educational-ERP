# FeeCollectionParticulrsStudent model
class FeeCollectionParticularsStudent < ActiveRecord::Base
  include Activity
  belongs_to :student
  belongs_to :fee_collection_particular
  scope :shod, ->(id) { where(id: id).take }

  # This action create a new object for insert the finance fee
  # and generate the fee receipt number.
  def create_finance_fee(collection, student)
    last_receipt_no = FinanceFee.last.receipt_no if FinanceFee.last
    fee = FinanceFee.new
    fee.finance_fee_collection_id = collection
    fee.student_id = student
    fee.is_paid = false
    if last_receipt_no.nil?
      fee.receipt_no = 001
    else
      fee.receipt_no = last_receipt_no.next
    end
    fee.save
  end
end
