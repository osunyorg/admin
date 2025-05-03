# == Schema Information
#
# Table name: communication_website_portfolio_category_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  meta_description         :text
#  name                     :string
#  path                     :string
#  slug                     :string
#  summary                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_e184bfe637                  (about_id)
#  idx_on_communication_website_id_9d28ee55e4  (communication_website_id)
#  idx_on_language_id_70b50689c4               (language_id)
#  idx_on_university_id_66e101bf70             (university_id)
#
# Foreign Keys
#
#  fk_rails_6dd917d73a  (language_id => languages.id)
#  fk_rails_b75b5471d3  (about_id => communication_website_portfolio_categories.id)
#  fk_rails_c8c00a26df  (communication_website_id => communication_websites.id)
#  fk_rails_e84628b736  (university_id => universities.id)
#
class Communication::Website::Portfolio::Category::Localization < ApplicationRecord
  include AsCategoryLocalization
  include AsDirectObject

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}projects_categories/#{slug_with_ancestors_slugs}/_index.html"
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
