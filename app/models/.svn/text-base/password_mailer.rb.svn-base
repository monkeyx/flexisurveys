class PasswordMailer < ActionMailer::Base
  
  def forgot_password(password)
    setup_email(password.admin_user)
    @subject    += 'You have requested to change your password'
    @body[:url]  = "#{$SERVER_URL}/change_password/#{password.reset_code}"
  end

  def reset_password(admin_user)
    setup_email(admin_user)
    @subject    += 'Your password has been reset.'
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