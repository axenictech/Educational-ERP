# Guardian
class Guardian < ActiveRecord::Base
  belongs_to :country
  belongs_to :student
  validates :email, presence: true, format: { with: /\A[a-zA-Z0-9._-]+@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,4}+\z/ }, allow_blank: true
  validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates_length_of :first_name, minimum: 1, maximum: 20

  validates :last_name, presence: true, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }
  validates_length_of :last_name, minimum: 1, maximum: 20

  validates :relation, presence: true, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }
  validates_length_of :relation, minimum: 1, maximum: 20
  validates :country_id, presence: true
  validates :office_phone1, presence: true, numericality: { only_integer: true }, length: { minimum: 6, maximum: 11 }, allow_blank: true
  validates :office_phone2, numericality: { only_integer: true }, length: { minimum: 6, maximum: 11 }, allow_blank: true
  validates :office_address_line1, length: { in: 1..20 }, allow_blank: true
  validates :office_address_line2, length: { in: 1..20 }, allow_blank: true
  validates :city, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }, length: { in: 1..20 }, allow_blank: true
  validates :occupation, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }, length: { in: 1..20 }, allow_blank: true
  validates :income, numericality: { only_integer: true }, length: { in: 1..10 }, allow_blank: true
  validates :education, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' },
                        length: { in: 1..20 }, allow_blank: true
  scope :shod, ->(id) { where(id: id).take }
  scope :discover, ->(s, r) { where(student_id: s, relation: r).take }

  def student_name
    [first_name, last_name].join(' ')
  end

  # This action create the user account for parent for selected student.
  def create_user_account
    user = User.new do |u|
      u.first_name = first_name
      u.last_name = last_name
      u.username = email
      u.student_id = student.id
      u.password = 'P' + student.admission_no
      u.role = 'Parent'
      u.email = email
      u.general_setting_id =  User.current.general_setting.id
    end
    user.save
    p user.errors
  end

  private

  HUMANIZED_ATTRIBUTES = {
    email: 'Email Address',
    office_phone1: 'Contact number',
    office_phone2: 'Office phone number'
  }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
