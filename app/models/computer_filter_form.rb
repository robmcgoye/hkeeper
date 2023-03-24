class ComputerFilterForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Naming

  attr_accessor :account_id

  def initialize(attributes = {})
    # @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      send("#{name}=", value)
    end

  end

  def persisted?
    false
  end
     
  def filter(computer)
    if self.account_id.to_i > 0
      computer.computers_in_account(self.account_id.to_i)
    else
      computer
    end
  end

end