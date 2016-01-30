class CreateAdminRoles < ActiveRecord::Migration
  def self.up
    create_table "admin_roles" do |t|
      t.string  :name
    end
    
    # generate the join table
    create_table "admin_roles_admin_users", :id => false do |t|
      t.integer "admin_role_id", "admin_user_id"
    end
    add_index "admin_roles_admin_users", "admin_role_id"
    add_index "admin_roles_admin_users", "admin_user_id"
  end

  def self.down
    drop_table "admin_roles"
    drop_table "admin_roles_admin_users"
  end
end