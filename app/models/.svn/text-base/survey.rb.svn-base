class Survey < ActiveRecord::Base
  before_validation     :generate_path
  validates_presence_of :name
  validates_format_of       :name, :with => Authentication.name_regex,  :message => Authentication.bad_name_message
  validates_presence_of :path
  validates_format_of       :path,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  validates_presence_of :agreement
  validates_presence_of :disagree_link
  
  validates_numericality_of :respondents
  
  def validate
    if self.path && self.admin_user && Survey.count(:conditions => "path = '#{self.path}' AND admin_user_id = #{self.admin_user.id}") > (self.id ? 1 : 0)
      errors.add(:path, "needs to be unique amongst your surveys")
    end
    if self.name && self.admin_user && Survey.count(:conditions => "name = '#{self.name}' AND admin_user_id = #{self.admin_user.id}") > (self.id ? 1 : 0)
      errors.add(:name, "needs to be unique amonst your surveys")
    end
  end
  
  def generate_path
    if self.path.blank? && !self.name.blank?
      self.path = self.name.downcase.gsub(' ','_')
    end
  end
  
  has_many :question_sets, :conditions => 'archived = 0 OR archived IS NULL'
  has_many :users, :class_name => 'SurveyUser'
  belongs_to  :admin_user
  
  named_scope :active,  :conditions => 'archived = 0 OR archived IS NULL'
  
  def full_path
    "/quiz/#{self.admin_user.login}/#{self.path}"
  end
  
  def url
    "#{$SERVER_URL}#{self.full_path}"
  end
  
  def user_completed!
    update_attributes!(:respondents => self.respondents + 1)
    archive! if self.respondents >= self.admin_user.max_respondents 
  end
  
  def answered?
    self.question_sets.any?{|qs| qs.answered? }
  end
  
  def answers_given
    SurveyAnswer.of_questions(Question.in_sets(QuestionSet.of_survey(self)))
  end
  
  def archive!
    self.question_sets.each {|qs| qs.archive! }
    update_attributes!(:archived => true)
  end
  
  def to_csv
    FasterCSV.generate do |csv|
      header_row = ["Number","IP Address", "Date Created"]
      self.question_sets.each do |qs|
        qs.questions.each do |q|
          header_row << q.prompt
          q.children.each do |qc|
            header_row << qc.prompt
          end
        end
      end
      csv << header_row
      count = 1
      self.users.each do |u|
        row = [count, u.ip_address, u.created_at]
        self.question_sets.each do |qs|
          qs.questions.each do |q|
            row << u.answer_for(q)
            q.children.each do |qc|
              row << u.answer_for(qc)
            end
          end
        end
        csv << row
        count += 1
      end
    end
  end
  
  def self.from_xml(xml_string, admin_user, name = nil)
    transaction do 
      doc = REXML::Document.new(xml_string)
      e_survey = doc.root
      agreement = nil
      e_survey.elements.each('agreement'){|e_agreement| agreement = e_agreement.text }
      thankyou = nil
      e_survey.elements.each('thankyou'){|e_thankyou| thankyou = e_thankyou.text }
      s = Survey.create!(:name => name.blank? ? e_survey.attributes['name'] : name, 
                         :path => name.blank? ? e_survey.attributes['path'] : name.downcase.gsub(' ','_'), 
                         :disagree_link => e_survey.attributes['disagree-link'], 
                         :agreement => agreement, 
                         :thankyou => thankyou,
                         :respondents => 0,
                         :admin_user_id => admin_user.id)
      puts s
      e_survey.elements.each('question-set') do |e_qs|
        instructions = nil
        e_qs.elements.each('instructions'){|e_instructions| instructions = e_instructions.text }
        qs = QuestionSet.create!(:name => e_qs.attributes['name'], :instructions => instructions, :survey_id => s.id)
        puts qs
        e_qs.elements.each('question') do |e_q|
          q = Question.create!(:prompt => e_q.attributes['prompt'], :question_set_id => qs.id)
          puts q
          order = 0
          e_q.elements.each('answer') do |e_qa|
            answer_type = e_qa.attributes['answer-type'] ? e_qa.attributes['answer-type'] : 'radio'
            qa = QuestionAnswer.create!(:prompt => e_qa.attributes['prompt'], :answer_type => answer_type, :question_id => q.id, :order => order)
            puts qa
            order += 1
          end
          e_q.elements.each('question') do |e_qc|
            qc = Question.create!(:prompt => e_qc.attributes['prompt'], :question_set_id => qs.id, :parent_question_id => q.id)
            puts qc
            order = 0
            e_qc.elements.each('answer') do |e_qa|
              answer_type = e_qa.attributes['answer-type'] ? e_qa.attributes['answer-type'] : 'radio'
              qa = QuestionAnswer.create!(:prompt => e_qa.attributes['prompt'], :answer_type => answer_type, :question_id => qc.id, :order => order)
              puts qa
              order += 1
            end
          end
        end
      end
      s
    end 
  end
  
  def to_s
    name
  end
  
  def to_xml
    doc = REXML::Document.new
    e_survey = doc.add_element('survey', {'name' => self.name, 'path' => self.path, 'disagree-link' => self.disagree_link})
    e_survey.add_element('agreement').text = self.agreement
    e_survey.add_element('thankyou').text = self.agreement
    self.question_sets.each do |qs|
      e_qs = e_survey.add_element('question-set', {'name' => qs.name})
      e_qs.add_element('instructions').text = qs.instructions
      qs.questions.each do |q|
        e_q = e_qs.add_element('question', {'prompt' => q.prompt})
        q.children.each do |qc|
          e_qc = e_q.add_element('question', {'prompt' => qc.prompt})
          qc.answers.each do |qa|
            e_qa = e_qc.add_element('answer', {'prompt' => qa.prompt, 'answer-type' => qa.answer_type})  
          end
        end
        q.answers.each do |qa|
          e_qa = e_q.add_element('answer', {'prompt' => qa.prompt, 'answer-type' => qa.answer_type})  
        end
      end
    end
    doc.to_s
  end
end
