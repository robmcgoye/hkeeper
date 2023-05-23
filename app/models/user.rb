class User < ApplicationRecord
  rolify
  attr_accessor :current_password, :confirmed_email
  # before_save { self.email = email.downcase }
  before_save :format_data
  after_create :assign_default_role

  after_initialize do |user|
    user.confirmed_email = user.confirmed?
  end

  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = CONFIG[:send_email_from]

  has_many :accounts, through: :roles, source: :resource, source_type: :Account
  # has_many :moderated_forums, -> { where(roles: {name: :moderator}) }, through: :roles, source: :resource, source_type:  :Forum

  has_secure_password

  scope :all_except, ->(user) { where.not(id: user) }

  validates :first_name, presence: true, 
                    length: { minimum: 3, maximum: 100 }

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, 
            presence: true, 
            uniqueness: { case_sensitive: false },
            length: { maximum: 125 }
  
  validates :unconfirmed_email, format: {with: URI::MailTo::EMAIL_REGEXP, allow_blank: true}
  
  def full_name
    "#{ first_name.capitalize } #{ last_name.capitalize }"
  end

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_later
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_later
  end
          
  def confirm!
    if unconfirmed_or_reconfirming?
      if unconfirmed_email.present?
        return false unless update(email: unconfirmed_email, unconfirmed_email: nil)
      end
      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def unconfirmed?
    !confirmed?
  end

  def reconfirming?
    unconfirmed_email.present?
  end

  def unconfirmed_or_reconfirming?
    unconfirmed? || reconfirming?
  end

  def confirmable_email
    if unconfirmed_email.present?
      unconfirmed_email
    else
      email
    end
  end
  
  private

  def downcase_unconfirmed_email
    return if unconfirmed_email.nil?
    self.unconfirmed_email = unconfirmed_email.downcase
  end

  def format_data
    downcase_unconfirmed_email
    self.email = email.downcase
    if !self.confirmed_email.nil?
      if self.confirmed_email != self.confirmed_at? && self.confirmed_at?
        self.confirmed_at = nil
      elsif self.confirmed_email != self.confirmed_at? && !self.confirmed_at?
        self.confirmed_at = Date.today
      end
    end
  end

  def assign_default_role
    if User.count == 1
      add_role(:admin) if roles.blank?
      # add_role(:teacher)
      # add_role(:student)
    else
      add_role(:user) if roles.blank?
    end
    # self.add_role(:enduser) if self.roles.blank?
  end

end