# == Schema Information
#
# Table name: education_program_localizations
#
#  id                     :uuid             not null, primary key
#  accessibility          :text
#  contacts               :text
#  content                :text
#  duration               :string
#  evaluation             :text
#  featured_image_alt     :string
#  featured_image_credit  :text
#  meta_description       :text
#  name                   :string
#  objectives             :text
#  opportunities          :text
#  other                  :text
#  path                   :string
#  pedagogy               :text
#  prerequisites          :text
#  presentation           :text
#  pricing                :text
#  pricing_apprenticeship :text
#  pricing_continuing     :text
#  pricing_initial        :text
#  published              :boolean          default(FALSE)
#  published_at           :datetime
#  qualiopi_text          :text
#  registration           :text
#  registration_url       :string
#  results                :text
#  short_name             :string
#  slug                   :string
#  summary                :text
#  url                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  about_id               :uuid             indexed
#  language_id            :uuid             indexed
#  university_id          :uuid             indexed
#
# Indexes
#
#  index_education_program_localizations_on_about_id       (about_id)
#  index_education_program_localizations_on_language_id    (language_id)
#  index_education_program_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_3e759230aa  (about_id => education_programs.id)
#  fk_rails_66267db4ba  (language_id => languages.id)
#  fk_rails_e375f2df91  (university_id => universities.id)
#
class Education::Program::Localization < ApplicationRecord
  include AsLocalization
  include AsLocalizedTree # ordered scope is overridden below
  include Contentful
  include Initials
  include Pathable
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithInheritance
  include WithPublication
  include WithUniversity

  has_summernote :summary
  has_summernote :presentation
  has_one_attached_deletable :downloadable_summary
  has_one_attached_deletable :logo
  rich_text_areas_with_inheritance  :accessibility,
                                    :contacts,
                                    :evaluation,
                                    :objectives,
                                    :opportunities,
                                    :other,
                                    :pedagogy,
                                    :prerequisites,
                                    :pricing,
                                    :pricing_apprenticeship,
                                    :pricing_continuing,
                                    :pricing_initial,
                                    :registration,
                                    :content,
                                    :results

  validates :name, presence: true
  validates :downloadable_summary, size: { less_than: 50.megabytes }
  validates :logo, size: { less_than: 5.megabytes }

  scope :ordered, -> (language = nil) { order(:slug) }

  def git_path(website)
    return unless published? && for_website?(website)
    clean_path = Static.clean_path "#{git_path_content_prefix(website)}programs/#{path}/"
    "#{clean_path}_index.html"
  end

  def template_static
    "admin/education/programs/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
    [diploma]
  end

  def references
    schools +
    siblings +
    descendants +
    [parent]
  end

  def blocks_heading_rank_base
    3
  end

  def best_featured_image_source(fallback: true)
    return self if featured_image.attached?
    best_source = parent&.best_featured_image_source(fallback: false)
    best_source ||= self if fallback
    best_source
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id,
      downloadable_summary&.blob_id,
      logo&.blob_id
    ]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end

  def diploma
    return if about.diploma.nil?
    about.diploma.best_localization_for(language)
  end

  def schools
    @schools ||= about.schools
                      .ordered(language)
                      .map { |school| school.localization_for(language) }
                      .compact
  end

  def parent
    return if about.parent.nil?
    about.parent.best_localization_for(language)
  end

  def to_short_s
    short_name.blank? ? to_s : short_name
  end

  def to_s
    "#{name}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  # Override Staticable to add diploma between special page and program's ancestors
  # Example: IUT de Bordeaux > Formations > BUT > Génie biologique > Agronomie
  def hugo_ancestors(website)
    ancestors = []
    ancestors.concat hugo_ancestors_for_special_page(website)
    ancestors << diploma if diploma.present?
    ancestors.concat self.ancestors if respond_to?(:ancestors)
    ancestors.compact
  end
end
