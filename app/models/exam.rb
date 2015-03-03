# Exam Active Record
class Exam < ActiveRecord::Base
  include Activity
  belongs_to :exam_group
  belongs_to :subject
  belongs_to :event
  has_many :exam_scores, dependent: :destroy

  validates :maximum_marks, numericality: { only_integer: true }, length: \
            { minimum: 1, maximum: 3 }, allow_blank: true

  validates :minimum_marks, numericality: { only_integer: true }, length: \
            { minimum: 1, maximum: 3 }, allow_blank: true

  # validate :end_time_cannot_be_less_than_start_time
  # validate :start_time_cannot_be_less_than_past
  # validate :end_time_cannot_be_less_than_past
  # validate :max_marks_greater_than_min_marks
  scope :shod, ->(id) { where(id: id).take }
  scope :result, ->(s, e) { where(subject_id: s, exam_group_id: e).take }

  def end_time_cannot_be_less_than_start_time
    if end_time.present? && end_time < start_time
      errors.add(:end_time, 'cannot be less than start time')
    end
  end

  def start_time_cannot_be_less_than_past
    if start_time.present? && start_time.to_date < Date.today
      errors.add(:start_time, 'should not be past date')
    end
  end

  def end_time_cannot_be_less_than_past
    if end_time.present? && end_time.to_date < Date.today
      errors.add(:end_time, 'should not be past date')
    end
  end

  def max_marks_greater_than_min_marks
    if maximum_marks.present? && minimum_marks.present? && maximum_marks < minimum_marks
      errors.add(:maximum_marks, 'should be greater than minimum marks')
    end
  end

  def create_exam_event
    batch = exam_group.batch
    @event = event
    if @event.nil?
      event = Event.create(title: 'Exam', description: "#{exam_group.name} for subject- #{subject.name} #{batch.course.course_name} #{batch.course.section_name} #{batch.name}",
                           start_date: start_time,
                           end_date: end_time,
                           is_exam: true)
      update(event_id: event.id)
    else
      @event.update(start_date: start_time, end_date: end_time)
    end
  end

  # This action select the  subject for exam.
  # This action is also check the subject is either elective or not.
  def select_subject(s1, s2, exam)
    unless s2.nil?
      s2.each do |std|
        if exam.subject.elective_group.nil?
          s1 << std
        else
          is_elective = StudentSubject.where(student_id: std.id,
                                             subject_id: exam.subject_id).take
          s1 << std unless is_elective.nil?
        end
      end
    end
    s1
  end

  # This action is update the exam score. This action also magage the
  # updation of exam score according to marks, grade, marks and grade.
  def score_exam(temps, batch, exam, exam_group, grades)
    temps.each_pair do |student_id, details|
      @exam_score = ExamScore.where(exam_id: exam.id,
                                    student_id: student_id).take
      @grouped_exam = GroupedExamReport.where(batch_id: batch.id,
                                              student_id: student_id,
                                              exam_group_id: exam_group.id,
                                              subject_id: exam.subject_id).take
      score_grade = ''
      fail = false
      fail = true if details[:marks].to_f < exam.minimum_marks.to_f

      unless exam.exam_group.exam_type == 'Marks'
        unless exam.exam_group.exam_type == 'Grades'
          percentage = (details[:marks].to_f * 100) / exam.maximum_marks.to_f
          grades.each do |grade|
            if percentage >= grade.min_score
              score_grade = grade.id
            end
          end
        else
          grades.each do |grade|
            if details[:marks].to_f >= grade.min_score
              score_grade = grade.id
            end
          end
        end
      end

      if @exam_score.nil?
        exam_score = ExamScore.new(exam_id: exam.id, student_id: student_id,
                                   marks: details[:marks], remarks: details[:remarks], grading_level_id: score_grade, is_failed: fail)
        unless exam_score.save
          @errors = exam_score.errors.full_messages
      end
      else
        unless @exam_score.update(marks: details[:marks], remarks: details[:remarks], grading_level_id: score_grade, is_failed: fail)
          @errors = @exam_score.errors.full_messages
        end
          end
      if @errors.nil?
        if @grouped_exam.nil?
          GroupedExamReport.create(batch_id: batch.id, student_id: student_id,
                                   exam_group_id: exam_group.id, subject_id: exam.subject_id, marks: details[:marks])
        else
          @grouped_exam.update(marks: details[:marks])
        end
    end
    end
  end

  # This action is useful to update the exam score. But the score strategy is
  # divided into the three parts i.e. marks,grades,marks and grades so to 
  # manage update operation on exam score is also divided as per score strategy
  def update_exam_scr(exam, exam_group, batch, param)
    param.each_pair do |student_id, details|
      exam_score = ExamScore.exrep(exam, student_id)
      grouped_exam = GroupedExamReport.where(batch_id: batch.id, student_id: \
                                              student_id, exam_group_id: \
                                              exam_group.id, subject_id: \
                                              exam.subject_id).take
      score_grade = ''
      fail = false
      fail = true if details[:marks].to_f < exam.minimum_marks.to_f
      unless exam.exam_group.exam_type == 'Marks'
        percentage = (details[:marks].to_f * 100) / exam.maximum_marks.to_f
        grades = exam.exam_group.batch.grading_levels.all
        grades.each do |grade|
          if percentage >= grade.min_score
            score_grade = grade.id
          end
        end
      end
      if exam_score.nil?
        ExamScore.create(exam_id: exam.id, student_id: student_id,
                         marks: details[:marks], remarks: details[:remarks], grading_level_id: score_grade, is_failed: fail)
      else
        exam_score.update(marks: details[:marks], remarks: details[:remarks], grading_level_id: score_grade, is_failed: fail)
      end

      if grouped_exam.nil?
        GroupedExamReport.create(batch_id: batch.id, student_id: student_id,
                                 exam_group_id: exam_group.id, subject_id: exam.subject_id, marks: details[:marks])
      else
        grouped_exam.update(marks: details[:marks])
      end
    end
  end

  # This action fetch the student recored which is failed.
  def is_failed
    exam_scores.where(is_failed: true).includes(:student, :grading_level)
  end

  # This action find out the score of user selected student.
  def scores(student)
    ExamScore.score(student.id, id) unless student.nil?
  end

  # This action perform the arithmetic operation for calculate total marks.
  def exam_total(total)
    total.to_f + maximum_marks.to_f
  end

  # This action generate the data for marks of particular student.
  def exam_mar(student, marks)
    exam_score = scores(student)
    marks.to_f + exam_score.marks.to_f
  end
end
