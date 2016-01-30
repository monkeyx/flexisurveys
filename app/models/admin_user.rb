require 'digest/sha1'

class AdminUser < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  before_create :make_activation_code 
  
  has_and_belongs_to_many :admin_roles
  
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.admin_roles.collect(&:name)
    return true if @_list.include?("premium") && role_in_question == "basic"
    return true if @_list.include?("admin")
     (@_list.include?(role_in_question.to_s) )
  end
  
  def upgrade_to_basic!
    self.admin_roles << AdminRole.basic
    save!
  end
  
  def upgrade_to_premium!
    self.admin_roles << AdminRole.premium
    save!
  end
  
  def account_type
    return "Unconfirmed Email Address" unless active?  
    return "Premium" if has_role?("premium")
    return "Basic" if has_role?("basic")
    return "Free" if has_role?("free")
  end
  
  def invalid_survey?(survey)
    return true if survey.nil?
    return true if survey.question_sets.size > max_question_sets
    return true if survey.question_sets.any?{|qs| qs.questions.size > max_questions}
    false
  end
  
  def max_surveys
    return 0 unless active?  
    return 100 if has_role?("premium")
    return 5 if has_role?("basic")
    return 1 if has_role?("free")
  end
  
  def max_question_sets
    return 0 unless active?  
    return 100 if has_role?("premium")
    return 5 if has_role?("basic")
    return 3 if has_role?("free")
  end
  
  def max_questions
    return 0 unless active?  
    return 1000 if has_role?("premium")
    return 50 if has_role?("basic")
    return 20 if has_role?("free")
  end
  
  def max_question_answers
    return 0 unless active?  
    return 100 if has_role?("premium")
    return 20 if has_role?("basic")
    return 5 if has_role?("free")
  end
  
  def max_respondents
    return 0 unless active?  
    return 10000 if has_role?("premium")
    return 1000 if has_role?("basic")
    return 100 if has_role?("free")
  end
  
  has_many                  :surveys
  
  def can_add_survey?
    self.surveys.size < max_surveys  
  end
  
  def can_add_question_set?(survey)
    survey.question_sets.size < max_question_sets
  end
  
  def can_add_question?(question_set)
    question_set.questions.size < max_questions
  end
  
  def can_add_question_answer?(question)
    question.answers.size < max_question_answers
  end
  
  def authorized_for_survey?(survey_id)
    s = Survey.find(survey_id)
    s && s.admin_user_id == self.id
  end
  
  def authorized_for_question_set?(set_id)
    qs = QuestionSet.find(set_id)
    qs && authorized_for_survey?(qs.survey_id)
  end
  
  def authorized_for_question?(qid)
    q = Question.find(qid)
    q && authorized_for_question_set?(q.question_set_id)
  end
  
  def authorized_for_question_answer?(aid)
    qa = QuestionAnswer.find(aid)
    qa && authorized_for_question?(qa.question_id)
  end
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :terms_accepted
  attr_accessor :terms_accepted
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    self.admin_roles << AdminRole.free
    save(false)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  def recently_activated?
    @activated
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def make_activation_code
    self.activation_code = self.class.make_token
  end
  
end
