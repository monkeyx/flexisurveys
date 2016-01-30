class CreateSurveyUsers < ActiveRecord::Migration
  def self.up
    create_table :survey_users do |t|
      t.string  :ip_address
      t.integer :survey_id
      t.boolean :survey_agreed
      t.boolean :survey_complete
      t.integer :current_question_id
      t.text    :questions_list
      t.timestamps
    end
    add_index :survey_users, :ip_address
    add_index :survey_users, :survey_id
  end

  def self.down
    drop_table :survey_users
  end
end
