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
    about_school? && programs.any?
  end

  def menu_item_kind_program?
    about_school? && programs.any?
  end

  def menu_item_kind_news?
    posts.published.any?
  end

  def menu_item_kind_news_category?
    categories.any?
  end

  def menu_item_kind_news_article?
    menu_item_kind_news?
  end

  def menu_item_kind_staff?
    true
  end

  def menu_item_kind_administrators?
    people.any?
  end

  def menu_item_kind_authors?
    authors.compact.any?
  end

  def menu_item_kind_researchers?
    about_journal? && about.people.any?
  end

  def menu_item_kind_teachers?
    about_school? && about.university_people_through_program_involvements.any?
  end

  def menu_item_kind_research_volumes?
    research_volumes.published.any?
  end

  def menu_item_kind_research_volume?
    menu_item_kind_research_volumes?
  end

  def menu_item_kind_research_articles?
    research_articles.published.any?
  end

  def menu_item_kind_research_article?
    menu_item_kind_research_articles?
  end
end
