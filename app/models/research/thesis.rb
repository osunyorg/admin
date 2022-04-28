# == Schema Information
#
# Table name: research_theses
#
#  id                     :uuid             not null, primary key
#  abstract               :text
#  completed              :boolean          default(FALSE)
#  completed_at           :date
#  started_at             :date
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  author_id              :uuid             not null, indexed
#  director_id            :uuid             not null, indexed
#  research_laboratory_id :uuid             not null, indexed
#  university_id          :uuid             not null, indexed
#
# Indexes
#
#  index_research_theses_on_author_id               (author_id)
#  index_research_theses_on_director_id             (director_id)
#  index_research_theses_on_research_laboratory_id  (research_laboratory_id)
#  index_research_theses_on_university_id           (university_id)
#
# Foreign Keys
#
#  fk_rails_1e42972d90  (author_id => university_people.id)
#  fk_rails_44b431f9e5  (university_id => universities.id)
#  fk_rails_8d223fdbaf  (director_id => university_people.id)
#  fk_rails_b3380066dc  (research_laboratory_id => research_laboratories.id)
#
class Research::Thesis < ApplicationRecord
  include Sanitizable
  include WithUniversity

  belongs_to :laboratory, foreign_key: :research_laboratory_id
  belongs_to :author, class_name: 'University::Person'
  belongs_to :director, class_name: 'University::Person'

  scope :ordered, -> { order(:title) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(research_theses.abstract) ILIKE unaccent(:term) OR
      unaccent(research_theses.title) ILIKE unaccent(:term) 
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{title}"
  end
end
