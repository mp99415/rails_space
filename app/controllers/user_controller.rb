class UserController < ApplicationController
  def index
  end

  def login
    @title = "Log in to RailsSpace"
    if request.post? and params[:user]
      params.permit!
      @user=User.new params[:user]
      user = User.find_by_screen_name_and_password(@user.screen_name,@user.password)
      if user
        session[:user_id] = user.id
        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to :action=>"index"
      else
        @user.password=nil
        flash[:notice] = "Invalid screen/password combination"
      end
    end
  end

  def register
    @title = "Register"
    if request.post? and params[:user]
      params.permit!
      @user=User.new params[:user]
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to :action => "index"
      end
    end
  end
end
