class Batch < ActiveRecord::Base
  include Activity
  validates :name, presence: true, length: { minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9.\/_" "-]+\Z/ }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_cannot_be_less_than_start_date
  belongs_to :course
  has_many :students
  has_many :class_timings
  has_many :archived_students
  has_many :grading_levels
  has_many :elective_groups
  has_many :subjects
  has_many :weekdays
  has_many :batch_events
  has_many :events, through: :batch_events
  has_many :exam_groups
  has_and_belongs_to_many :finance_fee_categories
  has_and_belongs_to_many :online_exams
  has_many :finance_fee_collections
  has_many :student_informations
  scope :shod, ->(id) { where(id: id).take }

  # Collect the subjects which are selected for exams.
  def exam
    subjects.where(no_exams: false)
  end

  def end_date_cannot_be_less_than_start_date
    if end_date.present? && end_date < start_date
      errors.add(:end_date, "can't be less than start date")
    end
  end

  def full_name
    [course.course_name, course.section_name, name].join(' ')
  end

  def batch_course_code
    [course.code, name].join(' ')
  end

  def batch_course_name
    [course.course_name, name].join(' ')
  end

  # find subject
  def normal_subjects
    subjects.where(elective_group_id: nil)
  end

  def has_own_weekday
    Weekday.where(batch_id: id).present?
  end

  # this method is used to transfer student
  # from one batch to another batch and stored student data in student log
  def trans(students, transfer_id, batch)
    return unless students.present?
    general_subjects = batch.subjects.where(elective_group_id: nil)
    student_electives = StudentSubject.where(student_id: students, batch_id: batch.id)
    elective_subjects = []
    student_electives.each do |elect|
      elective_subjects.push Subject.find(elect.subject_id)
    end
    @subject = general_subjects + elective_subjects
    @exam_group = batch.result_published

    students.each  do |student|
      @subject.each do |subject|
        @exam_group.each do |exam_group|
          unless @subject.nil?
            exam = Exam.find_by_subject_id_and_exam_group_id(subject.id, exam_group.id)
            unless exam.nil?
              exam_score = ExamScore.find_by_student_id_and_exam_id(student, exam.id)
              unless exam_score.nil?
                StudentLog.create(subject_id: subject.id, batch_id: batch.id, student_id: student, exam_group_id: exam_group.id, mark: exam_score.marks, maximum_marks: exam.maximum_marks)
                end
              end
         end
        end
      end
    end
    students.each  do |student|
      Student.find(student).update(batch_id: transfer_id)
    end
  end

  # This action find the exam groupes record who's result published
  # status is true.
  def result_published
    exam_groups.where(result_published: true)
  end

  # this method is used to graduate student
  # student are moved from Student to ArchivedStudent
  def graduate(students, status)
    return unless students.present?
    students.each  do |s|
      student = Student.shod(s)
      archived_student = ArchivedStudent.new(student_id: \
          s, status_description: \
          status, admission_no: student.admission_no, admission_date: \
          student.admission_date, first_name: student.first_name, middle_name: \
          student.middle_name, last_name: student.last_name, batch_id: \
          student.batch_id, date_of_birth: student.date_of_birth, blood_group: \
          student.blood_group, birth_place: \
          student.birth_place, nationality_id: \
          student.nationality_id, language: student.language, category_id: \
          student.category_id, religion: student.religion, address_line1: \
          student.address_line1, address_line2: student.address_line2, city: \
          student.city, state: student.state, pin_code: \
          student.pin_code, country_id: student.country_id, phone1: \
          student.phone1, phone2: student.phone2, email: student.email)
      archived_student.save
      student.destroy
    end
  end
end
