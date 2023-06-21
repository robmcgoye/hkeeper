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
     
  def filter(domain, sort = "account")
    if self.account_id.to_i > 0
      if sort == "account"
        domain.domains_in_account(self.account_id.to_i).sort_on_account 
      elsif sort == "name"
        domain.domains_in_account(self.account_id.to_i).sort_on_name 
      elsif sort == "expires"
        domain.domains_in_account(self.account_id.to_i).sort_on_expires 
      else
        domain.domains_in_account(self.account_id.to_i)
      end
    else
      if sort == "account"
        domain.sort_on_account 
      elsif sort == "name"
        domain.sort_on_name 
      elsif sort == "expires"
        domain.sort_on_expires 
      else
        domain
      end
    end
  end

end