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

  def menu_item_kind_diploma?
    has_education_diplomas?
  end

  def menu_item_kind_diplomas?
    has_education_diplomas?
  end

  def menu_item_kind_location?
    has_administration_locations?
  end

  def menu_item_kind_paper?
    has_research_papers?
  end

  def menu_item_kind_papers?
    has_research_papers?
  end

  def menu_item_kind_program?
    has_education_programs?
  end

  def menu_item_kind_programs?
    has_education_programs?
  end

  def menu_item_kind_volume?
    has_research_volumes?
  end

  def menu_item_kind_volumes?
    has_research_volumes?
  end

  def initialize_menus
    # As menu are duplicated in other languages whencreated we just have to create the menu in the default language
    create_default_menus(default_language)
  end

  def generate_automatic_menus(language)
    menus.automatic.for_language(language).find_each do |menu|
      menu.generate_automatically
    end
  end

  protected

  def create_default_menus(language)
    create_default_menu 'primary', language
    create_default_menu 'social', language
    create_default_menu 'legal', language
  end

  def create_default_menu(identifier, language)
    menus.where(
            university: university,
            identifier: identifier,
            language: language
          )
          .first_or_create do |menu|
      menu.title = Communication::Website::Menu.menu_title_from_locales(identifier, language)
    end
  end

end
