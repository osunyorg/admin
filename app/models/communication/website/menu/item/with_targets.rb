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
    "/#{website.structure.education_programs_path}"
  end

  def target_for_program
    "/#{website.structure.education_programs_path}#{about.path}"
  end

  def target_for_news
    "/#{website.structure.communication_posts_path}"
  end

  def target_for_news_article
    "/#{website.structure.communication_posts_path}#{about.path}" if about&.published && about&.published_at
  end

  def target_for_news_category
    # TODO use communication_categories_path
    "/#{website.structure.communication_posts_path}/categories#{about.path}" if about
  end

  def target_for_staff
    "/#{website.structure.persons_path}"
  end

  def target_for_administrators
    "/#{website.structure.administrators_path}"
  end

  def target_for_authors
    "/#{website.structure.authors_path}"
  end

  def target_for_researchers
    "/#{website.structure.researchers_path}"
  end

  def target_for_teachers
    "/#{website.structure.teachers_path}"
  end

  def target_for_research_volumes
    "/#{website.structure.research_volumes_path}"
  end

  def target_for_research_volume
    "/#{website.structure.research_volumes_path}#{about.path}" if about&.published && about&.published_at
  end

  def target_for_research_articles
    "/#{website.structure.research_articles_path}"
  end

  def target_for_research_article
    "/#{website.structure.research_articles_path}#{about.path}" if about&.published && about&.published_at
  end
end
