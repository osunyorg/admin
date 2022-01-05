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
#  university_id :uuid             not null
#
# Indexes
#
#  index_research_journals_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Research::Journal < ApplicationRecord
  include WithGit

  belongs_to :university
  has_many :websites, class_name: 'Communication::Website', as: :about
  has_many :volumes, foreign_key: :research_journal_id, dependent: :destroy
  has_many :articles, foreign_key: :research_journal_id, dependent: :destroy
  has_many :researchers, through: :articles

  scope :ordered, -> { order(:title) }

  def to_s
    "#{title}"
  end

  def git_path_static
    "data/journal.yml"
  end

  def git_dependencies_static
    articles + volumes + researchers
  end

  def git_destroy_dependencies_static
    articles + volumes
  end
end
