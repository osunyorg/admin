# == Schema Information
#
# Table name: research_journal_articles
#
#  id                         :uuid             not null, primary key
#  abstract                   :text
#  keywords                   :text
#  old_text                   :text
#  published_at               :date
#  references                 :text
#  slug                       :string
#  title                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  research_journal_id        :uuid             not null
#  research_journal_volume_id :uuid
#  university_id              :uuid             not null
#  updated_by_id              :uuid
#
# Indexes
#
#  index_research_journal_articles_on_research_journal_id         (research_journal_id)
#  index_research_journal_articles_on_research_journal_volume_id  (research_journal_volume_id)
#  index_research_journal_articles_on_university_id               (university_id)
#  index_research_journal_articles_on_updated_by_id               (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_journal_id => research_journals.id)
#  fk_rails_...  (research_journal_volume_id => research_journal_volumes.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (updated_by_id => users.id)
#
class Research::Journal::Article < ApplicationRecord
  include WithGit

  has_rich_text :text
  has_one_attached :pdf

  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  belongs_to :volume, foreign_key: :research_journal_volume_id, optional: true
  belongs_to :updated_by, class_name: 'User'
  has_and_belongs_to_many :researchers,
                          class_name: 'University::Person',
                          join_table: :research_journal_articles_researchers,
                          association_foreign_key: :researcher_id
  has_many :websites, -> { distinct }, through: :journal

  validates :title, :published_at, presence: true

  scope :ordered, -> { order(:published_at, :created_at) }

  def pdf_path
    "/assets/articles/#{id}/#{pdf.filename}"
  end

  def git_path
    "content/articles/#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}.html" if published_at
  end

  def git_dependencies
    researchers
  end

  def to_s
    "#{ title }"
  end
end
