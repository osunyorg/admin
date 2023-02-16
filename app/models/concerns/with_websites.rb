module WithWebsites
  extend ActiveSupport::Concern

  included do 
    after_save :connect_to_websites
  end

  def websites
    @websites ||= Communication::Website::Connection.websites_for self
  end

  protected
  
  def connect_to_websites
    if respond_to?(:website)
      website.connect self
    else
      websites.each { |website| website.connect self }
    end
  end
end