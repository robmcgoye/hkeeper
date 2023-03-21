class ComputerBilling < ApplicationRecord
  belongs_to :account
  has_many :statements, :as => :service
  
  monetize :cost_per_job_cents

end