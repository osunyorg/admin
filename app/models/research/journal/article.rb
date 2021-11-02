# == Schema Information
#
# Table name: research_journal_articles
#
#  id                         :uuid             not null, primary key
#  abstract                   :text
#  github_path                :text
#  keywords                   :text
#  published_at               :date
#  references                 :text
#  text                       :text
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
  include WithGithub

  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  belongs_to :volume, foreign_key: :research_journal_volume_id, optional: true
  belongs_to :updated_by, class_name: 'User'
  has_and_belongs_to_many :researchers, class_name: 'Research::Researcher'

  validates :title, :published_at, presence: true
  after_commit :update_researchers

  has_one_attached :pdf

  scope :ordered, -> { order(:published_at, :created_at) }

  def pdf_path
    "/assets/articles/#{id}/#{pdf.filename}"
  end

  def website
    journal.website
  end

  def to_s
    "#{ title }"
  end

  protected

  def github_path_generated
    "_articles/#{id}.html"
  end

  def to_jekyll
    ApplicationController.render(
      template: 'admin/research/journal/articles/jekyll',
      layout: false,
      assigns: { article: self }
    )
  end

  def update_researchers
    researchers.each do |researcher|
      researcher.publish_to_website(journal.website)
    end
  end
end
