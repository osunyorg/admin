module Communication::Website::WithAssociatedObjects
  extend ActiveSupport::Concern

  included do
    has_many    :pages,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :page_categories,
                class_name: "Communication::Website::Page::Category",
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :permalinks,
                class_name: "Communication::Website::Permalink",
                dependent: :destroy

    has_many    :communication_blocks,
                class_name: "Communication::Block",
                foreign_key: :communication_website_id
    alias       :blocks :communication_blocks
  end

  def blocks_from_education
    Communication::Block.where(about: education_programs).or(
      Communication::Block.where(about: education_diplomas)
    )
  end

  def blocks_from_research
    Communication::Block.where(about: research_papers)
  end

  def blocks_from_university
    Communication::Block.where(about: connected_people).or(
      Communication::Block.where(about: connected_organizations)
    )
  end

  def education_schools
    has_education_schools? ? about.schools : Education::School.none
  end

  def education_diplomas
    has_education_diplomas? ? about.diplomas : Education::Diploma.none
  end

  def education_programs
    has_education_programs? ? about.programs : Education::Program.none
  end

  def administration_locations
    has_administration_locations? ? about.administration_locations : Administration::Location.none
  end

  def research_volumes
    has_research_volumes? ? about.volumes : Research::Journal::Volume.none
  end

  def research_papers
    has_research_papers? ? about.papers : Research::Journal::Paper.none
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

  def has_education_schools?
    about && about.has_education_schools?
  end

  def has_education_diplomas?
    about && about.has_education_diplomas?
  end

  def has_education_programs?
    about && about.has_education_programs?
  end

  def has_administration_locations?
    about && about.has_administration_locations?
  end

  def has_research_papers?
    about && about.has_research_papers?
  end

  def has_research_volumes?
    about && about.has_research_volumes?
  end

end
