# == Schema Information
#
# Table name: research_journal_volumes
#
#  id                  :uuid             not null, primary key
#  description         :text
#  keywords            :text
#  number              :integer
#  published_at        :date
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  research_journal_id :uuid             not null
#  university_id       :uuid             not null
#
# Indexes
#
#  index_research_journal_volumes_on_research_journal_id  (research_journal_id)
#  index_research_journal_volumes_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_journal_id => research_journals.id)
#  fk_rails_...  (university_id => universities.id)
#
class Research::Journal::Volume < ApplicationRecord
  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  has_many :articles, foreign_key: :research_journal_volume_id

  after_commit :publish_to_github

  has_one_attached :cover

  scope :ordered, -> { order(number: :desc, published_at: :desc) }

  def cover_path
    "/assets/img/volumes/#{id}#{cover.filename.extension_with_delimiter}"
  end

  def to_s
    "##{ number } #{ title }"
  end

  protected

  def publish_to_github
    github.publish  kind: :volumes,
                    file: "#{id}.md",
                    title: title,
                    data: ApplicationController.render(
                      template: 'admin/research/journal/volumes/jekyll',
                      layout: false,
                      assigns: { volume: self }
                    )
    github.send_file cover, cover_path if cover.attached?
  end

  def github
    @github ||= Github.with_site(journal.website)
  end
end
