# == Schema Information
#
# Table name: communication_website_git_file_layouts
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
#  idx_on_communication_website_id_eb9ee4bc34                     (communication_website_id)
#  index_communication_website_git_file_layouts_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_03fd688528  (communication_website_id => communication_websites.id)
#  fk_rails_af843490b0  (university_id => universities.id)
#
class Communication::Website::GitFile::Layout < ApplicationRecord
  include WithUniversity

  belongs_to  :website, 
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  scope :ordered, -> { order(:path) }

  def self.overrides
    pluck(:path).compact.uniq.sort
  end

  def self.count_websites(override)
    where(path: override).count
  end

  def git_url
    "#{website.git_repository.url}/blob/main/#{path}"
  end
end
