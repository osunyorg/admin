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

  def reorder_pages(item_id:, previous_parent_id:, parent_id:, ids: [], language:)
    item = pages.find(item_id)
    # Bug prevention: prevent moving special pages into children
    if item.is_special_page? && parent_id != item.default_parent.id
      return false
    end

    Osuny::BulkOperation.silently do
      pages_by_id = pages.where(id: ids).index_by(&:id)
      ids.each.with_index do |id, index|
        page = pages_by_id[id]
        next if page.nil?
        page.update(parent_id: parent_id, position: index + 1)
      end
    end
    Communication::Website::CleanAfterPagesReorderJob.perform_later(id, {
      previous_parent_id: previous_parent_id,
      parent_id: parent_id,
      language: language
    })
    true
  end

  def clean_after_pages_reorder_safely(previous_parent_id, parent_id, language)
    parent = pages.find(parent_id)
    pages_to_touch = parent.descendants_and_self
    if previous_parent_id != parent_id
      previous_parent = pages.find(previous_parent_id)
      pages_to_touch += previous_parent.descendants_and_self 
    end
    pages_to_touch.uniq.each(&:touch)
    generate_automatic_menus_for_language(language)
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
