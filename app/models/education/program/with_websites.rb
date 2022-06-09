module Education::Program::WithWebsites
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_websites_categories_callback

    after_save_commit :set_websites_categories,
                      unless: :skip_websites_categories_callback

    has_many   :website_categories,
               class_name: 'Communication::Website::Category',
               dependent: :destroy
  end

  def websites
    @websites ||= university.websites.reject do |website|
      website_concerned = false
      # Site de formation
      website_concerned = true if website.about == self
      # Site d'école
      if website.about&.is_a? Education::School
        # Formation dispensée dans l'école
        website_concerned = true if self.in? website.about.programs
      end
      !website_concerned
    end
  end

  def set_websites_categories
    websites.each { |website| website.set_programs_categories! }
  end
end
