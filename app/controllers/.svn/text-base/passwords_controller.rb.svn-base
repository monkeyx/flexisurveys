class PasswordsController < ApplicationController

  def new
    @password = Password.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @password }
    end
  end

  def create
    @password = Password.new(params[:password])
    @password.admin_user = AdminUser.find_by_email(@password.email)
    
    respond_to do |format|
      if @password.save
        PasswordMailer.deliver_forgot_password(@password)
        flash[:notice] = "A link to change your password has been sent to #{@password.email}."
        format.html { redirect_to '/' }
        format.xml  { render :xml => @password, :status => :created, :location => @password }
      else
        # use a friendlier message than standard error on missing email address
        if @password.errors.on(:admin_user)
          @password.errors.clear
          flash[:error] = "We can't find a #{user_model_name} with that email. Please check the email address and try again..."
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @password.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reset
    begin
      @admin_user = Password.find(:first, :conditions => ['reset_code = ? and expiration_date > ?', params[:reset_code], Time.now]).admin_user
    rescue
      flash[:notice] = 'The change password URL you visited is either invalid or expired.'
      redirect_to(new_password_path)
    end    
  end

  def update_after_forgetting
    @password = Password.find_by_reset_code(params[:reset_code])
    @admin_user = @password.admin_user unless @password.nil?
    
    respond_to do |format|
      if @admin_user.update_attributes(params[:admin_user])
        @password.destroy
        PasswordMailer.deliver_reset_password(@admin_user)
        @admin_user.activate! unless @admin_user
        self.current_admin_user = @admin_user
        flash[:notice] = "Password was successfully updated."
        format.html {redirect_to(surveys_path)}
      else
        flash[:notice] = 'There was a problem resetting your password. Please try again.'
        format.html { render :action => :reset, :reset_code => params[:reset_code] }
      end
    end
  end
  
end
