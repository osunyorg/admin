# Le website utilise WithGit sans WithWebsites, parce qu'il en est un
module WithWebsites
  extend ActiveSupport::Concern

  included do 
    include WithGit

    after_save  :connect_to_websites
    after_touch :connect_to_websites
  end

  def websites
    @websites ||= Communication::Website::Connection.websites_for self
  end

  def for_website?(website)
    Communication::Website::Connection.in_website(website).for_object(self).exists?
  end

  protected
  
  def connect_to_websites
    respond_to?(:website) ? connect_directly
                          : connect_indirectly
  end

  def connect_directly
    website.connect self, self
  end

  def connect_indirectly
    websites.each do |website|
      # Only direct connections
      website.connection_sources_for(self).each do |source|
        website.connect self, source
      end
    end
  end
end