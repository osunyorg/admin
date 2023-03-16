module WithWebsites
  extend ActiveSupport::Concern

  included do 
    after_save :connect_to_websites
  end

  def websites
    @websites ||= Communication::Website::Connection.websites_for self
  end

  def for_website?(website)
    Communication::Website::Connection.in_website(website).for_object(self).exists?
  end

  protected
  
  def connect_to_websites
    if respond_to?(:website) && !website.nil?
      website.connect self
    else
      websites.each { |website| website.connect self }
    end
  end
end