class CreateStudentLogs < ActiveRecord::Migration
  def change
    create_table :student_logs do |t|
      t.decimal :mark
      t.integer :maximum_marks
      t.references :student, index: true
      t.references :subject, index: true
      t.references :exam_group, index: true
      t.references :batch, index: true

      t.timestamps null: false
    end
    add_foreign_key :student_logs, :students
    add_foreign_key :student_logs, :subjects
    add_foreign_key :student_logs, :exam_groups
    add_foreign_key :student_logs, :batches
  end
end
