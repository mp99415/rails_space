class UserController < ApplicationController
  before_action :protect,:only => :index

  def index
    @title = "RailsSpace User Hub"
  end

  def login
    @title = "Log in to RailsSpace"
    if request.get?
      @user = User.new(:remember_me=>cookies[:remember_me]||0)
    elsif param_posted? :user
      params.permit!
      @user=User.new params[:user]
      user = User.find_by_screen_name_and_password(@user.screen_name,@user.password)
      if user
        user.login!(session)
        if @user.remember_me == "1"
          user.remember!(cookies)
        else
          user.forget!(cookies)
        end
        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to_forwarding_url
     else
        @user.clear_password!
        flash[:notice] = "Invalid screen name/password combination"
      end
    end
  end

  def logout
    User.logout!(session,cookies)
    flash[:notice] = "Logged Out"
    redirect_to :action=> "index",:controller => "site"
  end


  def register
    @title = "Register"
    if param_posted? :user
      params.permit!
      @user=User.new params[:user]
      if @user.save
        @user.login!(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to_forwarding_url
      else
        @user.clear_password!
      end
    end
  end

  private
  def protect
    unless logged_in?
      session[:protected_page] = request.request_id
      flash[:notice] = "Please log in first"
      redirect_to :action=> "login"
      return false
    end
  end


  def param_posted?(symbol)
    request.post? and params[symbol]
  end


  def redirect_to_forwarding_url
    if(redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :action=>"index"
    end
  end
end
