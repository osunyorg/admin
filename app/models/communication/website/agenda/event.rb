# == Schema Information
#
# Table name: communication_website_agenda_events
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  from_day                 :date
#  from_hour                :time
#  meta_description         :text
#  published                :boolean          default(FALSE)
#  slug                     :text
#  summary                  :text
#  title                    :string
#  to_day                   :date
#  to_hour                  :time
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
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
  include Sanitizable
  include WithAccessibility
  include WithBlobs
  include WithBlocks
  include WithDuplication
  include WithFeaturedImage
  include WithMenuItemTarget
  include WithPermalink
  include WithSlug
  include WithTranslations
  include WithTree
  include WithUniversity

  belongs_to  :parent,
              class_name: 'Communication::Website::Agenda::Event',
              optional: true

  scope :ordered_desc, -> { order(from_day: :desc, from_hour: :desc) }
  scope :ordered_asc, -> { order(:from_day, :from_hour) }
  scope :ordered, -> { ordered_asc }
  scope :recent, -> { order(:updated_at).limit(5) }
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :future, -> { where('from_day > :today', today: Date.today).ordered_asc }
  scope :future_or_present, -> { where('from_day >= :today', today: Date.today).ordered_asc }
  scope :present, -> { where('(from_day >= :today AND to_day IS NULL) OR (from_day >= :today AND to_day <= :today)', today: Date.today).ordered_asc }
  scope :archive, -> { where('to_day < :today', today: Date.today).ordered_desc }
  scope :past, -> { archive }

  validates_presence_of :from_day, :title
  validate :to_day_after_from_day, :to_hour_after_from_hour_on_same_day

  STATUS_FUTURE = 'future'
  STATUS_PRESENT = 'present'
  STATUS_ARCHIVE = 'archive'

  def status
    if future?
      STATUS_FUTURE
    elsif present?
      STATUS_PRESENT
    else
      STATUS_ARCHIVE
    end
  end

  def future?
    from_day > Date.today
  end

  def present?
    to_day.present? ? (Date.today >= from_day && Date.today <= to_day)
                    : from_day == Date.today
  end

  def archive?
    status == STATUS_ARCHIVE
  end

  # Un événement demain aura une distance de 1, comme un événement hier
  # On utilise cette info pour classer les événements à venir dans un sens et les archives dans l'autre
  def distance_in_days
    (Date.today - from_day).to_i.abs
  end

  def git_path(website)
    return unless website.id == communication_website_id && published
    path = "#{git_path_content_prefix(website)}events/"
    path += "archives/#{from_day.year}/" if archive?
    path += "#{from_day.strftime "%Y-%m-%d"}-#{slug}.html"
    path
  end

  def template_static
    "admin/communication/websites/agenda/events/static"
  end

  def dependencies
    active_storage_blobs +
    blocks
  end

  def to_s
    "#{title}"
  end

  protected

  def to_day_after_from_day
    errors.add(:to_day, :too_soon) if to_day.present? && to_day < from_day
  end

  def to_hour_after_from_hour_on_same_day
    return if from_day != to_day
    errors.add(:to_hour, :too_soon) if to_hour.present? && from_hour.present? && to_hour < from_hour
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end
end
