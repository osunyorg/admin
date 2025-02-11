# == Schema Information
#
# Table name: communication_website_agenda_exhibition_localizations
#
#  id                    :uuid             not null, primary key
#  add_to_calendar_urls  :jsonb
#  featured_image_alt    :string
#  featured_image_credit :text
#  header_cta            :boolean
#  header_cta_label      :string
#  header_cta_url        :string
#  meta_description      :string
#  migration_identifier  :string
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string
#  subtitle              :string
#  summary               :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             not null, indexed
#  language_id           :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_a6e772a338       (about_id)
#  idx_on_language_id_a2de6ce8d0    (language_id)
#  idx_on_university_id_64ba331f7d  (university_id)
#
# Foreign Keys
#
#  fk_rails_ee1c77929d  (about_id => communication_website_agenda_exhibitions.id)
#  fk_rails_f684b71a8c  (university_id => universities.id)
#
class Communication::Website::Agenda::Exhibition::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include HeaderCallToAction
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  # include WithCal
  include WithFeaturedImage
  include WithGitFiles
  include WithOpenApi
  include WithPublication
  include WithUniversity
end
