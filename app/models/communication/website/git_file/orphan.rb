# == Schema Information
#
# Table name: communication_website_git_file_orphans
#
#  id                       :uuid             not null, primary key
#  path                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_18bd864000                     (communication_website_id)
#  index_communication_website_git_file_orphans_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_743becf187  (university_id => universities.id)
#  fk_rails_e6c7b67766  (communication_website_id => communication_websites.id)
#
class Communication::Website::GitFile::Orphan < ApplicationRecord
  include WithUniversity

  belongs_to  :website, 
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  scope :ordered, -> (language = nil) { order(:path) }

  def git_url
    "#{website.git_repository.url}/blob/main/#{path}"
  end
end
