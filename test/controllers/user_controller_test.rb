require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  fixtures :users
  def setup
    @controller = UserController.new
    @request = ActionController::TestRequest
    # @response = ActionController::TestResponse
    @valid_user = users(:valid_user)

  end
  def test_registration_success
    post "/user/register",params:{user:{screen_name:"new_screen_name",
                           email:"valid@example.com",
                           password:"long_enough_password"}}
    user=assigns(:user)
    assert_not_nil session[:user_id]
    assert_equal user.id,session[:user_id]
  end

  def test_login_page
    get "/user/login"
    title=assigns(:title)
    assert_equal "Log in to RailsSpace",title
    assert_response :success
    assert_template "login"

    # assert_tag "form", :attributes=>{:action=>"/user/login",:method=>"post"}
    # assert_tag "input",:attributes=>{:action=>"user[screen_name]",
    #                                  :type=>"text",
    #                                  :size=>User::SCREEN_NAME_SIZE,
    #                                  :maxlength=>User::SCREEN_NAME_MAX_LENGTH }
    # assert_tag "input",:attributes=>{:action=>"user[password]",
    #                                  :type=>"text",
    #                                  :size=>User::PASSWORD_SIZE,
    #                                  :maxlength=>User::PASSWORD_MAX_LENGTH }
    # assert_tag "input", :attributes=>{:type=>"submit",:value=>"Login!"}
  end

  def test_login_success
    try_to_login @valid_user
    assert_not_nil session[:user_id]
    assert_equal @valid_user.id,session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in!",flash[:notice]
    assert_redirected_to :action => "index"
  end

  def try_to_login(user)
    post "/user/login",params:{user:{screen_name:user.screen_name,password:user.password}}
  end

  def test_login_failure_with_nonexistent_screen_name
    invalid_user = @valid_user
    invalid_user.screen_name="no such user"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination",flash[:notice]
    user = assigns :user
    assert_equal invalid_user.screen_name,user.screen_name
    assert_nil user.password
  end

  def test_login_failure_with_wrong_password
    invalid_user = @valid_user
    invalid_user.password+="baz"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination",flash[:notice]
    user= assigns :user
    assert_equal invalid_user.screen_name,user.screen_name
    assert_nil user.password
  end

  def test_logout
    try_to_login @valid_user
    assert_not_nil session[:user_id]
    get "/user/logout"
    assert_response :redirect
    assert_redirected_to :action => "index",:controller => "site"
    assert_equal "Logged Out", flash[:notice]
    assert_nil session[:user_id]
  end

  def authorize(user)
    @request.new_session[:user_id] = user.id
  end

  def test_index_unauthorized
    get "/user/index"
    assert_response :redirect
    assert_redirected_to :action=>"login"
    assert_equal "Please log in first",flash[:notice]
  end

  def test_index_authorized
    authorize @valid_user
    get "/user/index"
    assert_response :success
    assert_template "index"
  end

  def test_login_friendly_url_forwarding
    get "/user/index"
    assert_response :redirect
    assert_redirected_to :action=>"login"
    try_to_login @valid_user
    assert_response :redirect
    assert_redirected_to :action=>"index"
    assert_nil session[:protected_page]
  end

  def test_register_friendly_url_forwarding
    get "/user/index"
    assert_response :redirect
    assert_redirected_to :action=>"login"
    post "/user/register",params:{user:{screen_name:"new_screen_name",
                                        email:"valid@example.com",
                                        password:"long_enough_password"}}
    assert_response :redirect
    assert_redirected_to :action=>"index"
    assert_nil session[:protected_page]
  end

end


