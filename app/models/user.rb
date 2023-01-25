class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  def self.find_for_oauth(auth)
    @user = User.find_or_create_by!(email: auth.info.email) do |user|
      user.uid = auth.uid
      user.provider = auth.provider
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  rescue StandardError => e
    e.message 
  end


  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end
end
