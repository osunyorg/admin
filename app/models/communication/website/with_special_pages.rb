module Communication::Website::WithSpecialPages
  extend ActiveSupport::Concern

  included do
    after_create :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def create_missing_special_pages
    home = nil
    special_pages = Communication::Website::Page::TYPES.each do |page_class|
      page = create_special_page page_class, home
      home = page if home.nil?
    end
  end

  protected

  def create_special_page(page_class, parent)
    page = page_class.where(website: self, university: university).first_or_initialize
    if page.new_record?
      i18n_key = "communication.website.pages.defaults.#{page.type_key}"
      page.title = I18n.t("#{i18n_key}.title")
      page.slug = I18n.t("#{i18n_key}.slug")
      page.parent = parent
      page.full_width = page.full_width_by_default?
      page.published = page.published_by_default?
      page.save_and_sync if page.is_necessary_for_website?
    end
    page
  end
end
