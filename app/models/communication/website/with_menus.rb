module Communication::Website::WithMenus
  extend ActiveSupport::Concern

  included do
    has_many    :menus,
                class_name: 'Communication::Website::Menu',
                foreign_key: :communication_website_id,
                dependent: :destroy

    after_create :initialize_menus
  end

  def menu_item_kinds
    Communication::Website::Menu::Item.kinds.reject do |key, value|
      active = send "menu_item_kind_#{key}?"
      !active
    end
  end

  def menu_item_kind_blank?
    true
  end

  def menu_item_kind_url?
    true
  end

  def menu_item_kind_page?
    pages.any?
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

  def menu_item_kind_posts?
    has_communication_posts?
  end

  def menu_item_kind_category?
    has_communication_categories?
  end

  def menu_item_kind_post?
    has_communication_posts?
  end

  def menu_item_kind_organizations?
    has_organizations?
  end

  def menu_item_kind_persons?
    has_persons?
  end

  def menu_item_kind_administrators?
    has_administrators?
  end

  def menu_item_kind_authors?
    has_authors?
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
    create_menu 'Primary'
    create_menu 'Legal'
    create_menu 'Social'
  end

  def create_menu(title)
    menus.create  title: title,
                  identifier: title.parameterize,
                  university: university
  end
end
