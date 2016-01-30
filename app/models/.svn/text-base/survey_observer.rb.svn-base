class SurveyObserver < ActiveRecord::Observer
  def after_save(survey)
    AdminUserMailer.deliver_survey_archived(survey.admin_user, survey) if survey.archived?
  end
end