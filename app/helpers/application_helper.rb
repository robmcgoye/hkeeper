module ApplicationHelper
  include Pagy::Frontend

  def get_previous_page
    referer = URI(request.referer)
    if !referer.query.nil?
      query_params = Rack::Utils.parse_query referer.query
      if !query_params["page"].nil?
        query_params["page"]
      end
    end  
  end
  

end
