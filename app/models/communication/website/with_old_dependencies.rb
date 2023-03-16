module Communication::Website::WithOldDependencies
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
    about&.administrators
  end

  def researchers
    about&.researchers
  end

  def teachers
    about&.teachers
  end

  def people_in_blocks
    @people_in_blocks ||= blocks_dependencies.reject { |dependency| !dependency.is_a? University::Person }
  end

  def organizations
    organizations_in_blocks
  end

  def organizations_in_blocks
    @organizations_in_blocks ||= blocks_dependencies.reject { |dependency| !dependency.is_a? University::Organization }
  end

  def people_with_facets_in_blocks
    @people_with_facets_in_blocks ||= blocks_dependencies.reject { |dependency| !dependency.class.to_s.start_with?('University::Person') }
  end

  def people
    # TODO: Scoper aux langues du website dans le cas où une personne serait traduite dans + de langues
    @people ||= begin
      people = []
      people += authors if has_authors?
      people += teachers if has_teachers?
      people += administrators if has_administrators?
      people += researchers if has_researchers?
      people += people_in_blocks if has_people_in_blocks?
      people.uniq.compact
    end
  end

  def people_with_facets
    # TODO: Scoper aux langues du website dans le cas où une personne serait traduite dans + de langues
    @people_with_facets ||= begin
      people_with_facets = people
      people_with_facets += authors.compact.map(&:author) if has_authors?
      people_with_facets += teachers.compact.map(&:teacher) if has_teachers?
      people_with_facets += administrators.compact.map(&:administrator) if has_administrators?
      people_with_facets += researchers.compact.map(&:researcher) if has_researchers?
      people_with_facets += people_with_facets_in_blocks if has_people_in_blocks?
      people_with_facets.uniq.compact
    end
  end

  # Deprecated, needs refactor for performance

  def has_communication_posts?
    posts.published.any?
  end

  def has_communication_categories?
    categories.any?
  end

  def has_organizations?
    has_organizations_in_blocks?
  end

  def has_authors?
    authors.compact.any?
  end

  def has_people_in_blocks?
    people_in_blocks.compact.any?
  end

  def has_organizations_in_blocks?
    organizations_in_blocks.compact.any?
  end

  def has_persons?
    has_authors? || has_administrators? || has_researchers? || has_teachers? || has_people_in_blocks?
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
