# == Schema Information
#
# Table name: communication_website_portfolio_categories
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  is_programs_root         :boolean          default(FALSE)
#  is_taxonomy              :boolean          default(FALSE)
#  position                 :integer          not null
#  position_in_tree         :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  parent_id                :uuid             indexed
#  program_id               :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_8f309901d4                      (communication_website_id)
#  idx_on_university_id_a07cc0a296                                 (university_id)
#  index_communication_website_portfolio_categories_on_parent_id   (parent_id)
#  index_communication_website_portfolio_categories_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_0f0db1988d  (communication_website_id => communication_websites.id)
#  fk_rails_35d652a63c  (parent_id => communication_website_portfolio_categories.id)
#  fk_rails_833ff43b27  (program_id => education_programs.id)
#  fk_rails_eed5f4b819  (university_id => universities.id)
#
class Communication::Website::Portfolio::Category < ApplicationRecord
  include AsCategory
  include AsDirectObject
  include GeneratesGitFiles
  include Localizable
  include Sanitizable
  include WithMenuItemTarget
  include WithUniversity

  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_and_belongs_to_many :projects
  alias                   :category_objects :projects

  def project_localizations
    Communication::Website::Portfolio::Project::Localization.where(about_id: project_ids)
  end

  def dependencies
    [parent] +
    localizations.in_languages(website.active_language_ids) +
    [website.config_default_content_security_policy]
  end

  def references
    projects +
    project_localizations +
    website.menus.in_languages(website.active_language_ids) +
    [parent]
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    website.portfolio_categories.where(parent_id: parent_id).ordered.last
  end
end
