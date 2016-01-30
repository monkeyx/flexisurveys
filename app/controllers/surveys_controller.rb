class SurveysController < ApplicationController
  before_filter :login_required
  
  require_role "free", :for_all_except => [:index, :import, :new, :create], :unless => "current_admin_user.authorized_for_survey?(params[:id]) "
  
  def show
    @survey = Survey.find(params[:id])
  end
  
  def import
    return nag_upgrade unless current_admin_user.can_add_survey? && current_admin_user.has_role?('basic')
    if params[:upload]
      begin
        survey = Survey.from_xml(params[:upload].read, current_admin_user, params[:name])
        if current_admin_user.invalid_survey?(survey)
          survey.destroy
          return nag_upgrade
        else
          redirect_to survey  
        end
      rescue Exception => e
        flash[:error] = "There was an error in the document being imported."
        logger.error e.message
        redirect_to :action => :index
      end
    end
  end
  
  def xml
    return nag_upgrade unless current_admin_user.has_role?('basic')
    @survey = Survey.find(params[:id])
    @outfile = "#{@survey.name.gsub(' ','_')}_" + Time.now.strftime("%m-%d-%Y") + ".xml"
    
    @data_file = @survey.to_xml
    
    Kernel.p @data_file
    
    send_data @data_file,
    :type => 'text/xml; charset=iso-8859-1; header=present',
    :disposition => "attachment; filename=#{@outfile}"
  end
  
  def csv
    @survey = Survey.find(params[:id])
    @outfile = "#{@survey.name.gsub(' ','_')}_" + Time.now.strftime("%m-%d-%Y") + ".csv"
    
    @data_file = @survey.to_csv
    
    Kernel.p @data_file
    
    send_data @data_file,
    :type => 'text/csv; charset=iso-8859-1; header=present',
    :disposition => "attachment; filename=#{@outfile}"
  end
  
  # list of surveys
  def index
    @surveys = current_admin_user.surveys
  end
  
  # new survey form
  def new
    return nag_upgrade unless current_admin_user.can_add_survey?
    @survey = Survey.new(:disagree_link => "#", :admin_user => current_admin_user)
  end
  
  # create new survey
  def create
    return nag_upgrade unless current_admin_user.can_add_survey?
    @survey = Survey.new(params[:survey])
    @survey.admin_user = current_admin_user
    if @survey.save
      flash[:notice] = "Survey #{@survey.name} created successfully."
      redirect_to @survey
    else
      flash[:error] = "There were errors when trying to save this survey."
      render :action => :new
    end
  end
  
  # archive survey
  def destroy
    @survey = Survey.find(params[:id])
    if @survey.answered?
      @survey.archive!
    else
      @survey.destroy
    end
    redirect_to(surveys_path)
  end
  
  # edit survey
  def edit
    @survey = Survey.find(params[:id])
  end
  
  # update a survey
  def update
    @survey = Survey.find(params[:id])
    @survey.update_attributes(params[:survey])
    if @survey.save
      flash[:notice] = "Survey #{@survey.name} updated successfully."
      redirect_to :action => :index
    else
      flash[:error] = "There were errors when trying to save this survey."
      render :action => :edit
    end
  end
  
  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids
    # with underscore
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
end
