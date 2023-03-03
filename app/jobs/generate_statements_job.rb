class GenerateStatementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    accounts = Account.active_clients
    accounts.each do |account|
      # puts "Checking acct #{account.name}"
      domain_invoices(account)
      unifi_invoices(account)
    end
  end

  private

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
