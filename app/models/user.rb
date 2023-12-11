class User < ApplicationRecord

  validates :email, presence: true
  #validates :password, presence: true
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         #:confirmable,
         :omniauthable, omniauth_providers: [:github]
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :notifications


  after_create :send_welcome_email
  before_create :generate_otp

  def active_for_authentication?
    super && email_verified?
  end
   
  def email_verified?

    email_verified
  end

  def valid_otp?(otp)
    return false if otp_expired?
    self.otp == otp
  end
  
  def clear_otp!
    update(otp: nil)
  end

  def otp_expired?
    otp_generated_at.nil? || otp_generated_at < 15.minutes.ago
  end

  def send_new_otp
    generate_otp
    save
  end


  def signed_up_via_github?
    provider == 'github'
  end

  def has_password?
    encrypted_password.present?
  end

  private
     def send_welcome_email
       SendEmailsJob.perform_later(self)
       #SendEmailsJob.set(wait: 1.minutes).perform_later(self)
       #UserMailer.welcome_email(self).deliver_now       
     end
  
  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
    user
  end

  def generate_otp
    self.otp = rand(100000..999999).to_s
    self.otp_generated_at = Time.now
    #save
  end

end
