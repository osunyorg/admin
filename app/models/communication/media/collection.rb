# == Schema Information
#
# Table name: communication_media_collections
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_media_collections_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_d927f11355  (university_id => universities.id)
#
class Communication::Media::Collection < ApplicationRecord
  include Localizable
  include LocalizableOrderByNameScope
  include WithUniversity

  has_many  :medias,
            class_name: 'Communication::Media',
            foreign_key: :communication_media_collection_id
end
