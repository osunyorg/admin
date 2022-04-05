# == Schema Information
#
# Table name: research_journals
#
#  id            :uuid             not null, primary key
#  access_token  :string
#  description   :text
#  issn          :string
#  repository    :string
#  title         :string
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
  include Aboutable
  include WithUniversity
  include WithGit

  has_many :websites, class_name: 'Communication::Website', as: :about, dependent: :nullify
  has_many :volumes, foreign_key: :research_journal_id, dependent: :destroy
  has_many :published_volumes, -> { published }, foreign_key: :research_journal_id, dependent: :destroy
  has_many :articles, foreign_key: :research_journal_id, dependent: :destroy
  has_many :published_articles, -> { published }, foreign_key: :research_journal_id, dependent: :destroy
  has_many :people, -> { distinct }, through: :articles
  has_many :people_through_published_articles, -> { distinct }, through: :published_articles

  scope :ordered, -> { order(:title) }

  def to_s
    "#{title}"
  end

  def researchers
    university.people.where(id: people_through_published_articles.pluck(:id), is_researcher: true)
  end

  def git_path(website)
    "data/journal.yml"
  end

  def git_dependencies(website)
    dependencies = [self]
    dependencies += published_articles + published_articles.map(&:active_storage_blobs).flatten if has_research_articles?
    dependencies += published_volumes + published_volumes.map(&:active_storage_blobs).flatten if has_research_volumes?
    dependencies += researchers + researchers.map(&:researcher) + researchers.map(&:active_storage_blobs).flatten if has_researchers?
    dependencies
  end

  def git_destroy_dependencies(website)
    [self] + articles + volumes
  end

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

  def has_research_articles?
    published_articles.published.any?
  end

  def has_research_volumes?
    published_volumes.published.any?
  end
end
