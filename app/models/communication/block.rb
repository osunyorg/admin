# == Schema Information
#
# Table name: communication_blocks
#
#  id                       :uuid             not null, primary key
#  about_type               :string           indexed => [about_id]
#  data                     :jsonb
#  migration_identifier     :string
#  position                 :integer          default(0), not null
#  published                :boolean          default(TRUE)
#  template_kind            :integer          default(NULL), not null
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed => [about_type]
#  communication_website_id :uuid             indexed
#  heading_id               :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_blocks_on_communication_website_id  (communication_website_id)
#  index_communication_blocks_on_heading_id                (heading_id)
#  index_communication_blocks_on_university_id             (university_id)
#  index_communication_website_blocks_on_about             (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_18291ef65f  (university_id => universities.id)
#  fk_rails_80e5625874  (communication_website_id => communication_websites.id)
#  fk_rails_90ac986fab  (heading_id => communication_block_headings.id)
#
class Communication::Block < ApplicationRecord
  include AsIndirectObject
  include WithAccessibility
  include WithPosition
  include WithUniversity
  include Sanitizable

  IMAGE_MAX_SIZE = 5.megabytes
  FILE_MAX_SIZE = 100.megabytes

  belongs_to :about, polymorphic: true
  belongs_to :heading, optional: true
  belongs_to  :communication_website,
              class_name: "Communication::Website",
              optional: true
  alias       :website :communication_website

  # We do not use the :touch option of the belongs_to association
  # because we do not want to touch the about when destroying the block.
  after_save :touch_about

  # Used to purge images when unattaching them
  # template_blobs would be a better name, because there are files
  has_many_attached :template_images

  # Les numéros sont un peu en vrac
  # Dans l'idée, pour le futur
  # 1000 basic
  # 2000 storytelling
  # 3000 references
  # 4000 utilities
  enum template_kind: {
    agenda: 3100,
    call_to_action: 900,
    chapter: 50,
    contact: 57,
    datatable: 54,
    definitions: 800,
    embed: 53,
    features: 2010,
    files: 55,
    gallery: 300,
    image: 51,
    key_figures: 56,
    license: 4040,
    people: 100,
    pages: 600,
    organizations: 200,
    posts: 500,
    programs: 58,
    sound: 1005,
    testimonials: 400,
    timeline: 700,
    video: 52,
  }

  CATEGORIES = {
    basic: [:chapter, :image, :video, :sound, :datatable],
    storytelling: [:key_figures, :features, :gallery, :call_to_action, :testimonials, :timeline],
    references: [:pages, :posts, :people, :organizations, :agenda, :programs],
    utilities: [:files, :definitions, :contact, :license, :embed]
  }

  scope :published, -> { where(published: true) }
  scope :without_heading, -> { where(heading: nil) }

  before_validation :set_heading_from_about, on: :create
  before_save :attach_template_blobs
  before_validation :set_university_and_website_from_about, on: :create

  # When we set data from json, we pass it to the template.
  # The json we save is first sanitized and prepared by the template.
  def data=(value)
    template.data = value
    super template.data
  end

  # Template data is clean and sanitized, and initialized with json
  def data
    template.data
  end

  def dependencies
    template.dependencies
  end

  def references
    [about]
  end

  def template
    @template ||= template_class.new self, self.attributes['data']
  end

  def template_reset!
    @template = nil
  end

  def language
    return @language if defined?(@language)
    @language ||= about.respond_to?(:language) ? about.language : about.university.default_language
  end

  def duplicate
    block = self.dup
    block.save
    block
  end

  def translate!(about_translation, heading_id = nil)
    translation = self.dup
    translation.about = about_translation
    translation.template.translate!
    translation.data = translation.template.data
    translation.heading_id = heading_id
    translation.save
  end

  def full_text
    template.full_text
  end

  def to_s
    title.blank?  ? "#{Communication::Block.model_name.human} #{position}"
                  : "#{title}"
  end

  protected

  def last_ordered_element
    about.blocks.where(heading_id: heading_id).ordered.last
  end

  def set_university_and_website_from_about
    # about always have an university_id but can have no communication_website_id
    self.university_id = about.university_id
    self.communication_website_id = about.try(:communication_website_id)
  end

  def check_accessibility
    accessibility_merge template
  end

  def template_class
    "Communication::Block::Template::#{template_kind.classify}".constantize
  end

  def set_heading_from_about
    # IMPROVEMENT: Ne gère que le 1er niveau actuellement
    self.heading ||= about.headings.root.ordered.last
  end

  # FIXME @sebou
  # Could not find or build blob: expected attachable, got #<ActiveStorage::Blob id: "f4c78657-5062-416b-806f-0b80fb66f9cd", key: "gri33wtop0igur8w3a646llel3sd", filename: "logo.svg", content_type: "image/svg+xml", metadata: {"identified"=>true, "width"=>709, "height"=>137, "analyzed"=>true}, service_name: "scaleway", byte_size: 4137, checksum: "aZqqTYabP5+72ZeddcZ/2Q==", created_at: "2022-05-05 12:17:33.941505000 +0200", university_id: "ebf2d273-ffc9-4d9f-a4ee-a2146913d617">
  def attach_template_blobs
    # self.template_images = template.active_storage_blobs
  end

  def touch_about
    about.touch
  end
end
