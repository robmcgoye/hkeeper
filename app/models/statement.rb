class Statement < ApplicationRecord
  belongs_to :account
  has_many :line_items, :dependent => :delete_all

  enum :status, { unpaid: 0, paid: 1, voided: 2 }, default: :unpaid

  before_create do
    if Statement.count > 0
      self.invoice_number = Statement.last.invoice_number + 1
    else
      self.invoice_number = 100
    end 
  end

  def total
    total = 0
    self.line_items.each do |item|
      total += (item.quantity * item.amount_cents)
    end
    total
  end

end