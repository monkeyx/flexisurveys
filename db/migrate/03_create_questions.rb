class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.text :prompt
      t.integer :question_set_id
      t.integer :parent_question_id
      t.boolean :archived

      t.timestamps
    end
    add_index :questions, :question_set_id
    add_index :questions, :archived
  end

  def self.down
    drop_table :questions
  end
end
