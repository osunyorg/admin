module Education::Program::WithWebsites
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_websites_categories_callback

    after_save_commit :set_websites_categories, unless: :skip_websites_categories_callback

    # FIXME incorrect, forgets websites about programs
    has_many   :websites, -> { distinct },
               through: :schools

    has_many   :website_categories,
               class_name: 'Communication::Website::Category',
               dependent: :destroy
  end

  def set_websites_categories
    websites.find_each(&:set_programs_categories!)
  end
end
