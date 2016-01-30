class CreateSurveyAnswers < ActiveRecord::Migration
  def self.up
    create_table :survey_answers do |t|
      t.integer :question_id
      t.integer :survey_user_id
      t.integer :question_answer_id
      t.string :answer_detail

      t.timestamps
    end
    add_index :survey_answers, :question_id
    add_index :survey_answers, :survey_user_id
    add_index :survey_answers, :question_answer_id
  end

  def self.down
    drop_table :survey_answers
  end
end
