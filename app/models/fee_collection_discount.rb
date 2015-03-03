class FeeCollectionDiscount < ActiveRecord::Base
  include Activity
  self.inheritance_column = nil
  belongs_to :finance_fee_collection
  belongs_to :batch
  belongs_to :category
  has_and_belongs_to_many :students
  scope :shod, ->(id) { where(id: id).take }

  # This action generate the different discount for different type.
  # e.g. discount is generating according to student admission number,
  # student category and for whole student.
  def student_fee_collection_discount
    students = []
    @batch = batch
    if type == 'Student'
      students << @batch.students.find_by_admission_no(admission_no)
    elsif type == 'Student Category'
      students = @batch.students.where(category_id: category.id)
    else
      students = @batch.students
    end
    if students.any?
      students.each do |s|
        student_discount = FeeCollectionDiscountsStudent.new
        student_discount.student_id = s.id
        student_discount.fee_collection_discount_id = id
        student_discount.save
      end
    end
  end

  # Calculating collection discount on user inputed total value.
  def collection_discount(total)
    (discount * total) / 100
  end

  def student_name
    student = Student.find_by_admission_no(admission_no)\
     if type == 'Student'
    student.first_name + ' ' + student.last_name
  end
end
