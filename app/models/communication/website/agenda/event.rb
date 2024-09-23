# == Schema Information
#
# Table name: communication_website_agenda_events
#
#  id                       :uuid             not null, primary key
#  add_to_calendar_urls     :jsonb
#  featured_image_alt       :text
#  featured_image_credit    :text
#  from_day                 :date
#  from_hour                :time
#  meta_description         :text
#  migration_identifier     :string
#  published                :boolean          default(FALSE)
#  slug                     :string           indexed
#  subtitle                 :string
#  summary                  :text
#  time_zone                :string
#  title                    :string
#  to_day                   :date
#  to_hour                  :time
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  created_by_id            :uuid             indexed
#  language_id              :uuid             indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_agenda_events_on_communication_website_id             (communication_website_id)
#  index_communication_website_agenda_events_on_created_by_id  (created_by_id)
#  index_communication_website_agenda_events_on_language_id    (language_id)
#  index_communication_website_agenda_events_on_original_id    (original_id)
#  index_communication_website_agenda_events_on_parent_id      (parent_id)
#  index_communication_website_agenda_events_on_slug           (slug)
#  index_communication_website_agenda_events_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_00ca585c35  (university_id => universities.id)
#  fk_rails_5fa53206f2  (communication_website_id => communication_websites.id)
#  fk_rails_67834f0062  (language_id => languages.id)
#  fk_rails_917095d5ca  (parent_id => communication_website_agenda_events.id)
#  fk_rails_c9e737a3c1  (created_by_id => users.id)
#  fk_rails_fc3fea77c2  (original_id => communication_website_agenda_events.id)
#
class Communication::Website::Agenda::Event < ApplicationRecord
  include AsDirectObject
  include Filterable
  include Sanitizable
  include Localizable
  include WithDuplication
  include WithMenuItemTarget
  include WithTime
  include WithTree
  include WithUniversity

  belongs_to  :created_by,
              class_name: "User",
              optional: true

  belongs_to  :parent,
              class_name: 'Communication::Website::Agenda::Event',
              optional: true

  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Agenda::Category',
                          join_table: :communication_website_agenda_events_categories,
                          foreign_key: :communication_website_agenda_event_id,
                          association_foreign_key: :communication_website_agenda_category_id

  scope :ordered_desc, -> { order(from_day: :desc, from_hour: :desc) }
  scope :ordered_asc, -> { order(:from_day, :from_hour) }
  scope :ordered, -> (language = nil) { ordered_asc }
  scope :latest_in, -> (language) { published_now_in(language).future_or_current.order("communication_website_agenda_event_localizations.updated_at").limit(5) }

  scope :for_category, -> (category_id, language = nil) {
    joins(:categories)
    .where(communication_website_agenda_categories: { id: category_id })
    .distinct
  }
  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_website_agenda_event_localizations: { language_id: language.id })
      . where("
      unaccent(communication_website_agenda_event_localizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_event_localizations.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_event_localizations.title) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_event_localizations.subtitle) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids)
  end

  def references
    menus +
    abouts_with_agenda_block
  end

  protected

  def abouts_with_agenda_block
    website.blocks.agenda.collect(&:about)
  end
end
