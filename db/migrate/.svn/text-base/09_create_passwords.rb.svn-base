class CreatePasswords < ActiveRecord::Migration
  def self.up
    create_table "passwords" do |t|
      t.integer :admin_user_id
      t.string :reset_code
      t.datetime :expiration_date

      t.timestamps
    end
  end

  def self.down
    drop_table "passwords"
  end
end
