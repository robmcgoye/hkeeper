class GenerateStatementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # accounts = Account.active_clients
    Account.active_clients.each do |account|
      create_statement(account)
      # puts "Checking acct #{account.name}"
    end
  end

  private

  def computer_invoices(account)
    line_items = Array.new
    computers = account.computers
    if computers.count > 0
      computers.each do |computer|
        if !computer.last_contacted_at.nil?
          if computer.last_contacted_at > (Date.today - 1.month)
            
            if not(account.computer_billing.nil?) && (Invoice.annual_billing(account.computer_billing.id, "ComputerBilling").empty?)
              job_count = computer.jobs.active_jobs.count
              if job_count > 0
                line_items << LineItem.new(quantity: 1, description: "Monthly fee for #{computer.name} with description #{computer.description}", amount_cents: account.computer_billing.cost_per_computer_cents)
              end
            end
          end
        end
      end
    end
    return line_items
  end 

  def get_services_to_be_billed(ids, service_type)
    ids_to_bill = Array.new
    ids.each do |id|
      if Invoice.annual_billing(id, service_type).empty?
        ids_to_bill << id
      end
    end
    return ids_to_bill
  end

  def create_statement(account)
    domain_ids_to_be_billed = get_services_to_be_billed(account.domain_ids, "Domain")
    unifi_site_ids_to_be_billed = get_services_to_be_billed(account.unifi_site_ids, "UnifiSite")
    if !domain_ids_to_be_billed.empty? || !unifi_site_ids_to_be_billed.empty?
      statement = Statement.new
      # domains
      domain_ids_to_be_billed.each do |id|
        domain = Domain.find(id)
        if domain.registration
          statement.line_items << LineItem.new(quantity: 1, 
            description: "Annual fee for registration of #{domain.name}", amount_cents: domain.registration_fee_cents)
        end 
        if domain.web_hosting || domain.email_hosting
          statement.line_items << LineItem.new(quantity: 1, description: "Anual fee for hosting #{domain.name}", amount_cents: domain.hosting_fee_cents)
        end      
      end
      # unifi sites
      unifi_site_ids_to_be_billed.each do |id|
        unifi_site = UnifiSite.find(id)
        statement.line_items << LineItem.new(quantity: 1, description: "Annual fee for unifi controller hosting", amount_cents: unifi_site.hosting_fee_cents)
      end
      # computers
      computer_billings = computer_invoices(account)
      computer_billings.each do |item|
        statement.line_items << item
      end
      # 
      statement.save
      domain_ids_to_be_billed.each do |id|
        Invoice.create!(statement_id: statement.id, service_id: id, service_type: "Domain")
      end
      unifi_site_ids_to_be_billed.each do |id|
        Invoice.create!(statement_id: statement.id, service_id: id, service_type: "UnifiSite")
      end
      if !computer_billings.empty?
        Invoice.create!(statement_id: statement.id, service_id: id, service_type: "ComputerBilling")
      end
    end 
  end
end
