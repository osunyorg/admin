module Education::Program::WithWebsitesCategories
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_websites_categories_callback

    after_save_commit :set_websites_categories,
                      unless: :skip_websites_categories_callback

    has_many   :website_categories,
               class_name: 'Communication::Website::Category',
               dependent: :destroy
  end

  def set_websites_categories
    websites.each { |website| website.set_programs_categories! }
  end
end
