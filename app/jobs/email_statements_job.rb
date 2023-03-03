class EmailStatementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # statements = Statement.
  end
end
