class CreatePrivilegeUsers < ActiveRecord::Migration
  def change
    create_table :privilege_users do |t|
      t.references :privilege, index: true
      t.references :user, index: true
      t.references :privilege_tag, index: true

      t.timestamps null: false
    end
    add_foreign_key :privilege_users, :privileges
    add_foreign_key :privilege_users, :users
    add_foreign_key :privilege_users, :privilege_tags
  end
end
