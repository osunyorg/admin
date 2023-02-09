module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def special_page(type, language: default_language)
    find_special_page(type, language) || translate_special_page(type, language)
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |page_class|
      page = page_class.where(website: self, university: university, language_id: default_language_id).first_or_initialize # Special pages have an before_validation (:on_create) callback to preset title, slug, ...
      next if page.persisted? # No resave
      next unless page.is_necessary_for_website? # No useless pages
      page.save_and_sync
    end
  end

  protected

  def find_special_page(type, language)
    pages.where(type: type.to_s, language_id: language.id).first
  end

  def translate_special_page(type, language)
    # Not found for given language, we create it from the page in default_language
    original_special_page = pages.where(type: type.to_s, language_id: default_language_id).first
    original_special_page.translate!(language) if original_special_page.present?
  end
end
