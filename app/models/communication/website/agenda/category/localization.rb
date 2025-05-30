# == Schema Information
#
# Table name: communication_website_agenda_category_localizations
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
#  idx_on_about_id_012efb471f                  (about_id)
#  idx_on_communication_website_id_2eaea4d96e  (communication_website_id)
#  idx_on_language_id_8542c3d2f9               (language_id)
#  idx_on_slug_55ae2c29d7                      (slug)
#  idx_on_university_id_934ff72e5e             (university_id)
#
# Foreign Keys
#
#  fk_rails_238c80122e  (language_id => languages.id)
#  fk_rails_4adca7760a  (communication_website_id => communication_websites.id)
#  fk_rails_622a67bc3b  (university_id => universities.id)
#  fk_rails_b8a90413e8  (about_id => communication_website_agenda_categories.id)
#
class Communication::Website::Agenda::Category::Localization < ApplicationRecord
  # Needs to be included before Sluggable (which is included by AsCategoryLocalization > Permalinkable)
  include AsDirectObjectLocalization
  include AsCategoryLocalization
  include WithOpenApi

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  def git_path(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}events_categories/#{slug_with_ancestors_slugs}/_index.html"
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

end
