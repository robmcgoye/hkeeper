class Biller < ApplicationRecord
  belongs_to :account

  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :name, presence: true

  def email
    if !self.user_id.nil?
      User.find(self.user_id).email
    else
      "Not set"
    end
  end

end