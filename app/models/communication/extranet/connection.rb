# == Schema Information
#
# Table name: communication_extranet_connections
#
#  id            :uuid             not null, primary key
#  about_type    :string           indexed => [about_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed => [about_type]
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_connections_on_extranet_id    (extranet_id)
#  index_communication_extranet_connections_on_object         (about_type,about_id)
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
  belongs_to :about, polymorphic: true

  def self.permitted_about_types
    ["University::Organization", "University::Person"]
  end
end
