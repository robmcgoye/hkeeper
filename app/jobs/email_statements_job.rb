class EmailStatementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    statements = Statement.unpaid
    statements.each do |statement|
      if statement.emailed_at.nil?
        # puts "Sending email for new statement #{statement.id}"
        UserMailer.new_statement(statement).deliver_later
        statement.emailed_at = Date.today
        statement.save
      else
        if statement.due_at < Date.today && (statement.emailed_at + statement.terms.days) < Date.today
          # overdue
          UserMailer.overdue_statement(statement).deliver_later
          statement.emailed_at = Date.today
          statement.save
        end
      end
    end
  end
end
