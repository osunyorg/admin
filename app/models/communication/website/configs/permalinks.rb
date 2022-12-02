# == Schema Information
#
# Table name: communication_websites
#
#  id               :uuid             not null, primary key
#  about_type       :string           indexed => [about_id]
#  access_token     :string
#  git_branch       :string
#  git_endpoint     :string
#  git_provider     :integer          default("github")
#  in_production    :boolean          default(FALSE)
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

  def permalinks_data
    @permalinks_data ||= begin
      data = {}
      data[:posts] = "#{self.special_page(:communication_posts).path_without_language}:year/:month/:day/:slug/" if has_communication_posts?
      data[:categories] = "#{self.special_page(:communication_posts).path_without_language}:slug/" if has_communication_posts? && has_communication_categories?
      data[:persons] = "#{self.special_page(:persons).path_without_language}:slug/" if has_persons?
      data[:organizations] = "#{self.special_page(:organizations).path_without_language}:slug/" if has_organizations?
      # website might have authors but no communication_posts (if a post unpublished exists)
      data[:authors] = "#{self.special_page(:persons).path_without_language}:slug/#{self.special_page(:communication_posts).slug}/" if has_authors? && has_communication_posts?
      data[:diplomas] = "#{self.special_page(:education_diplomas).path_without_language}:slug/" if has_education_diplomas?
      # ces paths complémentaires sont nécessaires à Hugo mais on ne les utilise pas
      data[:administrators] = "#{self.special_page(:persons).path_without_language}:slug/roles/" if has_administrators?
      data[:teachers] = "#{self.special_page(:persons).path_without_language}:slug/programs/" if has_teachers?
      data[:researchers] = "#{self.special_page(:persons).path_without_language}:slug/papers/" if has_researchers?
      data
    end
  end

end
