# == Schema Information
#
# Table name: communication_website_jobboard_category_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  meta_description         :text
#  migration_identifier     :string
#  name                     :string
#  path                     :string
#  slug                     :string           indexed
#  summary                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_973f5413e1                  (about_id)
#  idx_on_communication_website_id_1bf1f14ca6  (communication_website_id)
#  idx_on_language_id_56b9ed6a5c               (language_id)
#  idx_on_slug_6db7a1bcbc                      (slug)
#  idx_on_university_id_f8e53f00be             (university_id)
#
# Foreign Keys
#
#  fk_rails_2c50a1c781  (about_id => communication_website_jobboard_categories.id)
#  fk_rails_4b878426e9  (language_id => languages.id)
#  fk_rails_58d0ec0384  (communication_website_id => communication_websites.id)
#  fk_rails_c9af6a3d24  (university_id => universities.id)
#
class Communication::Website::Jobboard::Category::Localization < ApplicationRecord
  include AsCategoryLocalization

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}jobs_categories/#{slug_with_ancestors_slugs}/_index.html"
  end

  protected

  def slug_unavailable?(slug)
    self.class
        .unscoped
        .where(
          communication_website_id: self.communication_website_id,
          language_id: language_id,
          slug: slug
        )
        .where.not(id: self.id)
        .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

end
