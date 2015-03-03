class FinanceFeeCollection < ActiveRecord::Base
  include Activity
  belongs_to :batch
  belongs_to :finance_fee_category
  has_many :fee_collection_particulars
  has_many :fee_collection_discounts
  has_many :finance_fees
  has_many :students, through: :finance_fees
  validates :name, presence: true, length: { minimum: 1, maximum: 30 }, format: { with: /\A[a-z A-Z 0-9_.-\/]+\z/ }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :due_date, presence: true
  validate :end_date_cannot_be_less_than_start_date
  validate :due_date_cannot_be_less_than_end_date
  validate :date_cannot_be_in_past
  scope :shod, ->(id) { where(id: id).take }
  def end_date_cannot_be_less_than_start_date
    if end_date.present? && end_date < start_date
      errors.add(:end_date, "can't be less than start date")
    end
   end

  def due_date_cannot_be_less_than_end_date
    if due_date.present? && due_date < end_date
      errors.add(:due_date, "can't be less than end date")
    end
   end

  def date_cannot_be_in_past
    if start_date.present? && start_date < Date.today
      errors.add(:start_date, "can't be in past")
      end

    if end_date.present? && end_date < Date.today
      errors.add(:end_date, "can't be in past")
      end

    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "can't be in past")
     end
   end

  # This action is subpart of the action 'self.fee' and save the data
  # into the collection particular. 
  def create_collection_particular(batch, master_category)
    fee_particulars = master_category.finance_fee_particulars.where(batch_id: batch)
    unless fee_particulars.nil?
      fee_particulars.each do |p|
        if collection_particular = fee_collection_particulars.create(name: p.name, description: p.description, amount: p.amount, category_id: p.category_id, admission_no: p.admission_no, batch_id: batch)
          collection_particular.student_fee_collection
        end
      end
    end
  end

  # This action is subpart of the action 'self.fee' and save the data
  # into the collection discount.
  def create_fee_collection_discount(batch, master_category)
    discounts = master_category.fee_discounts.where(batch_id: batch)
    unless discounts.nil?
      discounts.each do |d|
        if collection_discount = fee_collection_discounts.create(type: d.type, name: d.name, discount: d.discount, category_id: d.category_id, admission_no: d.admission_no, batch_id: batch)
          collection_discount.student_fee_collection_discount
        end
      end
    end
  end

  # check the due date must be less than today's date.
  def is_due_date?
    if due_date < Date.today
      return true
    else
      return false
    end
  end

  # This action save the fee collection record and return the error.
  def self.fee(params, batches)
    error = true
    if batches.present?
      batches.each do |b|
        collection = new(params)
        if collection.create_fee(b)
          error = false
        end
      end
    end
    error
  end

  # this action is used to save the collection particular record and
  # fee collection discount after creating fees particular.
  def create_fee(batch)
    self.batch_id = batch
    category = finance_fee_category
    if save
      create_collection_particular(batch, category)
      create_fee_collection_discount(batch, category)
    end
  end

  # This action fetch the first record from finance fees
  # for selected student id.
  def previous(student)
    finance_fees.where(student_id: student.id).take.id - 1
  end

  # This action fetch the first record from finance fees
  # for selected student id.
  def next(student)
    finance_fees.where(student_id: student.id).take.id + 1
  end

  # This action fetch the first record from finance fees
  # for selected student id.
  def fee(student)
    finance_fees.where(student_id: student.id).take
  end
end
