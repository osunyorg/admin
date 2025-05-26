# == Schema Information
#
# Table name: communication_website_jobboard_categories
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
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_communication_website_id_b870d88a86                     (communication_website_id)
#  idx_on_university_id_f6904a3396                                (university_id)
#  index_communication_website_jobboard_categories_on_parent_id   (parent_id)
#  index_communication_website_jobboard_categories_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_66396bfb1b  (university_id => universities.id)
#  fk_rails_8993f78033  (communication_website_id => communication_websites.id)
#  fk_rails_c6fde92dba  (program_id => education_programs.id)
#  fk_rails_f3bebe9876  (parent_id => communication_website_jobboard_categories.id)
#
class Communication::Website::Jobboard::Category < ApplicationRecord
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
  has_and_belongs_to_many :jobs
  alias                   :category_objects :jobs

  def job_localizations
    Communication::Website::Jobboard::Job::Localization.where(about_id: job_ids)
  end

  def dependencies
    [parent] +
    localizations.in_languages(website.active_language_ids) +
    [website.config_default_content_security_policy]
  end

  def references
    jobs +
    job_localizations +
    website.menus.in_languages(website.active_language_ids) +
    [parent]
  end

  def siblings
    self.class.unscoped.where(parent: parent, university: university, website: website).where.not(id: id)
  end

  protected

  def last_ordered_element
    website.jobboard_categories.where(parent_id: parent_id).ordered.last
  end

end
