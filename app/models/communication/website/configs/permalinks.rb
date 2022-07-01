# == Schema Information
#
# Table name: communication_websites
#
#  id               :uuid             not null, primary key
#  about_type       :string           indexed => [about_id]
#  access_token     :string
#  git_endpoint     :string
#  git_provider     :integer          default("github")
#  name             :string
#  plausible_url    :string
#  repository       :string
#  style            :text
#  style_updated_at :date
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             indexed => [about_type]
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about          (about_type,about_id)
#  index_communication_websites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website::Configs::Permalinks < Communication::Website

  def self.polymorphic_name
    'Communication::Website::Configs::Permalinks'
  end

  def git_path(website)
    "config/_default/permalinks.yaml"
  end

  def template_static
    "admin/communication/websites/configs/permalinks/static"
  end

end
