class Account < ApplicationRecord
  # encrypts :private_api_key
  # encrypts :private_api_key, deterministic: false
  resourcify
  
  has_many :billers, dependent: :destroy
  has_many :computers, dependent: :destroy
  has_one :computer_billing, dependent: :destroy
  has_many :domains, dependent: :destroy
  has_many :unifi_sites, dependent: :destroy
  has_many :users, through: :roles, class_name: 'User', source: :users
  has_many :managers, -> { where(roles: {name: :manager}) }, through: :roles, class_name: 'User', source: :users

  before_create :set_private_api_key
  validates :private_api_key, uniqueness: true, allow_blank: true
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  
  scope :active_clients, -> { where(active: true) }
  scope :api_key, -> (token) { active_clients.where(private_api_key: token).take }

  private

  def set_private_api_key
    self.private_api_key = SecureRandom.hex
  end
  

end