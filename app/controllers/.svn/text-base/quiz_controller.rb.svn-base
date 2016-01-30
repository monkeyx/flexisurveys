class QuizController < ApplicationController
  
  def index
    if logged_in?
      redirect_to surveys_path
    end
  end
  
  def show
    # logger.info "path = #{params[:path]}"
    return redirect_to(:action => 'index') unless params[:path]
    @admin_user = AdminUser.find_by_login(params[:path][0])
    return redirect_to(:action => 'index') unless @admin_user
    @survey = Survey.find(:first, :conditions => {:path => params[:path][1], :admin_user_id => @admin_user.id})
    if @survey.archived?
      redirect_to :action => 'index'
    else
      @user = current_user
      
      @user.agree! if params[:agreed] && !@user.agreed?
      @show_agreement = !@user.agreed?
      unless @show_agreement
        @question = @user.current_question
        if params[:survey_answer]
          params[:survey_answer][:answer_detail] = params[:answer_detail].join if params[:answer_detail] 
          @survey_answer = SurveyAnswer.find_or_new(@user,@question)
          @survey_answer.update_attributes(params[:survey_answer])
          if @survey_answer.save
            @user.next_question! if @user.current_question == @survey_answer.question
            flash[:error] = ''
          else
            flash[:error] = "Please ensure you provide an answer (or click skip to move on to the next question)."
          end
        elsif params[:skip]
          flash[:error] = ''
          @user.next_question!
        end
        unless @user.completed?
          @question = @user.current_question
          @survey_answer = SurveyAnswer.find_or_new(@user,@question)
          @survey_answer.answer = @question.answers.first if @question.answers.size == 1
        else
          @completed = true
        end
      end
    end    
  end
  
  private
  def current_user
    user = nil
    if session[:survey_user_id]
      begin
        user = SurveyUser.find(session[:survey_user_id])
      rescue
        logger.error "Couldn't find user with ID #{session[:survey_user_id]}"
        session[:survey_user_id] = nil
      end
      current_path = "/quiz/#{params[:path].join('/')}" if params[:path]
      Kernel.p "!!!! #{current_path}"
      Kernel.p "!!! #{user.survey.full_path}"
      user = nil if user && (user.completed? || user.survey.full_path != current_path)
    end
    if user.nil?
      user = SurveyUser.create_user!(@survey, request)
      session[:survey_user_id] = user.id
    end
    user
  end
end
