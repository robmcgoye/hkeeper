class GenerateStatementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    accounts = Account.active_clients
    accounts.each do |account|
      puts "Checking acct #{account.name}"
      domains_to_be_billed = account.domains.needs_to_be_billed
      if domains_to_be_billed.count > 0
        puts "creating statement..."
        statement = Statement.new
        statement.account = account
        domains_to_be_billed.each do |domain|
          puts "adding line item"
          line_item = LineItem.new
          line_item.quantity = 1
          fee = 0
          if domain.web_hosting || domain.email_hosting
            desc1 = "Anual fee for hosting #{domain.name}\n"
            fee += domain.hosting_fee_cents
          end
          if domain.registration
            desc2 = "Annual fee for registration of #{domain.name}\n"
            fee += domain.registration_fee_cents
          end
          line_item.description = "#{desc1}#{desc2}"
          line_item.amount_cents = fee
          statement.line_items << line_item
          puts "Updating billing date."
          domain.billed_on = Date.today
          domain.save

        end
      end
      statement.save
      puts "saved statement"
    end

  end

end
