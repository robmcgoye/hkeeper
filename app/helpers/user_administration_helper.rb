module UserAdministrationHelper

  def format_roles(user)
    formatted_roles = ""
    roles = user.roles.where(resource_type: nil).pluck(:name)
    roles.each do |role|
      formatted_roles += "<span class='ms-1 badge rounded-pill #{role == "user" ? "bg-secondary" : "bg-primary" }'> #{role} </span>"
    end
    return formatted_roles.html_safe
  end

end
