class GenerateStatementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    accounts = Account.active_clients
    accounts.each do |account|
      # puts "Checking acct #{account.name}"
      domain_invoices(account)
      unifi_invoices(account)
      computer_invoices(account)
    end
  end

  private

  def computer_invoices(account)
    puts "Checking computers..."
    computers = account.computers
    line_items = Array.new
    if computers.count > 0
      computers.each do |computer|

        puts "Checking #{computer.name}..."
    
        if !computer.last_contacted_at.nil?

          puts "#{computer.name} is actively checking in #{computer.last_contacted_at}"
          
          if computer.last_contacted_at > (Date.today - 1.month)
            if account.computer_billing.statements.monthly_billing.empty?
              job_count = computer.jobs.active_jobs.count
              if job_count > 0
                item = LineItem.new
                item.quantity = job_count
                item.description = "Monthly fee for jobs on #{computer.name}"
                item.amount_cents = account.computer_billing.cost_per_job_cents
                line_items.push(item)
              end
            end
          end
        end
      end
      if line_items.count > 0
        statement = account.computer_billing.statements.new
        line_items.each do |item|
          statement.line_items << item
        end
        statement.save
      end
    end
  end 

  def unifi_invoices(account)
    unifi_sites = account.unifi_sites
    if unifi_sites.count > 0
      unifi_sites.each do |unifi|
        if unifi.statements.annual_billing.empty?
          statement = unifi.statements.new
          line_item = LineItem.new
          line_item.quantity = 1
          line_item.description = "Annual fee for unifi controller hosting"
          line_item.amount_cents = unifi.hosting_fee_cents
          statement.line_items << line_item
          statement.save
        end 
      end
    end
  end

  def domain_invoices(account)
    domains = account.domains
    if domains.count > 0
      domains.each do |domain|
        if domain.statements.annual_billing.empty?
          statement = domain.statements.new
          if domain.registration
            line_item = LineItem.new
            line_item.quantity = 1
            line_item.description = "Annual fee for registration of #{domain.name}"
            line_item.amount_cents = domain.registration_fee_cents
            statement.line_items << line_item
          end 
          if domain.web_hosting || domain.email_hosting
            line_item = LineItem.new
            line_item.quantity = 1
            line_item.description = "Anual fee for hosting #{domain.name}"
            line_item.amount_cents = domain.hosting_fee_cents
            statement.line_items << line_item
          end
          statement.save           
        end
      end
    end  
  end

end
