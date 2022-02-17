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
    "/#{website.index_for(:education_programs).path}"
  end

  def target_for_program
    "/#{website.index_for(:education_programs).path}#{about.path}"
  end

  def target_for_news
    "/#{website.index_for(:communication_posts).path}"
  end

  def target_for_news_article
    "/#{website.index_for(:communication_posts).path}#{about.path}" if about&.published && about&.published_at
  end

  def target_for_news_category
    "/#{website.index_for(:communication_posts).path}#{about.path}" if about
  end

  def target_for_staff
    "/#{website.index_for(:persons).path}"
  end

  def target_for_administrators
    "/#{website.index_for(:administrators).path}"
  end

  def target_for_authors
    "/#{website.index_for(:authors).path}"
  end

  def target_for_researchers
    "/#{website.index_for(:researchers).path}"
  end

  def target_for_teachers
    "/#{website.index_for(:teachers).path}"
  end

  def target_for_research_volumes
    "/#{website.index_for(:research_volumes).path}"
  end

  def target_for_research_volume
    "/#{website.index_for(:research_volumes).path}#{about.path}" if about&.published && about&.published_at
  end

  def target_for_research_articles
    "/#{website.index_for(:research_articles).path}"
  end

  def target_for_research_article
    "/#{website.index_for(:research_articles).path}#{about.path}" if about&.published && about&.published_at
  end
end
