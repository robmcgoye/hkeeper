class ComputerBilling < ApplicationRecord
  belongs_to :account
  has_many :statements, :as => :service, dependent: :destroy 
  
  monetize :cost_per_computer_cents

  def display_cost_per_computer
    if !self.cost_per_computer.nil?
      self.cost_per_computer.format
    else
      "Not set"
    end
  end
end