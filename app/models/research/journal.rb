# == Schema Information
#
# Table name: research_journals
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_journals_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_96097d5f10  (university_id => universities.id)
#
class Research::Journal < ApplicationRecord
  include AsIndirectObject
  include Favoritable
  include Filterable
  include GeneratesGitFiles
  include Localizable
  include LocalizableOrderByTitleScope
  include Sanitizable
  include Searchable
  include WebsitesLinkable
  include WithUniversity

  has_many  :communication_websites,
            class_name: 'Communication::Website',
            as: :about,
            dependent: :nullify
  has_many  :volumes,
            foreign_key: :research_journal_id,
            dependent: :destroy
  has_many  :papers,
            foreign_key: :research_journal_id,
            dependent: :destroy
  has_many  :people,
            -> { distinct },
            through: :papers
  has_many  :paper_kinds,
            class_name: 'Research::Journal::Paper::Kind',
            dependent: :destroy

  scope :for_search_term, -> (term, language = nil) {
    joins(:localizations)
      .where(research_journal_localizations: { language_id: language.id })
      .where("
        unaccent(research_journal_localizations.meta_description) ILIKE unaccent(:term) OR
        unaccent(research_journal_localizations.issn) ILIKE unaccent(:term) OR
        unaccent(research_journal_localizations.title) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }

  def researchers
    university.people.where(id: people.pluck(:id), is_researcher: true)
  end

  def dependencies
    localizations +
    volumes +
    papers +
    researchers.map(&:researcher_facets)
  end

  #####################
  # WebsitesLinkable methods #
  #####################
  def has_administrators?
    false
  end

  def has_researchers?
    researchers.any?
  end

  def has_teachers?
    false
  end

  def has_education_programs?
    false
  end

  def has_education_diplomas?
    false
  end

  def has_administration_locations?
    false
  end

  def has_research_papers?
    papers.any?
  end

  def has_research_volumes?
    volumes.any?
  end
end
