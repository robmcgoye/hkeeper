class ComputerBilling < ApplicationRecord
  belongs_to :account
  has_many :statements, :as => :service, dependent: :destroy 
  
  monetize :cost_per_computer_cents

end