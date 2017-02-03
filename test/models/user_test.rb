require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @error_messages = ActiveRecord::Errors.default_error_messages
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end

  def test_user_validity
    assert @valid_user.valid?
  end

  def test_user_invalidity
    assert !@invalid_user.valid?
  end

  def test_uniqueness_of_screen_name_and_email
    user_repeat = User.new(:screen_name=> @valid_user.screen_name,
                            :email=> @valid_user.email,
                            :password=> @valid_user.password)
    assert !user_repeat.valid?
    assert_equal @error_messages[:taken], user_repeat.errors[:screen_name]
    assert_equal @error_messages[:taken], user_repeat.errors[:email]
  end
end
