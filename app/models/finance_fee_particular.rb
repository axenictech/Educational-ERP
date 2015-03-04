# FinanceFeeParticular model
class FinanceFeeParticular < ActiveRecord::Base
  include Activity
  belongs_to :finance_fee_category
  belongs_to :category
  validates :name, presence: true, length: { minimum: 1, maximum: 30 }\
  , format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/ }
  validates :description, presence: true, length: { minimum: 1, maximum: 50 }
  validates :admission_no, length: { minimum: 1, maximum: 30 }\
  , numericality: { only_integer: true }, allow_blank: true
  validates :amount, length: { minimum: 1, maximum: 20 }\
  , numericality: true, allow_blank: true
  scope :shod, ->(id) { where(id: id).take }

  # This action is called from action 'create_fees_particular' in
  # finance controller. This action is save the data in finance fee
  # particular.
  def self.create_fee(params, batches, mode, adm_no, cat_id)
    error = 1
    if batches.present?
      batches.each do |b|
        fee = new(params)
        fee.set(mode, adm_no, cat_id, b)
        error = 0 if fee.save
      end
    end
    error
  end

  # This action is subpart of the self.create action.
  # This action used to set the value for admission no,
  # batch id, category id.
  def set(mode, adm_no, cat_id, batch)
    if mode == 'admission_no'
      self.admission_no, self.batch_id = adm_no, batch
    elsif mode == 'category'
      self.category_id, self.batch_id = cat_id[:id], batch
    else
      self.batch_id = batch
    end
  end
end
