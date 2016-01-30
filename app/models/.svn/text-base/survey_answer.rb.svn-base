class SurveyAnswer < ActiveRecord::Base
  validates_presence_of :question_id
  belongs_to :question
  validates_presence_of :survey_user_id
  belongs_to :user, :class_name => 'SurveyUser', :foreign_key =>'survey_user_id'
  validates_presence_of :question_answer_id, :message => 'Please choose an answer'
  belongs_to :answer, :class_name => 'QuestionAnswer', :foreign_key => 'question_answer_id'
  validates_length_of :answer_detail, :in => 0..255, :allow_nil => true
  
  def validate
    errors.add(:answer_details, "must provide details for this answer") if self.answer_detail.blank? && self.answer && self.answer.requires_details?
  end
  
  named_scope :of_questions,  lambda {|questions|
    {:conditions => ['question_id IN (?)', questions.map{|q| q.id} ]}
  }
  
  named_scope :answer_given,  lambda {|user,question|
    {:conditions => {:survey_user_id => user.id, :question_id => question.id}}
  }
  
  def self.find_or_new(user,question)
    found = answer_given(user,question)
    return found.first if found.any?
    new(:survey_user_id => user.id, :question_id => question.id )
  end
end
