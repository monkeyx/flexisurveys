class QuestionSetsController < ApplicationController
  before_filter :login_required
  
  require_role "free", :for_all_except => [:new, :create], :unless => "current_admin_user.authorized_for_question_set?(params[:id]) "

  def show
    @question_set = QuestionSet.find(params[:id])
  end
  
  # new question set form
  def new
    @survey = Survey.find(params[:survey])
    return nag_upgrade unless current_admin_user.can_add_question_set?(@survey)
    @question_set = QuestionSet.new
    set_number = @survey.question_sets.size + 1
    @question_set.name = "Question Set #{set_number}"
    @question_set.survey = @survey
  end
  
  # create new question set
  def create
    @question_set = QuestionSet.new(params[:question_set])
    @survey = @question_set.survey
    return nag_upgrade unless current_admin_user.can_add_question_set?(@question_set.survey)
    if @question_set.save
      flash[:notice] = "Question Set #{@question_set.name} created successfully."
      redirect_to @question_set
    else
      flash[:error] = "There were errors when trying to save this question set."
      render :action => :new
    end
  end
  
  # archive question set
  def destroy
    @question_set = QuestionSet.find(params[:id])
    if @question_set.answered?
      @question_set.archive!
    else
      @question_set.destroy
    end
    redirect_to(@question_set.survey)
  end
  
  # edit question set
  def edit
    @question_set = QuestionSet.find(params[:id])
    @survey = @question_set.survey
  end
  
  # update a question set
  def update
    @question_set = QuestionSet.find(params[:id])
    @question_set.update_attributes(params[:question_set])
    @survey = @question_set.survey
    if @question_set.save
      flash[:notice] = "Question Set #{@question_set.name} updated successfully."
      redirect_to @question_set
    else
      flash[:error] = "There were errors when trying to save this question set."
      render :action => :new
    end
  end

end
