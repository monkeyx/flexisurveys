class CreateQuestionAnswers < ActiveRecord::Migration
  def self.up
    create_table :question_answers do |t|
      t.integer :question_id
      t.string :prompt
      t.string :answer_type
      t.boolean :archived
      t.integer :order

      t.timestamps
    end
    add_index :question_answers, :question_id
    add_index :question_answers, :archived
    add_index :question_answers, :order
  end

  def self.down
    drop_table :question_answers
  end
end
