class CreateUserPrivileges < ActiveRecord::Migration
  def change
    create_table :user_privileges do |t|
      t.references :user, index: true
      t.references :privilege, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_privileges, :users
    add_foreign_key :user_privileges, :privileges
  end
end
