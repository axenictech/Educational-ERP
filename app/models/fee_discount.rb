class FeeDiscount < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :finance_fee_category
  belongs_to :batch
  belongs_to :category

  validates :name, presence: true, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/ }
  validates :admission_no, length: { minimum: 1, maximum: 30 }\
  , numericality: { only_integer: true }, allow_blank: true
  validates :discount, presence: true, length: { minimum: 1, maximum: 20 }\
  , numericality: true
  scope :shod, ->(id) { where(id: id).take }

  def create_discount(batches, adm_no, cat_id)
    return if batches.present?
    batches.each do |b|
      set(adm_no, cat_id, b)
    end
    save ? true : false
  end

  def set(adm_no, cat_id, batch)
    if type == 'Student'
      self.admission_no, self.batch_id = adm_no, batch
    elsif type == 'Student Category'
      self.category_id, self.batch_id = cat_id, batch
    else
      self.batch_id = batch
    end
  end
end
