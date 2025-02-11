# == Schema Information
#
# Table name: communication_website_agenda_exhibitions
#
#  id                       :uuid             not null, primary key
#  from_day                 :date
#  migration_identifier     :string
#  time_zone                :string
#  to_day                   :date
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  created_by_id            :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_created_by_id_c3766f3a0a                       (created_by_id)
#  idx_on_university_id_46e895f493                       (university_id)
#  index_agenda_exhibitions_on_communication_website_id  (communication_website_id)
#
# Foreign Keys
#
#  fk_rails_28f367ca06  (created_by_id => users.id)
#  fk_rails_29241f0afb  (university_id => universities.id)
#  fk_rails_4c477c4153  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Exhibition < ApplicationRecord
  include AsDirectObject
  include Duplicable
  include Filterable
  include Categorizable # Must be loaded after Filterable to be filtered by categories
  include Sanitizable
  include Searchable
  include Localizable
  include WithMenuItemTarget
  include WithOpenApi
  # include WithTime
  include WithUniversity

  belongs_to  :created_by,
              class_name: "User",
              optional: true

end
