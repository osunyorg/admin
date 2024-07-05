# == Schema Information
#
# Table name: communication_website_post_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  meta_description      :text
#  migration_identifier  :string
#  pinned                :boolean
#  published             :boolean
#  published_at          :datetime
#  slug                  :string
#  summary               :text
#  text                  :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_university_id_a3a3f1e954                                (university_id)
#  index_communication_website_post_localizations_on_about_id     (about_id)
#  index_communication_website_post_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_20680ef99a  (language_id => languages.id)
#  fk_rails_b4db91ebe4  (about_id => communication_website_posts.id)
#  fk_rails_db7d7c515c  (university_id => universities.id)
#
class Communication::Website::Post::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include Sluggable
  include WithBlobs
  include WithGitFiles
  include WithUniversity

  has_summernote :text

  def to_s
    "#{title}"
  end
end
