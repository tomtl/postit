module ApplicationHelper
  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end
  
  def display_datetime(datetime_input)
    datetime_input.strftime("%D %r %Z") # 3/23/2015 9:09am UTC
  end
  
end
