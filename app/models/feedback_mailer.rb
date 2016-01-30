class FeedbackMailer < ActionMailer::Base
  
  def feedback(feedback)
    @recipients  = 'feedback@flexisurveys.com'
    # @recipients  = 'monkeyx@gmail.com'
    @from        = 'noreply@flexisurveys.com'
    @subject     = "[Feedback for FlexiSurveys] #{feedback.subject}"
    @sent_on     = Time.now
    @body[:feedback] = feedback    
  end

end
