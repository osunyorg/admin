# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  description              :text
#  old_text                 :text
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

  has_rich_text :text

  belongs_to :university
  belongs_to :website,
             foreign_key: :communication_website_id
  has_one    :imported_post,
             class_name: 'Communication::Website::Imported::Post',
             foreign_key: :post_id,
             dependent: :destroy

  scope :ordered, -> { order(published_at: :desc, created_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(5) }

  validates :title, presence: true

  def to_s
    "#{title}"
  end
end
