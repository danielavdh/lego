# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
      include ApplicationHelper
      before_filter :set_locale
      helper :all # include all helpers, all the time
      protect_from_forgery # See ActionController::RequestForgeryProtection for details
      filter_parameter_logging :password

protected

  def authorize
    guest_paths = ["playing/recordings", "playing/play_audio", "playing/stop_audio"]
    guest_path = guest_paths.detect{|p| request.path.match(p)}
    guest_path = true unless guest_path.blank?
    friend_paths = ["playing/recordings", "playing/play_video", "playing/stop_video"] + guest_paths[1..2]
    friend_path = friend_paths.detect{|p| request.path.match(p)}
    friend_path = true unless friend_path.blank?
    sudo = Admin.find_by_id(session[:sudo_id])
    admin = Admin.find_by_id(session[:user_id])
    friend = Admin.find_by_id(session[:friend_id]) && friend_path == true
    guest = Admin.find_by_id(session[:guest_id]) && guest_path == true
    unless sudo || admin || friend || guest
      redirect_to :controller => :welcome, :action => :index
    else
      #if admin
      #  @superuser = sudo.name
      #end
    end
  end
  
  def superauthorize
    unless session[:sudo_id]
      redirect_to :controller => :welcome, :action => :index
    end
  end
  
  def authorize_student
    unless Student.find_by_id(session[:student_id])
      redirect_to :controller => :teaching, :action => :studentzone
    end
  end
  
  def set_locale
    if params[:locale]
      session[:locale] = params[:locale] 
    else
      unless session[:locale]
        session[:locale] = request.env["HTTP_ACCEPT_LANGUAGE"].to_s[0..1] || I18n.default_locale
      end
    end
    I18n.locale = session[:locale] || request.env["HTTP_ACCEPT_LANGUAGE"].to_s[0..1] || I18n.default_locale
    locale_path = "#{LOCALES_DIRECTORY}#{I18n.locale}.yml"
    unless I18n.load_path.include? locale_path
      I18n.load_path << locale_path
      I18n.backend.send(:init_translations)
    end
  rescue Exception => err
    logger.error err
    flash.now[:notice] = "#{I18n.locale} translation not available"
    I18n.load_path -= [locale_path]
    I18n.locale = @lang = session[:locale] = I18n.default_locale
  end
end
