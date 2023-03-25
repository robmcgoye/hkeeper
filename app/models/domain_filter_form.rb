class DomainFilterForm
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
     
  def filter(domain)
    if self.account_id.to_i > 0
      domain.domains_in_account(self.account_id.to_i)
    else
      domain
    end
  end

end