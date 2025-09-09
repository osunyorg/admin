module Communication::Website::WithPages
  extend ActiveSupport::Concern

  included do
    has_many    :pages,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :page_categories,
                class_name: "Communication::Website::Page::Category",
                foreign_key: :communication_website_id,
                dependent: :destroy

    after_save :create_missing_special_pages
    after_touch :create_missing_special_pages
  end

  def special_page(type)
    page = find_special_page(type)
    page ||= create_default_special_page(type)
    page
  end

  def create_missing_special_pages
    Communication::Website::Page::TYPES.each do |type|
      page = special_page(type)
      page.create_missing_localizations! if page
    end
  end

  protected

  def find_special_page(type)
    pages.where(type: type.to_s)
         .first
  end

  def create_default_special_page(type)
    # Special pages have a before_validation (:on_create) callback to preset the original localization (title, slug, ...)
    page = Communication::Website::Page.new(
      type: type.to_s,
      communication_website_id: id,
      university_id: university_id
    )
    # Ignore useless pages (not in this website)
    return unless page.should_create_special_page?
    page.save
    page
  end

end
