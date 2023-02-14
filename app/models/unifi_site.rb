class UnifiSite < ApplicationRecord
  belongs_to :account

  monetize :hosting_fee_cents
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :account_id

  def billed_date
    if billed_on.nil?
      "Not Billed Yet"
    else
      billed_on.strftime(" %m/%d/%Y")
    end
  end
end