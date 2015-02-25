# Event model
class Event < ActiveRecord::Base
  include Activity
  has_many :batch_events
  has_many :batches, through: :batch_events
  has_many :employee_department_events
  has_many :employee_departments, through: :employee_department_events
  validates :title, presence: true, length: { in: 1..10 }
  scope :shod, ->(id) { where(id: id).take }

  def create_event(batches, departments)
    if is_common?
      common_to_all
    else
      batches_event(batches)
      departments_event(departments)
    end
  end

  def common_to_all
    Batch.all.each do |batch|
      BatchEvent.create(batch_id: batch.id, event_id: id)
    end
    EmployeeDepartment.all.each do |dept|
      EmployeeDepartmentEvent.create(employee_department_id: \
        dept.id, event_id: id)
    end
  end

  def batches_event(batches)
    return if batches.nil?
    batches.each do |batch|
      BatchEvent.create(batch_id: batch, event_id: id)
    end
  end

  def departments_event(departments)
    return if departments.nil?
    departments.each do |dept|
      EmployeeDepartmentEvent.create(employee_department_id: \
      dept, event_id: id)
    end
  end
end
