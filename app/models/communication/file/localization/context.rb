# == Schema Information
#
# Table name: communication_file_contexts
#
#  id                                 :uuid             not null, primary key
#  about_type                         :string           indexed => [about_id]
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  about_id                           :uuid             indexed => [about_type]
#  communication_file_localization_id :uuid             not null, indexed
#  university_id                      :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_file_localization_id_a9a8fdc48e  (communication_file_localization_id)
#  index_communication_file_contexts_on_about            (about_type,about_id)
#  index_communication_file_contexts_on_university_id    (university_id)
#
# Foreign Keys
#
#  fk_rails_6a6962a587  (university_id => universities.id)
#  fk_rails_fe2e82d401  (communication_file_localization_id => communication_file_localizations.id)
#
class Communication::File::Localization::Context < ApplicationRecord
  include WithUniversity

  belongs_to  :communication_file_localization,
              class_name: 'Communication::File::Localization'
  alias       :file_localization :communication_file_localization
 
  belongs_to :about, polymorphic: true
end
