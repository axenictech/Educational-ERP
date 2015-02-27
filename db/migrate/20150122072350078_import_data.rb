class ImportData < ActiveRecord::Migration
  def change
    Rake::Task['db:data:load'].invoke
  end
end
