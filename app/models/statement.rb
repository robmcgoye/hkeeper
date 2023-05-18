class Statement < ApplicationRecord
  belongs_to :service, :polymorphic => true
  has_many :line_items, dependent: :destroy
  # attribute :email_user
  enum :status, { pending: 0, unpaid: 1, paid: 2, voided: 3 }, default: :pending

  scope :annual_billing, -> { where('invoiced_at > ?', 1.year.ago )}
  scope :monthly_billing, -> { where('invoiced_at > ?', 1.month.ago )}
  scope :unpaid, -> { where(status: 'unpaid').order(invoiced_at: :desc) }
  scope :paid, -> { where(status: 'paid').order(invoiced_at: :desc) }
  scope :pending, -> { where(status: 'pending').order(invoiced_at: :desc) }
  scope :voided, -> { where(status: 'voided').order(invoiced_at: :desc) }
  scope :last_billed, -> { where(status: ['paid', 'unpaid']).order(invoiced_at: :desc)}
  scope :empty, -> { where(status: 'empty') }
  scope :unifi_ids, -> (unifisite_ids) { where(service_id: unifisite_ids).where(service_type: "UnifiSite").pluck(:id) }
  scope :domain_ids, -> (domain_ids) { where(service_id: domain_ids).where(service_type: "Domain").pluck(:id) }

  before_create do
    if Statement.count > 0
      self.invoice_number = Statement.last.invoice_number + 1
    else
      self.invoice_number = 100
    end 
    self.invoiced_at = Date.today
    self.terms = 15
    self.due_at = self.invoiced_at + self.terms.days
  end

  before_update do
    self.due_at = invoiced_at + terms.days
  end

  def self.statements_in_account(account_id)
    unifi_ids = self.unifi_ids(UnifiSite.find_by_account_ids(account_id))
    domain_ids = self.domain_ids(Domain.find_by_account_ids(account_id))
    self.where(id: (domain_ids + unifi_ids))
  end

  def total
    total = 0
    line_items.each do |item|
      total += (item.quantity * item.amount_cents)
    end
    total
  end

  def emailed_date
    if emailed_at.nil?
      "Not emailed yet"
    else
      emailed_at.strftime(" %m/%d/%Y")
    end
  end

end