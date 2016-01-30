class QuestionAnswer < ActiveRecord::Base
  validates_presence_of :question_id
  belongs_to :question
  validates_length_of :prompt, :in => 1..255
  ANSWER_TYPE = ['radio', 'text', 'multi_text']
  ANSWER_TYPE_COMBO_OPTIONS = [["Multiple choice","radio"],["Single Line Text", "text"],["Multiple Line Textbox","multi_text"]]
  validates_inclusion_of :answer_type, :in => ANSWER_TYPE
  
  has_many  :given_answers, :class_name => 'SurveyAnswer'
  
  def answered?
    self.given_answers.any?
  end
  
  def requires_details?
    self.answer_type == 'text' || self.answer_type == 'multi_text'  
  end
  
  def archive!
    update_attributes!(:archived => true)
  end
  validates_numericality_of :order
  def previous_answer
    QuestionAnswer.find(:first, :conditions => ['question = ? AND order < ?',queston_id, order])
  end
  def next_answer
    QuestionAnswer.find(:first, :conditions => ['question = ? AND order > ?',question_id, order])
  end
  def up!
    return unless self.order >= 0
    pa = previous_answer
    update_attributes!(:order => order - 1)
    pa.up! if pa
    self
  end
  def down!
    na = next_answer
    update_attributes!(:order => order + 1)
    na.down! if na
    self
  end
  
  def to_s
    prompt
  end
end
