class Statement < ApplicationRecord
  belongs_to :account
  has_many :line_items, :dependent => :delete_all

  enum :status, { pending: 0, unpaid: 1, paid: 2, voided: 3 }, default: :pending

  before_create do
    if Statement.count > 0
      self.invoice_number = Statement.last.invoice_number + 1
    else
      self.invoice_number = 100
    end 
    self.invoiced_at = Date.today
    self.terms = 15
  end

  def total
    total = 0
    self.line_items.each do |item|
      total += (item.quantity * item.amount_cents)
    end
    total
  end

  def due_at
    self.invoiced_at + (self.terms).days
  end

end