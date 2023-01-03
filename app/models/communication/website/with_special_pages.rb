module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_create :create_missing_special_pages
    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def home_page
    pages.home.first
  end

  def persons_page
    pages.persons.first
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |page_class|
      page = page_class.where(website: self, university: university).first_or_initialize
      next if page.persisted? # No resave
      next unless page.is_necessary_for_website? # No useless pages
      page.save_and_sync
    end
  end
end
