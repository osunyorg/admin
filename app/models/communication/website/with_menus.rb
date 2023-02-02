module Communication::Website::WithMenus
  extend ActiveSupport::Concern

  included do
    has_many    :menus,
                class_name: 'Communication::Website::Menu',
                foreign_key: :communication_website_id,
                dependent: :destroy

    after_save :initialize_menus
  end

  def menu_item_kinds
    Communication::Website::Menu::Item.kinds.reject do |key, value|
      method_name = "menu_item_kind_#{key}?"
      respond_to?(method_name) && !public_send(method_name)
    end
  end

  def menu_item_kind_programs?
    has_education_programs?
  end

  def menu_item_kind_program?
    has_education_programs?
  end

  def menu_item_kind_diploma?
    has_education_diplomas?
  end

  def menu_item_kind_diplomas?
    has_education_diplomas?
  end

  def menu_item_kind_administrators?
    has_administrators?
  end

  def menu_item_kind_researchers?
    has_researchers?
  end

  def menu_item_kind_teachers?
    has_teachers?
  end

  def menu_item_kind_volumes?
    has_research_volumes?
  end

  def menu_item_kind_volume?
    has_research_volumes?
  end

  def menu_item_kind_papers?
    has_research_papers?
  end

  def menu_item_kind_paper?
    has_research_papers?
  end

  protected

  def initialize_menus
    find_or_create_menu 'primary'
    find_or_create_menu 'social'
    menu = find_or_create_menu 'legal'
    fill_legal_menu menu
  end

  def fill_legal_menu(menu)
    return if menu.items.any?
    [
      Communication::Website::Page::LegalTerm,
      Communication::Website::Page::PrivacyPolicy,
      Communication::Website::Page::Accessibility,
      Communication::Website::Page::Sitemap
    ].each do |page_class|
      page = special_page(page_class)
      menu.items.where( kind: 'page', 
                        about: page,
                        university: university,
                        website: self)
                .first_or_create do |item|
        item.title = page.title
      end
    end
  end

  def find_or_create_menu(identifier)
    title = Communication::Website::Menu.human_attribute_name(identifier)
    menus.where(identifier: identifier, university: university).first_or_create do |menu|
      menu.title = title
    end
  end
end
