class ArchivedStudent < ActiveRecord::Base
  include Activity
  belongs_to :country
  belongs_to :batch
  belongs_to :category
  belongs_to :nationality, class_name: 'Country'
  has_one :student_previous_data
  has_many :student_previous_subject_marks
  has_many :guardians
  has_attached_file :image
  validates_attachment_content_type :image, content_type: \
  ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
  scope :shod, ->(id) { where(id: id).take }

  def mail(subject, recipient, message)
    user = User.discover(student_id, recipient)
    UserMailer.student_email(user, subject, message).deliver
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
