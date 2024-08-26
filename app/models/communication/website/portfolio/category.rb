# == Schema Information
#
# Table name: communication_website_portfolio_categories
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  is_programs_root         :boolean          default(FALSE)
#  is_taxonomy              :boolean          default(FALSE)
#  meta_description         :text
#  name                     :string
#  path                     :string
#  position                 :integer
#  slug                     :string
#  summary                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  program_id               :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_8f309901d4                      (communication_website_id)
#  idx_on_language_id_6e6ffc92a8                                   (language_id)
#  idx_on_original_id_4cbc9f1290                                   (original_id)
#  idx_on_university_id_a07cc0a296                                 (university_id)
#  index_communication_website_portfolio_categories_on_parent_id   (parent_id)
#  index_communication_website_portfolio_categories_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_0f0db1988d  (communication_website_id => communication_websites.id)
#  fk_rails_35d652a63c  (parent_id => communication_website_portfolio_categories.id)
#  fk_rails_833ff43b27  (program_id => education_programs.id)
#  fk_rails_c82d8a59f0  (language_id => languages.id)
#  fk_rails_d21380c33e  (original_id => communication_website_portfolio_categories.id)
#  fk_rails_eed5f4b819  (university_id => universities.id)
#
class Communication::Website::Portfolio::Category < ApplicationRecord
  include AsCategory
  include AsDirectObject
  include Contentful # TODO L10N : To remove
  include Sanitizable
  include Localizable
  include WithBlobs # TODO L10N : To remove
  include WithFeaturedImage # TODO L10N : To remove
  include WithMenuItemTarget
  include WithUniversity

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_and_belongs_to_many :projects,
                          class_name: 'Communication::Website::Portfolio::Project',
                          join_table: :communication_website_portfolio_categories_projects,
                          foreign_key: :communication_website_portfolio_category_id,
                          association_foreign_key: :communication_website_portfolio_project_id

  def project_localizations
    Communication::Website::Portfolio::Project::Localization.where(about_id: project_ids)
  end

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids)
  end

  def references
    projects +
    project_localizations +
    website.menus.in_languages(website.active_language_ids) +
    [parent]
  end

  protected

  def last_ordered_element
    website.portfolio_categories.where(parent_id: parent_id, language_id: language_id).ordered.last
  end
end
