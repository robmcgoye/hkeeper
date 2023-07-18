class Invoice < ApplicationRecord
  belongs_to :service, :polymorphic => true
  belongs_to :statement

  scope :annual_billing, ->(service_id, service_type) { where(service_id: service_id).where(service_type: service_type).where('created_at > ?', 11.months.ago )}
  scope :monthly_billing, ->(service_id, service_type) { where(service_id: service_id).where(service_type: service_type).where('created_at > ?', 1.month.ago )}
  
  scope :domain_statement_ids, ->(domain_ids) { where(service_id: domain_ids).where(service_type: "Domain").pluck(:statement_id).uniq }
  scope :unifi_statement_ids, ->(unifi_ids) { where(service_id: unifi_ids).where(service_type: "UnifiSite").pluck(:statement_id).uniq }
  scope :computer_statement_ids, ->(computer_billing_ids) { where(service_id: computer_billing_ids).where(service_type: "ComputerBilling").pluck(:statement_id).uniq }

end