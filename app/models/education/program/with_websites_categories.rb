module Education::Program::WithWebsitesCategories
  extend ActiveSupport::Concern

  included do
    after_save_commit :set_websites_categories

    has_many   :website_post_categories,
               class_name: 'Communication::Website::Post::Category',
               dependent: :destroy

    has_many   :website_agenda_categories,
               class_name: 'Communication::Website::Agenda::Category',
               dependent: :destroy

    # TODO : Ajouter les catégories de portfolio
  end

  def set_websites_categories
    websites.each { |website| website.set_programs_categories }
  end
end
