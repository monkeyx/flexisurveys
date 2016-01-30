class SurveyUser < ActiveRecord::Base
  validates_presence_of :ip_address
  validates_presence_of :survey_id
  belongs_to :survey
  
  def answer_for(question)
    a = SurveyAnswer.answer_given(self,question).first
    a.nil? ? "Not Given" : a.answer_detail.blank? ? a.answer.prompt : a.answer_detail
  end
  
  def agreed?
    self.survey_agreed
  end
  
  def agree!
    update_attributes!(:survey_agreed => true)
  end
  
  def completed?
    self.survey_complete
  end
  
  def complete!
    update_attributes!(:survey_complete => true)
    survey.user_completed!
  end
  
  belongs_to  :current_question, :class_name => 'Question'
  
  def questions
    return [] unless self.questions_list
    @list ||= questions_list.split(',').map do |qid|
      Question.find(qid.to_i)
    end
  end

  def questions=(list)
    return unless list
    self.questions_list = list.map{|q| q.id.to_s}.join(',')
  end
  
  def has_more_questions?
    self.current_question != questions.last    
  end
  
  def total_questions
    self.questions.size
  end
  
  def current_question_index
    self.questions.index(self.current_question)
  end
  
  def next_question!
    i = current_question_index
    if i < total_questions - 1
      self.current_question = questions[(i + 1)]
      save!
    else
      complete!
    end
  end
  
  def self.find_user_by_request(request, survey)
    find(:first, :conditions => ['ip_address = ? AND session_id = ?', request.remote_ip, survey.id]) unless request.nil? || survey.nil?
  end
  
  def self.create_user!(survey, request)
    raise "Invalid survey" unless survey && survey.is_a?(Survey)
    raise "Invalid request" unless request && request.remote_ip
    user = create!(:survey_id => survey.id, :ip_address => request.remote_ip, :survey_agreed => false, :survey_complete => false)
    list = []
    survey.question_sets.sort_by{rand}.each do |qs|
      qs.questions.sort_by{rand}.each {|q| list << q; q.children.each {|qc| list << qc}}
    end
    user.questions = list
    user.current_question = list.first
    user.save!
    user
  end
end
