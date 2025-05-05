# == Schema Information
#
# Table name: communication_website_page_category_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  meta_description         :text
#  migration_identifier     :string
#  name                     :string
#  path                     :string
#  slug                     :string
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
#  idx_on_about_id_6c76163c36                  (about_id)
#  idx_on_communication_website_id_f605face95  (communication_website_id)
#  idx_on_language_id_adc4ce8d8e               (language_id)
#  idx_on_university_id_2237677b2f             (university_id)
#
# Foreign Keys
#
#  fk_rails_37a52c472a  (communication_website_id => communication_websites.id)
#  fk_rails_bfcb0cd4b4  (language_id => languages.id)
#  fk_rails_c523df1672  (university_id => universities.id)
#  fk_rails_ee39c2fc35  (about_id => communication_website_page_categories.id)
#
class Communication::Website::Page::Category::Localization < ApplicationRecord
  include AsCategoryLocalization
  include WithOpenApi

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}pages_categories/#{slug_with_ancestors_slugs}/_index.html"
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
