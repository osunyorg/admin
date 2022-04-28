# == Schema Information
#
# Table name: research_laboratories
#
#  id            :uuid             not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  name          :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_laboratories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_f61d27545f  (university_id => universities.id)
#
class Research::Laboratory < ApplicationRecord
  include WithGit
  include Aboutable

  belongs_to  :university
  has_many    :websites,
              class_name: 'Communication::Website',
              as: :about,
              dependent: :nullify
  has_many    :axes,
              class_name: 'Research::Laboratory::Axis',
              foreign_key: :research_laboratory_id,
              dependent: :destroy

  validates :name, :address, :city, :zipcode, :country, presence: true

  scope :ordered, -> { order(:name) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(research_laboratories.address) ILIKE unaccent(:term) OR
      unaccent(research_laboratories.city) ILIKE unaccent(:term) OR
      unaccent(research_laboratories.country) ILIKE unaccent(:term) OR
      unaccent(research_laboratories.name) ILIKE unaccent(:term) OR
      unaccent(research_laboratories.zipcode) ILIKE unaccent(:term) 
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{name}"
  end

  def full_address
    [address, zipcode, city].compact.join ' '
  end

  def git_path(website)
    "data/laboratory.yml"
  end

  def has_administrators?
    false
  end

  def has_researchers?
    # TODO: Ajouter les researchers quand ils existeront
    false
  end

  def has_teachers?
    false
  end

  def has_education_programs?
    false
  end

  def has_research_articles?
    false
  end

  def has_research_volumes?
    false
  end
end
