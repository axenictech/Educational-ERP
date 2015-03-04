# FeeCollectionParticular model
class FeeCollectionParticular < ActiveRecord::Base
  include Activity
  belongs_to :finance_fee_collection
  belongs_to :category
  belongs_to :batch
  has_and_belongs_to_many :students
  scope :shod, ->(id) { where(id: id).take }

  # This action generate the different collection for different student.
  # e.g. collection is generating according to student admission number,
  # student category and for whole student.
  def student_fee_collection
    students = []
    @batch = batch
    if admission_no.present?
      students << @batch.students.find_by_admission_no(admission_no)
    elsif category.present?
      students = @batch.students.where(category_id: category.id)
    else
      students = @batch.students
    end
    if students.any?
      students.each do |s|
        student_fee = FeeCollectionParticularsStudent.new
        student_fee.student_id = s.id
        student_fee.fee_collection_particular_id = id
        if student_fee.save
          student_fee.create_finance_fee(finance_fee_collection.id, s.id)
        end
      end
    end
  end

  # Fetch the student number by admission number and return the
  # student full name.
  def student_name
    student = Student.find_by_admission_no(admission_no)\
     if admission_no.present?
    student.first_name + ' ' + student.last_name
  end
end
