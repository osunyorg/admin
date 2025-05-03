# == Schema Information
#
# Table name: communication_media_collection_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :text
#  featured_image_credit :text
#  name                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             not null, indexed
#  language_id           :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  idx_on_language_id_bb72607fc6                                   (language_id)
#  idx_on_university_id_8e25b8c926                                 (university_id)
#  index_communication_media_collection_localizations_on_about_id  (about_id)
#
# Foreign Keys
#
#  fk_rails_3ba8e7512d  (language_id => languages.id)
#  fk_rails_60122437f3  (university_id => universities.id)
#  fk_rails_90d53633e4  (about_id => communication_media_collections.id)
#
class Communication::Media::Collection::Localization < ApplicationRecord
  include AsIndirectObject
  include AsLocalization
  include Initials
  include WithFeaturedImage
  include WithUniversity

  def to_s
    "#{name}"
  end
end
