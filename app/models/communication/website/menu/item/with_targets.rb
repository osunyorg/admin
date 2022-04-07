module Communication::Website::Menu::Item::WithTargets
  extend ActiveSupport::Concern

  protected

  def target_for_blank
    ''
  end

  def target_for_url
    url
  end

  def target_for_page
    about.path if about&.published
  end

  def target_for_programs
    "#{website.special_page(:education_programs).path}"
  end

  def target_for_program
    "#{website.special_page(:education_programs).path}#{about.path}"
  end

  def target_for_news
    "#{website.special_page(:communication_posts).path}"
  end

  def target_for_news_article
    "#{website.special_page(:communication_posts).path}#{about.path}" if about&.published && about&.published_at
  end

  def target_for_news_category
    "#{website.special_page(:communication_posts).path}#{about.path}" if about
  end

  def target_for_staff
    "#{website.special_page(:people).path}"
  end

  def target_for_administrators
    "#{website.special_page(:administrators).path}"
  end

  def target_for_authors
    "#{website.special_page(:authors).path}"
  end

  def target_for_researchers
    "#{website.special_page(:researchers).path}"
  end

  def target_for_teachers
    "#{website.special_page(:teachers).path}"
  end

  def target_for_research_volumes
    "#{website.special_page(:research_volumes).path}"
  end

  def target_for_research_volume
    "#{website.special_page(:research_volumes).path}#{about.path}" if about&.published && about&.published_at
  end

  def target_for_research_articles
    "#{website.special_page(:research_articles).path}"
  end

  def target_for_research_article
    "#{website.special_page(:research_articles).path}#{about.path}" if about&.published && about&.published_at
  end
end
