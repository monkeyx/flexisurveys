class QuestionSet < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :survey_id
  belongs_to :survey
  has_many :questions,  :conditions => '(parent_question_id = 0 OR parent_question_id IS NULL) AND (archived = 0 OR archived IS NULL)'
  
  named_scope :of_survey, lambda {|survey|
    {:conditions => {:survey_id => survey.id }}
  }
  
  def answered?
    self.questions.each{|q| q.answered? }
  end
  
  def archive!
    self.questions.each{|q|q.archive!}
    update_attributes!(:archived => true)
  end
  
  def to_s
    name
  end
  
#  validates_numericality_of :order
#  def previous_set
#    QuestionSet.find(:first, :conditions => ['survey_id = ? AND order < ?',survey_id, order])
#  end
#  def next_set
#    QuestionSet.find(:first, :conditions => ['survey_id = ? AND order > ?',survey_id, order])
#  end
#  def up!
#    return unless self.order >= 0
#    pqs = previous_set
#    update_attributes!(:order => order - 1)
#    pqs.up! if pqs
#    self
#  end
#  def down!
#    nqs = next_set
#    update_attributes!(:order => order + 1)
#    nqs.down! if nqs
#    self
#  end
end
