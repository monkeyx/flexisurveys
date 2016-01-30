# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_user
    session[:survey_user_id] ? SurveyUser.find(session[:survey_user_id]) : nil
  end
  
  def link_with_icon(url)
    link_to image_tag('link-icon.png', :alt => 'Link', :title => url, :width => 24, :height => 24), url
  end
  
  def h_symbol(value)
    value.nil? ? h(value) : value.to_s.gsub('_',' ').titleize
  end
  
  def options_from_symbols(symbols_array, allow_none=false, none_option = "None")
    options = []
    options << [none_option,''] if allow_none
    symbols_array.each do |value|
      options << [h_symbol(value),value.to_s]
    end
    options
  end
  
  def options_from_models(models, allow_none=false, name_field = :name, none_option = "None")
    options = []
    options << [none_option,''] if allow_none
    models.each do |value|
      options << [value.send(name_field),value.id]
    end
    options
  end
  
  def options_from_range(range, roman=false)
    options = []
    range.each do |value|
      display = roman ? h_roman_numeral(value) : value.to_s
      options << [display, value]
    end
    options
  end
  
  def radio_buttons_from_symbols(f, field, symbols_array)
    out = ''
    symbols_array.each do |value|
      out = "#{out}\n#{f.radio_button(field,value.to_s)}#{h_symbol(value)}"
    end
    out
  end

  def radio_buttons_from_range(f, field, range, greek=false)
    out = ''
    range.each do |value|
      display = greek ? h_greek_number(value) : value.to_s
      out = "#{out}\n#{f.radio_button(field,value.to_s)}#{display}"
    end
    out
  end

  def format_date(date)
    date.strftime("%A, %d %B %Y")  
  end
  
  def format_time(time)
    time.strftime("%R %Z")
  end
  
  def show_help(hint)
    js_func = "showhint(\"#{hint}\", this, event, '150px');"
    link_to("[?]","#", :class => "hintanchor", :onmouseover => js_func)
  end
  
  def helpful_link_to(link_text, link_url, helpful_text, options = {})
    "#{link_to("#{link_text}",link_url,options)} #{show_help(helpful_text)}"
  end
end
