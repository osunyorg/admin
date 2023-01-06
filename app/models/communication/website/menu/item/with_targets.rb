module Communication::Website::Menu::Item::WithTargets
  extend ActiveSupport::Concern

  protected

  def target_for_blank
    ''
  end

  def target_for_url
    url
  end

  # TODO should be replaced by permalink

  def target_for_page
    Static.clean_path about.path if about&.published
  end

  def target_for_programs
    Static.clean_path website.special_page(Communication::Website::Page::EducationProgram).path
  end

  def target_for_program
    Static.clean_path "#{website.special_page(Communication::Website::Page::EducationProgram).path}#{about.path}"
  end

  def target_for_diploma
    Static.clean_path "#{website.special_page(Communication::Website::Page::EducationDiploma).path}#{about.slug}"
  end

  def target_for_diplomas
    Static.clean_path website.special_page(Communication::Website::Page::EducationDiploma).path
  end

  def target_for_posts
    Static.clean_path website.special_page(Communication::Website::Page::CommunicationPost).path
  end

  def target_for_post
    return unless about&.published?
    Static.clean_path "#{website.special_page(Communication::Website::Page::CommunicationPost).path}#{about.path}"
  end

  def target_for_category
    return unless about
    Static.clean_path "#{website.special_page(Communication::Website::Page::CommunicationPost).path}#{about.path}"
  end

  def target_for_organizations
    Static.clean_path website.special_page(Communication::Website::Page::Organization).path
  end

  def target_for_persons
    Static.clean_path website.special_page(Communication::Website::Page::Person).path
  end

  def target_for_administrators
    Static.clean_path website.special_page(Communication::Website::Page::Administrator).path
  end

  def target_for_authors
    Static.clean_path website.special_page(Communication::Website::Page::Author).path
  end

  def target_for_researchers
    Static.clean_path website.special_page(Communication::Website::Page::Researcher).path
  end

  def target_for_teachers
    Static.clean_path website.special_page(Communication::Website::Page::Teacher).path
  end

  def target_for_volumes
    Static.clean_path website.special_page(Communication::Website::Page::ResearchVolume).path
  end

  def target_for_volume
    return unless about&.published && about&.published_at
    Static.clean_path "#{website.special_page(Communication::Website::Page::ResearchVolume).path}#{about.path}"
  end

  def target_for_papers
    Static.clean_path website.special_page(Communication::Website::Page::ResearchPaper).path
  end

  def target_for_paper
    return unless about&.published && about&.published_at
    Static.clean_path "#{website.special_page(Communication::Website::Page::ResearchPaper).path}#{about.path}"
  end
end
