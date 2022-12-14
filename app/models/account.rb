class Account < ApplicationRecord
  # encrypts :private_api_key
  # encrypts :private_api_key, deterministic: false
  resourcify
  
  has_many :computers, :dependent => :delete_all 
  has_many :users, through: :roles, class_name: 'User', source: :users
  has_many :managers, -> { where(roles: {name: :manager}) }, through: :roles, class_name: 'User', source: :users

  before_create :set_private_api_key
  validates :private_api_key, uniqueness: true, allow_blank: true

  private

  def set_private_api_key
    self.private_api_key = SecureRandom.hex

  end
  
end