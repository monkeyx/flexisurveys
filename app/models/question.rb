class Question < ActiveRecord::Base
  validates_presence_of :prompt
  validates_presence_of :question_set_id
  belongs_to :question_set
  belongs_to :parent_question, :class_name => 'Question'
  has_many  :children,  :class_name => 'Question', :foreign_key => 'parent_question_id'
  has_many :answers, :class_name => 'QuestionAnswer', :conditions => 'archived = 0 OR archived IS NULL', :order => "`order` ASC"
  has_many :given_answers, :class_name => 'SurveyAnswer'
  
  named_scope :in_sets,  lambda {|sets|
    {:conditions => ['question_set_id IN (?)', sets.map{|qs| qs.id }]}
  }
  
  def answered?
    self.given_answers.any?
  end

  def archive!
    self.answers.each{|qa| qa.archive! }
    update_attributes!(:archived => true)
  end
  
  def to_s
    prompt
  end
  
  def bar_graph_data
    answers.map{|a| [a.prompt, a.given_answers.size]}
  end
end
