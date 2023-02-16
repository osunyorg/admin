module WithWebsites
  extend ActiveSupport::Concern

  included do 
    after_save :connect_to_websites
  end

  protected
  
  def connect_to_websites
    if respond_to?(:website)
      website.connect self
    elsif respond_to?(:websites)
      websites.each { |website| website.connect self }
    end
  end
end