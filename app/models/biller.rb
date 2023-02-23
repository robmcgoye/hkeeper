class Biller < ApplicationRecord
  belongs_to :account

  validates :address_line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  def email
    User.find(self.user_id).email
  end

end