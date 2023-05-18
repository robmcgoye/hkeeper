class UnifiSite < ApplicationRecord
  belongs_to :account
  has_many :statements, :as => :service, dependent: :destroy

  monetize :hosting_fee_cents
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :account_id
  
  scope :find_by_account_ids, -> (account_ids) { where(account_id: account_ids).pluck(:id) }
  scope :unifi_sites_in_account, -> (account_ids) { where(account_id: account_ids) }

  def billed_date
    statement = self.statements.last_billed.take
    if statement.nil?
      "Not Billed Yet"
    else
      statement.invoiced_at.strftime(" %m/%d/%Y")
    end
  end
end