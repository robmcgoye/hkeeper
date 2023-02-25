class UnifiSite < ApplicationRecord
  belongs_to :account

  monetize :hosting_fee_cents
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :account_id

  scope :needs_to_be_billed, -> { where('billed_on > ? OR billed_on IS ?', 1.year.from_now, nil )}

  def billed_date
    if billed_on.nil?
      "Not Billed Yet"
    else
      billed_on.strftime(" %m/%d/%Y")
    end
  end
end