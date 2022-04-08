module Communication::Website::WithMenuItems
  extend ActiveSupport::Concern

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

  def menu_item_kind_news?
    has_communication_posts?
  end

  def menu_item_kind_news_category?
    has_communication_categories?
  end

  def menu_item_kind_news_article?
    has_communication_posts?
  end

  def menu_item_kind_staff?
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

  def menu_item_kind_research_volumes?
    has_research_volumes?
  end

  def menu_item_kind_research_volume?
    has_research_volumes?
  end

  def menu_item_kind_research_articles?
    has_research_articles?
  end

  def menu_item_kind_research_article?
    has_research_articles?
  end
end
