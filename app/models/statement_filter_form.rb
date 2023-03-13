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
                  
end