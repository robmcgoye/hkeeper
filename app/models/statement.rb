class Statement < ApplicationRecord
  has_many :invoices
  # , dependent: :destroy
  has_many :line_items, dependent: :destroy

  enum :status, { pending: 0, unpaid: 1, paid: 2, voided: 3 }, default: :pending

  scope :unpaid, -> { where(status: 'unpaid').order(invoiced_at: :desc) }
  scope :paid, -> { where(status: 'paid').order(invoiced_at: :desc) }
  scope :pending, -> { where(status: 'pending').order(invoiced_at: :desc) }
  scope :voided, -> { where(status: 'voided').order(invoiced_at: :desc) }
  scope :last_billed, ->(statement_ids) { where(id: statement_ids).where(status: ['paid', 'unpaid']).order(invoiced_at: :desc) }
  scope :empty, -> { where(status: 'empty') }

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
    unifi_statement_ids = Invoice.unifi_statement_ids(UnifiSite.find_by_account_ids(account_id))
    domain_statement_ids = Invoice.domain_statement_ids(Domain.find_by_account_ids(account_id))
    computer_statement_ids = Invoice.computer_statement_ids(ComputerBilling.find_by_account_ids(account_id))
    
    self.where(id: (unifi_statement_ids + domain_statement_ids + computer_statement_ids).uniq)
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

  def account
    self.invoices.first.service.account
  end

end