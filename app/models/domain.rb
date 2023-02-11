class Domain < ApplicationRecord
  belongs_to :account

  VALID_DOMAIN_REGEX = /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}\z/i
  validates :name, presence: true, 
                    length: { minimum: 3 },
                    format: { with: VALID_DOMAIN_REGEX }
  validates :expires_on, presence: true
  validates_uniqueness_of :name

  monetize :registration_fee_cents
  monetize :hosting_fee_cents

  def annual_fee
    return ((registration_fee_cents + hosting_fee_cents) / 100.00).to_f
  end

  def billed_date
    if billed_on.nil?
      "Not Billed Yet"
    else
      billed_on.strftime(" %m/%d/%Y")
    end
  end
end