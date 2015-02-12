class AddBooleanToPlacemntNews < ActiveRecord::Migration
  def change
    add_column :placement_news, :islink, :boolean
  end
end
