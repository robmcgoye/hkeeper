class StatementFilterForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Naming

  attr_accessor :paid, :unpaid, :pending, :voided, :account_id

  def initialize(attributes = {})
    # @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    self.unpaid ||= 1
  end

  def persisted?
    false
  end
            
  def filter(statement)
    query = Statement.empty
    if self.pending.to_i == 1
      query += (statement.pending).pluck(:id)
    end
    if self.unpaid.to_i == 1
      query += (statement.unpaid).pluck(:id)
    end
    if self.paid.to_i == 1
      query += (statement.paid).pluck(:id)
    end        
    if self.voided.to_i == 1
      query += (statement.voided).pluck(:id)
    end
    if self.account_id.to_i > 0
      (Statement.where(id: query)).statements_in_account(self.account_id).order(invoiced_at: :desc)
    else
      (Statement.where(id: query).order(invoiced_at: :desc))  
    end
  end
end