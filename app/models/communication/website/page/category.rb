# == Schema Information
#
# Table name: communication_website_page_categories
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  is_programs_root         :boolean          default(FALSE)
#  is_taxonomy              :boolean          default(FALSE)
#  migration_identifier     :string
#  position                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  parent_id                :uuid             indexed
#  program_id               :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_communication_website_page_cats_on_website_id             (communication_website_id)
#  index_communication_website_page_categories_on_parent_id      (parent_id)
#  index_communication_website_page_categories_on_program_id     (program_id)
#  index_communication_website_page_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_4db801fbd9  (parent_id => communication_website_page_categories.id)
#  fk_rails_62d9544f35  (university_id => universities.id)
#  fk_rails_751162eb30  (program_id => education_programs.id)
#  fk_rails_ef5f8e1b5b  (communication_website_id => communication_websites.id)
#
class Communication::Website::Page::Category < ApplicationRecord
  include AsCategory
  include AsDirectObject
  include Sanitizable
  include Localizable
  include WithMenuItemTarget
  include WithOpenApi
  include WithUniversity

  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_and_belongs_to_many :pages
  alias                   :category_objects :pages

  def page_localizations
    Communication::Website::Page::Localization.where(about_id: page_ids)
  end

  def dependencies
    super +
    localizations.in_languages(website.active_language_ids) +
    [website.config_default_content_security_policy]
  end

  def references
    pages +
    page_localizations +
    website.menus.in_languages(website.active_language_ids) +
    [parent]
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    website.page_categories.where(parent_id: parent_id).ordered.last
  end
end
