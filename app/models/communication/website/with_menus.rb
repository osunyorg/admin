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

  def initialize_menus
    # default_language menu has to be created first, to be a reference for other languages
    find_or_create_menus_for_language(default_language)
    languages_except_default.each do |language|
      find_or_create_menus_for_language(language)
    end
    languages.each do |language|
      generate_automatic_menus(language)
    end
  end

  def generate_automatic_menus(language)
    menus.automatic.for_language(language).find_each do |menu|
      menu.generate_automatically
    end
  end

  protected

  def find_or_create_menus_for_language(language)
    find_or_create_menu 'primary', language
    find_or_create_menu 'social', language
    find_or_create_menu 'legal', language
  end

  def find_or_create_menu(identifier, language)
    menu = menus_for_language(identifier, language).first_or_initialize do |menu|
      menu.title = I18n.t("communication.website.menus.default_title.#{identifier}", locale: language.iso_code)
      menu.original_id = original_menu(identifier).id if language.id != default_language_id
    end
    menu.save unless menu.persisted?
  end

  def menus_for_language(identifier, language)
    # university is needed for the initialize part
    menus.where(university: university, identifier: identifier, language: language)
  end

  def original_menu(identifier)
    menus_for_language(identifier, default_language).first
  end

end
