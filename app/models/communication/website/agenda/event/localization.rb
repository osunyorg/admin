# == Schema Information
#
# Table name: communication_website_agenda_event_localizations
#
#  id                       :uuid             not null, primary key
#  add_to_calendar_urls     :jsonb
#  featured_image_alt       :string
#  featured_image_credit    :text
#  header_cta               :boolean          default(FALSE)
#  header_cta_label         :string
#  header_cta_url           :string
#  meta_description         :string
#  migration_identifier     :string
#  notes                    :text
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string
#  subtitle                 :string
#  summary                  :text
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_db6323806a                  (about_id)
#  idx_on_communication_website_id_87f393a516  (communication_website_id)
#  idx_on_language_id_c00e1d0218               (language_id)
#  idx_on_university_id_eaf79b0514             (university_id)
#
# Foreign Keys
#
#  fk_rails_5b3e0f2f0c  (language_id => languages.id)
#  fk_rails_945cb27530  (about_id => communication_website_agenda_events.id)
#  fk_rails_991b1838ec  (university_id => universities.id)
#  fk_rails_bb85c47fb8  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Event::Localization < ApplicationRecord
  include AddableToCalendar
  # Needs to be included before Sluggable (which is included by Permalinkable)
  include AsDirectObjectLocalization
  include AsLocalization
  include AsLocalizedTree
  include Contentful
  include HasGitFiles
  include HeaderCallToAction
  include Initials
  include Permalinkable # slug_unavailable method overwrite in this file
  include Publishable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithOpenApi
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :event :about

  delegate  :archive?,
            :from_day,
            :to_day,
            :time_zone,
            :kind_simple?,
            :kind_recurring?,
            :kind_parent?,
            :kind_child?,
            to: :event

  has_summernote :summary
  has_summernote :text
  has_summernote :notes

  validates :title, presence: true
  validate :slug_cant_be_numeric_only

  scope :archivable, -> (datetime) {
    joins(:about)
      .where.not(communication_website_agenda_events: { is_lasting: true })
      .published
      .where("communication_website_agenda_events.to_day < ?", datetime.to_date)
  }

  # events/2025/01/01-arte-concert-festival.html
  def git_path_relative
    "events/#{from_day.strftime "%Y/%m/%d"}-#{slug}#{event.suffix_in(website)}.html"
  end

  def should_sync_to?(website)
    event.allowed_in?(website) &&
    website.active_language_ids.include?(language_id) &&
    published? &&
    event.time_slots.none? && # Rendered by Communication::Website::Agenda::Event::TimeSlot
    event.children.none? # Rendered by Communication::Website::Agenda::Event::Day
  end

  def template_static
    "admin/communication/websites/agenda/events/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
    days
  end

  def days
    event.days.where(language: language)
  end

  def categories
    about.categories.ordered.map { |category| category.localization_for(language) }.compact
  end

  # Utility method to give parent localization
  def parent
    event.parent&.localization_for(language)
  end

  def hugo(website)
    if event.time_slots.any?
      hugo_for_time_slots(website)
    elsif event.kind_parent?
      hugo_for_parent(website)
    else
      super(website)
    end
  end

  def to_s
    "#{title}"
  end

  def to_s_with_subtitle
    [title, subtitle].compact_blank.join(' - ')
  end

  protected

  def hugo_for_time_slots(website)
    time_slot = event.time_slots.ordered.first
    time_slot_l10n = time_slot.localization_for(language)
    return hugo_nil if time_slot_l10n.nil?
    time_slot_l10n.hugo(website)
  end

  def hugo_for_parent(website)
    first_child = event.children.published_now_in(language).ordered.first
    return hugo_nil if first_child.nil?
    day = event.days.where(language: language, date: first_child.from_day).first
    return hugo_nil if day.nil?
    day.hugo(website)
  end

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    if about.parent_id.present?
      self.class.unscoped
                .left_joins(:about)
                .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
                .where.not(id: self.id)
                .where(about: { parent_id: about.parent_id })
                .exists?
    else
      self.class.unscoped
                .left_joins(:about)
                .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
                .where.not(id: self.id)
                .where("date_part('year', communication_website_agenda_events.from_day) = ?", about.from_day&.year)
                .exists?
    end
  end

  def slug_cant_be_numeric_only
    errors.add(:slug, :numeric_only) if slug.tr('0-9', '').blank?
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

  def localize_other_attachments(localization)
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end

end
