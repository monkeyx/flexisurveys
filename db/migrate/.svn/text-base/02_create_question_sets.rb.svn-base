class CreateQuestionSets < ActiveRecord::Migration
  def self.up
    create_table :question_sets do |t|
      t.string :name
      t.integer :survey_id
      t.boolean :archived
      t.text    :instructions
      t.timestamps
    end
    add_index :question_sets, :name
    add_index :question_sets, :survey_id
    add_index :question_sets, :archived
  end

  def self.down
    drop_table :question_sets
  end
end
