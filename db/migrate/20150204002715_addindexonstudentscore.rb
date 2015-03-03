class Addindexonstudentscore < ActiveRecord::Migration
  def change
    add_column :student_scores, :student_id, :integer
    remove_column :student_scores, :students_id, :integer
    add_index :student_scores, :student_id
  end
end
