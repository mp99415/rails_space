module ApplicationHelper
  def nav_link(text,controller,action="index")
    return link_to_unless_current text,:controller => controller,
                                  :action => action
  end

  def logged_in?
     not session[:user_id].nil?
  end
end
