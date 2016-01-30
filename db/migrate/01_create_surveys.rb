class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.string :name
      t.string :path
      t.boolean :archived, :default => false
      t.integer :respondents, :default => 0
      t.text :agreement
      t.string :disagree_link
      t.text  :thankyou
      t.integer :admin_user_id
      t.timestamps
    end
    add_index :surveys, :name
    add_index :surveys, :path
    add_index :surveys, :archived
  end

  def self.down
    drop_table :surveys
  end
end
