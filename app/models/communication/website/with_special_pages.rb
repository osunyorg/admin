module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_create :create_missing_special_pages
    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def special_page(type)
    pages.where(type: type.to_s).first
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |page_class|
      page = page_class.where(website: self, university: university).first_or_initialize # Special pages have an before_validation (:on_create) callback to preset title, slug, ...
      next if page.persisted? # No resave
      next unless page.is_necessary_for_website? # No useless pages
      page.save_and_sync
    end
  end
end
