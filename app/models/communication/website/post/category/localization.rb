# == Schema Information
#
# Table name: communication_website_post_category_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  meta_description         :text
#  name                     :string
#  path                     :string
#  slug                     :string
#  summary                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_6e430d4efc                  (about_id)
#  idx_on_communication_website_id_0c06c1ae6f  (communication_website_id)
#  idx_on_language_id_cc5f73e306               (language_id)
#  idx_on_university_id_fb03a6e3c0             (university_id)
#
# Foreign Keys
#
#  fk_rails_04d5596411  (communication_website_id => communication_websites.id)
#  fk_rails_49ba67b5ed  (university_id => universities.id)
#  fk_rails_9edc398287  (about_id => communication_website_post_categories.id)
#  fk_rails_e1dc625b2e  (language_id => languages.id)
#
class Communication::Website::Post::Category::Localization < ApplicationRecord
  include AsCategoryLocalization
  include AsDirectObject

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}posts_categories/#{slug_with_ancestors_slugs}/_index.html"
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
