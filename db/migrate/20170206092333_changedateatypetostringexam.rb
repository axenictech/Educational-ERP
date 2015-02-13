class Changedateatypetostringexam < ActiveRecord::Migration
  def change
  	change_column :exams, :start_time,:string
  	change_column :exams, :end_time,:string
  end
end
