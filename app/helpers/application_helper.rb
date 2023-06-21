module ApplicationHelper
  include Pagy::Frontend

  def inline_error_for(field, form_obj)
    html = []
    if form_obj.errors[field].any?
      html << form_obj.errors[field].map do |msg|
        tag.div(msg, class: "danger m-0 p-0 text-sm-start mb-2")
      end
    end
    html.join.html_safe
  end
  
  def format_date (date_to_format)
    if !date_to_format.nil?
      date_to_format.strftime(" %m/%d/%Y")
    end
  end

end
