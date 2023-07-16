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
    find_or_create_menu 'primary'
    find_or_create_menu 'social'
    find_or_create_menu 'legal'
    generate_automatic_menus
  end

  def generate_automatic_menus
    menus.automatic.find_each do |menu|
      menu.generate_automatically
    end
  end

  protected

  def find_or_create_menu(identifier)
    menu = menus.where(identifier: identifier, university: university, language: default_language).first_or_initialize do |menu|
      menu.title = I18n.t("communication.website.menus.default_title.#{identifier}")
    end
    menu.save unless menu.persisted?
  end
end
