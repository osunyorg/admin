module ApplicationHelper

  def controller_class
    "#{controller_name.gsub('/', '--')}"
  end

  def body_classes
    classes = "controller-#{controller_class}"
    classes += " action-#{action_name}"
    classes += " #{controller_class}-#{action_name}"
    classes
  end

  def social_website_to_url(string)
    string = "https://#{string}" unless string.start_with?('http')
    string.gsub('http://', 'https://')
  end

  def social_website_to_s(string)
    string.gsub('http://', '')
          .gsub('https://', '')
  end

  def social_linkedin_to_url(string)
    string.gsub('http://', 'https://')
  end

  def social_linkedin_to_s(string)
    string.gsub('http://', 'https://')
          .gsub('https://www.linkedin.com/in/', '')
  end

  def social_twitter_to_url(string)
    string = "https://twitter.com/#{string}" unless 'twitter.com'.in? string
    string = "https://#{string}" unless string.start_with?('http')
    string.gsub('http://', 'https://')
  end

  def social_twitter_to_s(string)
    string.gsub('http://', 'https://')
          .gsub('https://www.twitter.com/', 'https://twitter.com/')
          .gsub('https://twitter.com/', '')
  end
end
