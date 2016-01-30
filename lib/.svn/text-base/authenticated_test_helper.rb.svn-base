module AuthenticatedTestHelper
  # Sets the current admin_user in the session from the admin_user fixtures.
  def login_as(admin_user)
    @request.session[:admin_user_id] = admin_user ? (admin_user.is_a?(AdminUser) ? admin_user.id : admin_users(admin_user).id) : nil
  end

  def authorize_as(admin_user)
    @request.env["HTTP_AUTHORIZATION"] = admin_user ? ActionController::HttpAuthentication::Basic.encode_credentials(admin_users(admin_user).login, 'monkey') : nil
  end
  

end
