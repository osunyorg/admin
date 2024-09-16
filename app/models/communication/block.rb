# == Schema Information
#
# Table name: communication_blocks
#
#  id                       :uuid             not null, primary key
#  about_type               :string           indexed => [about_id]
#  data                     :jsonb
#  html_class               :string
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
  include WithHeadingRanks
  include WithHtmlClass
  include WithPosition
  include WithTemplate
  include WithUniversity
  include Sanitizable

  BLOCK_COPY_COOKIE = 'osuny-content-editor-block-copy'

  belongs_to  :about, polymorphic: true
  belongs_to  :communication_website,
              class_name: "Communication::Website",
              optional: true
  alias       :website :communication_website

  # We do not use the :touch option of the belongs_to association
  # because we do not want to touch the about when destroying the block.
  after_save :touch_about#, :touch_targets # FIXME

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
    links: 4050,
    locations: 3200,
    organizations: 200,
    pages: 600,
    papers: 3300,
    persons: 100,
    posts: 500,
    projects: 3101,
    programs: 58,
    sound: 1005,
    testimonials: 400,
    timeline: 700,
    video: 52,
    volumes: 3310
  }

  CATEGORIES = {
    basic: [:chapter, :image, :video, :sound, :datatable],
    storytelling: [:key_figures, :features, :gallery, :call_to_action, :testimonials, :timeline],
    references: [:pages, :posts, :persons, :organizations, :agenda, :programs, :locations, :projects, :papers, :volumes],
    utilities: [:files, :definitions, :contact, :links, :license, :embed]
  }

  scope :published, -> { where(published: true) }
  scope :without_heading, -> { where(heading: nil) }

  before_validation :set_university_and_website_from_about, on: :create

  def self.permitted_about_types
    ApplicationRecord.model_names_with_concern(Contentful)
  end

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

  def language
    return @language if defined?(@language)
    @language ||= about.respond_to?(:language) ? about.language : about.university.default_language
  end

  def is_a_translation?
    about.respond_to?(:is_a_translation?) && about.is_a_translation?
  end

  def original_language
    about.try(:original_language)
  end

  def duplicate
    block = self.dup
    block.save
    block
  end

  def paste(about)
    block = self.dup
    block.about = about
    block.heading = nil
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

  def empty?
    template.empty?
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

  def touch_about
    about.touch
  end

  # Invalidation des caches des personnes pour les backlinks
  # if a block changed we need to touch the old targets (for example persons previously connected), and the new connected ones
  # FIXME
  def touch_targets
    if persons? || organizations?
      dependencies.each(&:touch)
      # TODO: @arnaud help!
      # I need to touch the old dependencies
      # Ideally we should only touch the diff between old and new dependencies
    end
  end

end
