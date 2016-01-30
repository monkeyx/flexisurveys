class AdminUserMailer < ActionMailer::Base
  def signup_notification(admin_user)
    setup_email(admin_user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "#{$SERVER_URL}/activate/#{admin_user.activation_code}"
  
  end
  
  def activation(admin_user)
    setup_email(admin_user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{$SERVER_URL}/"
  end
  
  def account_update(admin_user)
    setup_email(admin_user)
    @subject    += 'Your account has been updated'
    if admin_user.activation_code
      @body[:url]  = "#{$SERVER_URL}/activate/#{admin_user.activation_code}"
    else
      @body[:url]  = "#{$SERVER_URL}/"
    end
  end
  
  def survey_archived(admin_user, survey)
    setup_email(admin_user)
    @subject    += "#{survey.name} archived!"
    @body[:url]  = "#{$SERVER_URL}/"
    @body[:survey] = survey
  end

  protected
    def setup_email(admin_user)
      @recipients  = "#{admin_user.email}"
      @from        = "admin@flexisurveys.com"
      @subject     = "[FlexiSurveys.com] "
      @sent_on     = Time.now
      @body[:admin_user] = admin_user
    end
end
