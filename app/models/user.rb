# User model
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :privilege_users
  has_many :privileges, through: :privilege_users
  has_many :newscasts
  has_many :comments
  belongs_to :general_setting
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :timeoutable, :trackable
  validates :username, presence: true, uniqueness: true, length: \
  { in: 1..50 }, format: \
  { with: /\A[a-zA-Z" "]+\Z/ }
  validates :first_name, presence: true, length: { in: 1..25 }, format: \
  { with: /\A[a-zA-Z" "]+\Z/ }
  validates :last_name, presence: true, length: { in: 1..25 }, format: \
  { with: /\A[a-zA-Z" "]+\Z/ }
  scope :shod, ->(id) { where(id: id).take }
  scope :role_wise_users, ->(role) { where(role: role) }
  scope :discover, ->(i, r) { where(student_id: i, role: r).take }

  # Method for return full name
  def full_name
    first_name + ' ' + last_name
  end


  # create_general_setting action is saving our new general_setting
  # to the database.
  def create_general_setting
    role = 'Admin'
    role = 'SuperAdmin' if id == 1
    gs = GeneralSetting.create(school_or_college_name: 'Axenic School')
    update(general_setting_id: gs.id, role: role)
  end

  # get institute name
  def institute_name
    general_setting.school_or_college_name
  end

  # getter for current user
  def self.current
    Thread.current[:user]
  end

  # setter for current user
  def self.current=(user)
    Thread.current[:user] = user
  end

  # Method for find student role and return
  def student
    return unless role == 'Student' || role == 'Parent'
    std = ArchivedStudent.where(student_id: student_id).take
    std = Student.shod(student_id) if std.nil?
    std
  end
 
  # method return if role is employeee
  def employee
    return unless role == 'Employee'
    Employee.shod(employee_id)
  end

  # method for search user from first name or last name
  # and return result
  def self.search_user(search)
    return if search.empty?
    where("concat_ws(' ',first_name,last_name)like ? \
      OR concat_ws(' ',last_name,first_name)like ? \
      OR username like ?", "#{search}%", "#{search}%", "#{search}%")
  end
end
