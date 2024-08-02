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
#  language_id              :uuid             indexed
#  original_id              :uuid             indexed
#  parent_id                :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_agenda_events_on_communication_website_id             (communication_website_id)
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
#  fk_rails_fc3fea77c2  (original_id => communication_website_agenda_events.id)
#
class Communication::Website::Agenda::Event < ApplicationRecord
  include AsDirectObject
  include Contentful # TODO L10N : To remove
  include Initials
  include Sanitizable
  include Shareable # TODO L10N : To remove
  include Localizable
  include WithAccessibility
  include WithBlobs # TODO L10N : To remove
  include WithDuplication
  include WithFeaturedImage # TODO L10N : To remove
  include WithMenuItemTarget
  include WithTime
  include WithTree
  include WithUniversity

  belongs_to  :parent,
              class_name: 'Communication::Website::Agenda::Event',
              optional: true

  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Agenda::Category',
                          join_table: :communication_website_agenda_events_categories,
                          foreign_key: :communication_website_agenda_event_id,
                          association_foreign_key: :communication_website_agenda_category_id

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  scope :ordered_desc, -> { order(from_day: :desc, from_hour: :desc) }
  scope :ordered_asc, -> { order(:from_day, :from_hour) }
  scope :ordered, -> { ordered_asc }
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :latest, -> { published.future_or_current.order(:updated_at).limit(5) }

  scope :for_category, -> (category_id) {
    joins(:categories)
    .where(
      communication_website_agenda_categories: {
        id: category_id
      }
    )
    .distinct
  }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_website_agenda_events.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_events.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_events.title) ILIKE unaccent(:term) OR
      unaccent(communication_website_agenda_events.subtitle) ILIKE unaccent(:term)
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

  # TODO L10N : to remove
  def translate_other_attachments(translation)
    translate_attachment(translation, :shared_image) if shared_image.attached?
  end

  protected

  def abouts_with_agenda_block
    website.blocks.agenda.collect(&:about)
  end
end
