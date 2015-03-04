# GroupedExamReport model
class GroupedExamReport < ActiveRecord::Base
  include Activity

  # This action fetch the record from general settings table for selected batch,
  # student, exam group and exam subject id.
  def self.gpexre(batch, student, exam_group, exam)
    where(batch_id: batch.id, student_id: \
          student, exam_group_id: \
          exam_group.id, subject_id: \
          exam.subject_id).take
  end
end
