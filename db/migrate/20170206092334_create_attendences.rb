class CreateAttendences < ActiveRecord::Migration
  def change
    create_table :attendences do |t|
      t.boolean :forenoon
      t.boolean :afternoon
      t.string :reason
      t.date :month_date
      t.references :student, index: true
      t.references :time_table_entry, index: true
      t.references :batch, index: true
      t.references :subject, index: true

      t.timestamps null: false
    end
    add_foreign_key :attendences, :students
    add_foreign_key :attendences, :time_table_entries
    add_foreign_key :attendences, :batches
    add_foreign_key :attendences, :subjects
  end
end
