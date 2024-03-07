# == Schema Information
#
# Table name: communication_website_portfolio_projects
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  meta_description         :text
#  published                :boolean          default(FALSE)
#  slug                     :string
#  summary                  :text
#  title                    :string
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  original_id              :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_aac12e3adb                     (communication_website_id)
#  idx_on_university_id_ac2f4a0bfc                                (university_id)
#  index_communication_website_portfolio_projects_on_language_id  (language_id)
#  index_communication_website_portfolio_projects_on_original_id  (original_id)
#
# Foreign Keys
#
#  fk_rails_5c5fb357a3  (original_id => communication_website_portfolio_projects.id)
#  fk_rails_6b220c2717  (communication_website_id => communication_websites.id)
#  fk_rails_810f9f3908  (language_id => languages.id)
#  fk_rails_a2d39c0893  (university_id => universities.id)
#
class Communication::Website::Portfolio::Project < ApplicationRecord
  include AsDirectObject
  include Contentful
  include Sanitizable
  include Sluggable
  include WithAccessibility
  include WithBlobs
  include WithDuplication
  include WithFeaturedImage
  include WithMenuItemTarget
  include WithPermalink
  include WithTranslations
  include WithUniversity
end
