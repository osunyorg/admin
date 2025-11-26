# == Schema Information
#
# Table name: communication_website_post_categories
#
#  id                       :uuid             not null, primary key
#  bodyclass                :string
#  is_programs_root         :boolean          default(FALSE)
#  is_taxonomy              :boolean          default(FALSE)
#  migration_identifier     :string
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
#  idx_communication_website_post_cats_on_communication_website_id  (communication_website_id)
#  index_communication_website_post_categories_on_parent_id         (parent_id)
#  index_communication_website_post_categories_on_program_id        (program_id)
#  index_communication_website_post_categories_on_university_id     (university_id)
#
# Foreign Keys
#
#  fk_rails_86a9ce3cea  (parent_id => communication_website_post_categories.id)
#  fk_rails_9d4210dc43  (university_id => universities.id)
#  fk_rails_c7c9f7ddc7  (communication_website_id => communication_websites.id)
#  fk_rails_e58348b119  (program_id => education_programs.id)
#
class Communication::Website::Post::Category < ApplicationRecord
  include AsCategory
  include AsDirectObject
  include GeneratesGitFiles
  include Localizable
  include Sanitizable
  include WithMenuItemTarget
  include WithOpenApi
  include HasListBlocks
  include WithUniversity

  belongs_to              :program,
                          class_name: 'Education::Program',
                          optional: true
  has_and_belongs_to_many :posts
  alias                   :category_objects :posts

  def post_localizations
    Communication::Website::Post::Localization.where(about_id: post_ids)
  end

  def dependencies
    [parent] +
    localizations.in_languages(website.active_language_ids) +
    [website.config_default_content_security_policy]
  end

  def references
    posts +
    post_localizations.in_languages(website.active_language_ids) +
    [parent] +
    siblings +
    website.menus.in_languages(website.active_language_ids)
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    website.post_categories.where(parent_id: parent_id).ordered.last
  end

  def list_blocks_template_kind
    :posts
  end
end
