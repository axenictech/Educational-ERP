class AddisQualifytoscore < ActiveRecord::Migration
  def change
    add_column :student_scores, :is_qualify, :boolean
  end
end
