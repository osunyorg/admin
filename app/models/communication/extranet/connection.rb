# == Schema Information
#
# Table name: communication_extranet_connections
#
#  id            :uuid             not null, primary key
#  object_type   :string           indexed => [object_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  object_id     :uuid             indexed => [object_type]
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_connections_on_extranet_id    (extranet_id)
#  index_communication_extranet_connections_on_object         (object_type,object_id)
#  index_communication_extranet_connections_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_14a6af7258  (university_id => universities.id)
#  fk_rails_cfa28a3d00  (extranet_id => communication_extranets.id)
#
class Communication::Extranet::Connection < ApplicationRecord
  belongs_to :university
  belongs_to :extranet, class_name: 'Communication::Extranet'
  belongs_to :object, polymorphic: true
end
