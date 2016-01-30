class AdminUsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  
  # render new.rhtml
  def new
    @admin_user = AdminUser.new(:terms_accepted => false)
  end
  
  def create
    logout_keeping_session!
    @admin_user = AdminUser.new(params[:admin_user])
    
    # Kernel.p "TERMS ACCEPTED ? #{@admin_user.terms_accepted}"
    unless @admin_user.terms_accepted == 1
      @admin_user.errors.add(:terms_accepted, "must be accepted before proceeding")
    end if @admin_user
    
    success = @admin_user && @admin_user.save
    
    if success && @admin_user.errors.empty?
      redirect_back_or_default('/tutorial')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (via the feedback link)."
      render :action => 'new'
    end
  end
  
  def activate
    logout_keeping_session!
    admin_user = AdminUser.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && admin_user && !admin_user.active?
      admin_user.activate!
      self.current_admin_user = admin_user
      redirect_back_or_default(surveys_path)
      flash[:notice] = "Signup complete! Thanks for activating your account."
      when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find an account with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def account
    if request.put?
      if AdminUser.authenticate(current_admin_user.login, params[:old_password])
        unless params[:password_confirmation].blank?
          if params[:password] == params[:password_confirmation]
            current_admin_user.password_confirmation = params[:password_confirmation]
            current_admin_user.password = params[:password]
          else
            flash[:warning] = "New Password mismatch" 
          end
        end
        current_admin_user.email = params[:email] unless params[:email].blank?
        if current_admin_user.save
          unless params[:email].blank?
            current_admin_user.make_activation_code
            current_admin_user.save
            flash[:notice] = "Please follow the link in the email we've just sent you to confirm your new email address."
          else
            flash[:notice] = "Account successfully updated"
          end
          AdminUserMailer.deliver_account_update(current_admin_user)
        else
          flash[:warning] = "Changes not made"
        end
      else
        flash[:warning] = "Password incorrect" 
      end
    end
  end
  
end
