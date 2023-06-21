class Domain < ApplicationRecord
  belongs_to :account
  has_many :statements, :as => :service, dependent: :destroy
  
  VALID_DOMAIN_REGEX = /\A[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}\z/i
  validates :name, presence: true, 
                    length: { minimum: 3 },
                    format: { with: VALID_DOMAIN_REGEX }
  validates :expires_on, presence: true
  validates_uniqueness_of :name

  monetize :registration_fee_cents
  monetize :hosting_fee_cents

  # scope :needs_to_be_billed, -> { where('billed_on > ? OR billed_on IS ?', 1.year.from_now, nil )}
  scope :find_by_account_ids, -> (account_ids) { where(account_id: account_ids).pluck(:id) }
  scope :domains_in_account, -> (account_ids) { where(account_id: account_ids)}
  scope :sort_on_account, -> { joins(:account).order('accounts.name') }
  scope :sort_on_name, -> { order(:name) }
  scope :sort_on_expires, -> { order(:expires_on) } 
  scope :sort_on_created, -> { order(created_at: :desc) }

  def annual_fee
    return registration_fee_cents + hosting_fee_cents
  end

  def billed_date
    statement = self.statements.last_billed.take
    if statement.nil?
      "Not Billed Yet"
    else
      statement.invoiced_at.strftime(" %m/%d/%Y")
    end
  end
end