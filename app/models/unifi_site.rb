class UnifiSite < ApplicationRecord
  belongs_to :account
  has_many :statements, :as => :service

  monetize :hosting_fee_cents
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :account_id

  def billed_date
    statement = self.statements.last_billed.take
    if statement.nil?
      "Not Billed Yet"
    else
      statement.invoiced_at.strftime(" %m/%d/%Y")
    end
  end
end