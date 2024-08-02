module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def special_page(type)
    page = find_special_page(type)
    page ||= create_default_special_page(type)
    page
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |page_class|
      # Special pages have a before_validation (:on_create) callback to preset the original localization (title, slug, ...)
      page = page_class.where(website: self, university: university).first_or_initialize
      next if page.persisted? # No resave
      next unless page.is_necessary_for_website? # No useless pages
      page.save_and_sync
    end
  end

  protected

  def find_special_page(type)
    # TODO L10N : To remove
    pages.tmp_original.where(type: type.to_s).first
  end

  def create_default_special_page(type)
    # Special pages have a before_validation (:on_create) callback to preset the original localization (title, slug, ...)
    page = pages.where(type: type.to_s, university_id: university_id).first_or_initialize
    page.save_and_sync
    page
  end

end
