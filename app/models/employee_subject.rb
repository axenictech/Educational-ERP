# EmployeeSubject
class EmployeeSubject < ActiveRecord::Base
  include Activity
  belongs_to :employee
  belongs_to :subject
  has_one :batch, through: :subject
  scope :shod, ->(id) { where(id: id).take }

  def self.assign_emp(sub)
    where(subject_id: sub.id)
  end

  scope :ass_emp, -> (emp, sub) \
  { create(employee_id: emp.id, subject_id: sub.id) }

  scope :rem_emp, -> (emp1, sub1) \
  { where(employee_id: emp1.id, subject_id: sub1.id) }

  scope :dest, -> (emp2, sub2) \
  { destroy_all(employee_id: emp2.id, subject_id: sub2.id) }

  scope :ass_emp1, -> (sub) { where(subject_id: sub.id) }
  scope :rem_emp2, -> (sub2) { where(subject_id: sub2.id) }

  # use in timetable controller
  # create and save employee and releted subject in database.
  def self.allot_work(employee_subj_ids)
    status, error_carrier = false, new
    transaction do
      emp_subjs = []
      employee_subj_ids.each do |subj_id, emp_id|
        subject_asso = find_or_create_by(subject_id: subj_id)
        subject_asso.employee_id = emp_id
        subject_asso.save
        emp_subjs << subject_asso
      end
    end
  end
end
