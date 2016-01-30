class AdminUserObserver < ActiveRecord::Observer
  def after_create(admin_user)
    AdminUserMailer.deliver_signup_notification(admin_user)
  end

  def after_save(admin_user)
    AdminUserMailer.deliver_activation(admin_user) if admin_user.recently_activated?
  end
end
