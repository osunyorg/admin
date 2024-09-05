# == Schema Information
#
# Table name: communication_extranet_post_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  pinned                :boolean          default(FALSE)
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string
#  summary               :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  extranet_id           :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_university_id_28188e2217                                 (university_id)
#  index_communication_extranet_post_localizations_on_about_id     (about_id)
#  index_communication_extranet_post_localizations_on_extranet_id  (extranet_id)
#  index_communication_extranet_post_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_17187381a3  (extranet_id => communication_extranets.id)
#  fk_rails_3d930f21f1  (about_id => communication_extranet_posts.id)
#  fk_rails_5753a1409d  (university_id => universities.id)
#  fk_rails_587ccae541  (language_id => languages.id)
#
class Communication::Extranet::Post::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Sanitizable
  include Sluggable
  include WithAccessibility
  include WithFeaturedImage
  include WithPublication
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'

  validates_presence_of :title

  before_validation :set_extranet_id

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(extranet_id: self.extranet_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_extranet_id
    self.extranet_id ||= about.extranet_id
  end
end
