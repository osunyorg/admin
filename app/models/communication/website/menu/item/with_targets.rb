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
    Static.clean_path about.path if about&.published
  end

  def target_for_programs
    Static.clean_path website.special_page(:education_programs).path
  end

  def target_for_program
    Static.clean_path "#{website.special_page(:education_programs).path}#{about.path}"
  end

  def target_for_diploma
    Static.clean_path "#{website.special_page(:education_diplomas).path}#{about.slug}"
  end

  def target_for_diplomas
    Static.clean_path website.special_page(:education_diplomas).path
  end

  def target_for_posts
    Static.clean_path website.special_page(:communication_posts).path
  end

  def target_for_post
    return unless about&.published?
    Static.clean_path "#{website.special_page(:communication_posts).path}#{about.path}"
  end

  def target_for_category
    return unless about
    Static.clean_path "#{website.special_page(:communication_posts).path}#{about.path}"
  end

  def target_for_organizations
    Static.clean_path website.special_page(:organizations).path
  end

  def target_for_persons
    Static.clean_path website.special_page(:persons).path
  end

  def target_for_administrators
    Static.clean_path website.special_page(:administrators).path
  end

  def target_for_authors
    Static.clean_path website.special_page(:authors).path
  end

  def target_for_researchers
    Static.clean_path website.special_page(:researchers).path
  end

  def target_for_teachers
    Static.clean_path website.special_page(:teachers).path
  end

  def target_for_volumes
    Static.clean_path website.special_page(:research_volumes).path
  end

  def target_for_volume
    return unless about&.published && about&.published_at
    Static.clean_path "#{website.special_page(:research_volumes).path}#{about.path}"
  end

  def target_for_papers
    Static.clean_path website.special_page(:research_papers).path
  end

  def target_for_paper
    return unless about&.published && about&.published_at
    Static.clean_path "#{website.special_page(:research_papers).path}#{about.path}"
  end
end
