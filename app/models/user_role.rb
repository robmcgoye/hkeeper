class UserRole
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Naming

  attr_accessor :admin, :tech, :user
  

  def initialize(attributes = {})
    # @errors = ActiveModel::Errors.new(self)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
   
  def update(user)
    if !((user.has_role? :admin) && self.admin.to_i == 1) 
      if self.admin.to_i == 1
        user.add_role :admin
      else
        user.remove_role :admin
      end
    end 
    if !((user.has_role? :tech) && self.tech.to_i == 1) 
      if self.tech.to_i == 1
        user.add_role :tech
      else
        user.remove_role :tech
      end
    end 
    if !((user.has_role? :user) && self.user.to_i == 1) 
      if self.user.to_i == 1
        user.add_role :user
      else
        user.remove_role :user
      end
    end 
    if !user.has_any_role?
      user.add_role :user
      false
    else
      true
    end      
  end


end