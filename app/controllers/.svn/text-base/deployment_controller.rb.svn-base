class DeploymentController < ApplicationController
  require "ftools"
  SECRET_SAUCE = "tofu"
  # current beanstalk webhooks do not properly set content type to application/json so need the following to avoid errors
  skip_before_filter :verify_authenticity_token
  
  def pre_deploy
    return redirect_to "/" unless params[:secret_sauce] && params[:secret_sauce] == SECRET_SAUCE
    begin
      File.copy('public/offline.html','public/index.html')
    rescue
    end
    render :text => '', :status => 200 # beanstalk only cares to ge the 2xx status code
  end
  
  def post_deploy
    return redirect_to "/" unless params[:secret_sauce] && params[:secret_sauce] == SECRET_SAUCE
    begin
      File.delete('public/index.html')
      FileUtils.touch('tmp/restart.txt')
    rescue
    end
    render :text => '', :status => 200 # beanstalk only cares to ge the 2xx status code
  end
end
