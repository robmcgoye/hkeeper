class ComputerBilling < ApplicationRecord
  belongs_to :account
  has_many :invoices, :as => :service, dependent: :destroy 
  
  monetize :cost_per_computer_cents

  scope :find_by_account_ids, -> (account_ids) { where(account_id: account_ids).pluck(:id) }
  
  def display_cost_per_computer
    if !self.cost_per_computer.nil?
      self.cost_per_computer.format
    else
      "Not set"
    end
  end
end