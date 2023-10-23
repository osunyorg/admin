# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  breadcrumb_title         :string
#  featured_image_alt       :string
#  featured_image_credit    :text
#  full_width               :boolean          default(FALSE)
#  header_text              :text
#  kind                     :integer
#  meta_description         :text
#  migration_identifier     :string
#  position                 :integer          default(0), not null
#  published                :boolean          default(FALSE)
#  slug                     :string           indexed
#  summary                  :text
#  text                     :text
#  title                    :string
#  type                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_language_id               (language_id)
#  index_communication_website_pages_on_original_id               (original_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_slug                      (slug)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1a42003f06  (parent_id => communication_website_pages.id)
#  fk_rails_280107c62b  (communication_website_id => communication_websites.id)
#  fk_rails_304f57360f  (original_id => communication_website_pages.id)
#  fk_rails_d208d15a73  (university_id => universities.id)
#
class Communication::Website::Page::Organization < Communication::Website::Page

  # TODO: Scope .where(language_id: language_id) when organizations are translatable
  def dependencies
    super +
    [website.config_default_languages] +
    website.connected_organizations
  end

  def explicitly_connected_organizations
    ids = website.connections.where(indirect_object_type: 'University::Organization', direct_source_type: 'Communication::Website::Page::Organization', direct_source_id: self.id).pluck(:indirect_object_id)
    University::Organization.where(id: ids)
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}organizations/_index.html"
  end

end
