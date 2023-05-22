module Communication::Website::WithAssociatedObjects
  extend ActiveSupport::Concern

  included do

    has_many    :pages,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :posts,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :authors, -> { distinct }, through: :posts

    has_many    :categories,
                class_name: 'Communication::Website::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :permalinks,
                class_name: "Communication::Website::Permalink",
                dependent: :destroy

  end

  def education_diplomas
    has_education_diplomas? ? about.diplomas : Education::Diploma.none
  end

  def education_programs
    has_education_programs? ? about.published_programs : Education::Program.none
  end

  def research_volumes
    has_research_volumes? ? about.published_volumes : Research::Journal::Volume.none
  end

  def research_papers
    has_research_papers? ? about.published_papers : Research::Journal::Paper.none
  end

  def administrators
    has_administrators? ? about.administrators : University::Person.none
  end

  def researchers
    has_researchers? ? about.researchers : University::Person.none
  end

  def teachers
    has_teachers? ? about.teachers : University::Person.none
  end

  def has_communication_posts?
    posts.published.any?
  end

  def has_communication_categories?
    categories.any?
  end

  def has_organizations?
    connected_organizations.any?
  end

  def has_authors?
    authors.compact.any?
  end

  def has_persons?
    connected_people.any?
  end

  def has_administrators?
    about && about.has_administrators?
  end

  def has_researchers?
    about && about.has_researchers?
  end

  def has_teachers?
    about && about.has_teachers?
  end

  def has_education_diplomas?
    about && about.has_education_diplomas?
  end

  def has_education_programs?
    about && about.has_education_programs?
  end

  def has_research_papers?
    about && about.has_research_papers?
  end

  def has_research_volumes?
    about && about.has_research_volumes?
  end

end
