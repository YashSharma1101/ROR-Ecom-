class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         #:confirmable,
         :omniauthable, omniauth_providers: [:github]

  after_create :send_welcome_email

  private
     def send_welcome_email
       #SendEmailsJob.set(wait: 1.minutes).perform_later(self)
       SendEmailsJob.perform_later(self)       
     end
  
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
    user
  end

  before_create :generate_otp

  def generate_otp
    self.otp = rand(100000..999999).to_s
    self.otp_generated_at = Time.now
    #save
    
  end
  def send_otp
    @user = current_user
    @user.generate_otp
    @user.save
  end

  def otp_expired?
    #otp_generated_at < 15.minutes.ago
  end

  def verify_otp(submitted_otp)
    return false if otp_expired?

    if otp == submitted_otp
      self.email_verified = true
      save
      true
    else
      false
    end
  end

end
