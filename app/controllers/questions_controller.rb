class QuestionsController < ApplicationController
  before_filter :login_required
  
  require_role "free", :for_all_except => [:new, :create], :unless => "current_admin_user.authorized_for_question?(params[:id]) "

  def show
    @question = Question.find(params[:id])
  end
  
  # new question form
  def new
    @survey = Survey.find(params[:survey]) if params[:survey]
    @question_set = QuestionSet.find(params[:question_set]) if params[:question_set]
    @parent_question = Question.find(params[:question]) if params[:question]
    @question_set ||= @parent_question.question_set if @parent_question
    @survey ||= @question_set.survey if @question_set
    if @question_set
      return nag_upgrade unless current_admin_user.can_add_question?(@question_set)
    else
      return nag_upgrade unless current_admin_user.can_add_question_set?(@survey)
    end
    @question = Question.new
    @question.question_set = @question_set if @question_set
    @question.parent_question = @parent_question if @parent_question
  end
  
  # create new question
  def create
    @question = Question.new(params[:question])
    @parent_question = @question.parent_question if @question
    @question_set = @question.question_set if @question
    @survey = @question_set.survey if @question_set
    @survey = Survey.find(params[:survey]) if @survey.nil? && params[:survey]
    if @question_set.nil? && @survey
      return nag_upgrade unless current_admin_user.can_add_question_set?(@survey)
      @question_set = QuestionSet.new
      set_number = @survey.question_sets.size + 1
      @question_set.name = "Question Set #{set_number}"
      @question_set.survey = @survey
      @question.question_set = @question_set if @question_set.save
    end
    return nag_upgrade unless current_admin_user.can_add_question?(@question.question_set)
    if @question.save
      flash[:notice] = "Question '#{@question.prompt}' created successfully."
      redirect_to @question
    else
      flash[:error] = "There were errors when trying to save this question."
      render :action => :new
    end
  end
  
  # archive question
   def destroy
    @question = Question.find(params[:id])
    if @question.answered?
      @question.archive!
    else
      @question.destroy
    end
    redirect_to(@question.question_set)
  end
  
  # edit question
  def edit
    @question = Question.find(params[:id])
    @parent_question = @question.parent_question if @question
    @question_set = @question.question_set if @question
    @survey = @question_set.survey if @question_set
  end
  
  # update a question
  def update
    @question = Question.find(params[:id])
    @question.update_attributes(params[:question])
    @parent_question = @question.parent_question if @question
    @question_set = @question.question_set if @question
    @survey = @question_set.survey if @question_set
    @survey = Survey.find(params[:survey]) if @survey.nil? && params[:survey]
    if @question_set.nil? && @survey
      return nag_upgrade unless current_admin_user.can_add_question_set?(@survey)
      @question_set = QuestionSet.new
      set_number = @survey.question_sets.size + 1
      @question_set.name = "Question Set #{set_number}"
      @question_set.survey = @survey
      @question.question_set = @question_set if @question_set.save
    end
    if @question.save
      flash[:notice] = "Question '#{@question.prompt}' updated successfully."
      redirect_to @question
    else
      flash[:error] = "There were errors when trying to save this question."
      render :action => :new
    end
  end
end
