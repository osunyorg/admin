# == Schema Information
#
# Table name: research_journal_articles
#
#  id                         :uuid             not null, primary key
#  published_at               :date
#  text                       :text
#  title                      :string
#  created_at                 :datetime         not null
#  updated_at                 :date             not null
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
  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  belongs_to :volume, foreign_key: :research_journal_volume_id, optional: true
  belongs_to :updated_by, class_name: 'User'
  has_and_belongs_to_many :researchers, class_name: 'Research::Researcher'

  after_save :publish_to_github

  def to_s
    "#{ title }"
  end

  protected

  def publish_to_github
    return if journal.website&.repository.blank?
    github = Github.new journal.website.access_token, journal.website.repository
    github.publish  kind: :articles,
                    file: "#{id}.md",
                    title: title,
                    data: ApplicationController.render(
                      template: 'admin/research/journal/articles/jekyll',
                      layout: false,
                      assigns: { article: self }
                    )
    researchers.each do |researcher|
      github.publish  kind: :researchers,
                      file: "#{ researcher.id }.md",
                      title: researcher.to_s,
                      data: ApplicationController.render(
                        template: 'admin/research/researchers/jekyll',
                        layout: false,
                        assigns: { researcher: researcher }
                      )
    end
  end
end
