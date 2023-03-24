module CookieStore
  extend ActiveSupport::Concern

  def set_page_number(name, page_number)
  end

  def get_page_number(name)
  end

  def set_filter(name, filter_params)
    # binding.break
    cookies[name] = filter_params.inspect
  end

  def get_filter(name)
    if !cookies[name].nil?
      JSON.parse cookies[name].gsub('=>', ":")
    end
  end

end