# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  description              :text
#  github_path              :text
#  old_text                 :text
#  path                     :text
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null
#  university_id            :uuid             not null
#
# Indexes
#
#  index_communication_website_posts_on_communication_website_id  (communication_website_id)
#  index_communication_website_posts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website::Post < ApplicationRecord
  include WithSlug
  include WithGithub

  has_rich_text :text
  has_one_attached_deletable :featured_image

  belongs_to :university
  belongs_to :website,
             foreign_key: :communication_website_id

  scope :ordered, -> { order(published_at: :desc, created_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(5) }

  validates :title, presence: true

  def github_path_generated
    "_posts/#{published_at.strftime "%Y/%m"}/#{published_at.strftime "%Y-%m-%d"}-#{slug}.html"
  end

  def to_jekyll
    ApplicationController.render(
      template: 'admin/communication/website/posts/jekyll',
      layout: false,
      assigns: { post: self }
    )
  end

  def to_s
    "#{title}"
  end
end
