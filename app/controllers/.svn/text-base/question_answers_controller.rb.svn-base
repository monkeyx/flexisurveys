class QuestionAnswersController < ApplicationController
  before_filter :login_required
  
  require_role "free", :for_all_except => [:new, :create], :unless => "current_admin_user.authorized_for_question_answer?(params[:id]) "
  
  def show
    @question_answer = QuestionAnswer.find(params[:id])
  end
  
  # new answer form
  def new
    question = Question.find(params[:question])
    return nag_upgrade unless current_admin_user.can_add_question_answer?(question)
    @question_answer = QuestionAnswer.new
    @question_answer.order = (question.answers.size)
    @question_answer.question = question
  end
  
  # create new answer
  def create
    @question_answer = QuestionAnswer.new(params[:question_answer])
    return nag_upgrade unless current_admin_user.can_add_question_answer?(@question_answer.question)
    if @question_answer.save
      flash[:notice] = "Answer '#{@question_answer.prompt}' created successfully."
      redirect_to @question_answer.question
    else
      flash[:error] = "There were errors when trying to save this answer."
      render :action => :new
    end
  end
  
  # archive answer
  def destroy
    @question_answer = QuestionAnswer.find(params[:id])
    if @question_answer.answered?
      @question_answer.archive!
    else
      @question_answer.destroy
    end
    redirect_to(@question_answer.question)
  end
  
  # edit answer
  def edit
    @question_answer = QuestionAnswer.find(params[:id])
  end
  
  # update a question
  def update
    @question_answer = QuestionAnswer.find(params[:id])
    @question_answer.update_attributes(params[:question_answer])
    if @question_answer.save
      flash[:notice] = "Answer '#{@question_answer.prompt}' updated successfully."
      redirect_to @question_answer.question
    else
      flash[:error] = "There were errors when trying to save this answer."
      render :action => :new
    end
  end

end
