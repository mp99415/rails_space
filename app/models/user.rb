class User < ApplicationRecord
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 20
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  SCREEN_NAME_SIZE = 20
  PASSWORD_SIZE = 10
  EMAIL_SIZE = 30
  validates_uniqueness_of :screen_name,:email
  validates_length_of :screen_name,:within => SCREEN_NAME_RANGE
  validates_length_of :password,:within => PASSWORD_RANGE
  validates_length_of :email,:maximum => EMAIL_MAX_LENGTH
  validates_presence_of :email
  validates_format_of :screen_name,
                      :with => /^[A-Z0-9_]*$/i,
                      :message => "must contain only letters, numbers, and underscores",
                      :multiline => true
  validates_format_of :email,
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message => "must be a valid email address",
                      :multiline => true
  def validate
    errors.add :email,"must be valid." unless email.include?("@")
    if screen_name.include?(" ")
        errors.add :screen_name , "cannot include spaces."
    end
  end
  def login!(session)
    session[:user_id] = id
  end

  def self.logout!(session,cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end

  def clear_password!
    self.password = nil
  end
  attr_accessor :remember_me

  def remember!(cookies)
    cookie_expiration = 10.years.from_now
    cookies[:remember_me] = {:value=>"1",:expires=>cookie_expiration}
    self.authorization_token = unique_identifier
    self.save!
    cookies[:authorization_token]={
        :value=>user.authorization_token,
        :expires=>cookie_expiration
    }
  end

  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  private
  def unique_identifier
    Digest::SHA1.hexdigest("#{screen_name}:#{password}")
  end
end
